import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void send({
  required String action,
  required String address,
  required int port,
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
        'Content-Disposition':
            'attachment; filename="${file.path.split('/').last}"',
      },
    );
  });

  await shelf_io.serve(
    router,
    '$address',
    port,
  );
}
