import 'dart:async';
import 'dart:io';

import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

Future<HttpServer> send({
  required String action,
  required String address,
  required String urlPath,
  required String filePath,
}) async {
  final router = Router();

  final file = File(filePath);

  router.get('/<action>/<urlPath>', (
    Request request,
    String action,
    String urlPath,
  ) {
    return Response.ok(
      file.openRead(),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/octet-stream',
        'Content-Disposition':
            'attachment; filename="${file.path.split('/').last}"',
      },
    );
  });

  return shelf_io.serve(router, '$address', 0);
}

Future<HttpServer> receive({
  required String action,
  required String address,
  required String urlPath,
}) async {
  final router = Router();

  final uploadPage = '''
<!doctype html>
<html>
  <head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, user-scalable=no">
  <title>qrcp</title>
  </head>
  <body>
    <h3>Select a file to transfer</h3>
    <form id="upload-form">
      <input type="file" name="file" /><br /><br />
      <input type="submit" id="submit" name="submit" value="Transfer" />
    </form>
    <script>
        var uploadForm = document.getElementById('upload-form')
        uploadForm.addEventListener('submit', function(e) {
            e.preventDefault()
            var xhr = new XMLHttpRequest()
            // Put the request response HTML ('Done' page) on the window
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    document.write(xhr.response)
                }
            }
            var formData = new FormData(uploadForm)
            xhr.open("POST", "")
            xhr.send(formData)
        })
    </script>
  </body>
</html>
  ''';

  final donePage = '''
<!doctype html>
<html>
  <head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, user-scalable=no">
  <title>qrcp</title>
  </head>
  <body>
    <h3>Transfer completed successfully, you can close this page.</h3>
  </body>
</html>
  ''';

  Future upload(Request request) async {
    var header = HeaderValue.parse(request.headers['content-type']!);

    await for (MimeMultipart part
        in MimeMultipartTransformer(header.parameters['boundary']!)
            .bind(request.read())) {
      header = HeaderValue.parse(part.headers['content-disposition']!);
      final fileName = header.parameters['filename']!;
      final file = File(fileName);
      var fileSink = file.openWrite();
      await part.pipe(fileSink);
      await fileSink.close();
    }
  }

  router.get('/<action>/<urlPath>', (
    Request request,
    String action,
    String urlPath,
  ) {
    return Response.ok(
      uploadPage,
      headers: {HttpHeaders.contentTypeHeader: 'text/html'},
    );
  });

  router.post('/<action>/<urlPath>', (
    Request request,
    String action,
    String urlPath,
  ) async {
    await upload(request);
    return Response.ok(
      donePage,
      headers: {HttpHeaders.contentTypeHeader: 'text/html'},
    );
  });

  return shelf_io.serve(router, '$address', 0);
}
