import 'dart:io';

import 'package:qrcp/qr/qr.dart';
import 'package:qrcp/server/server.dart' as server;
import 'package:qrcp/util/util.dart';

void main(List args) {
  if (args.isEmpty) {
    print('Please provide the filename to transfer');
  } else if (args[0] != 'receive') {
    if (FileSystemEntity.isFileSync(args[0])) {
      _generateQRandServer(action: 'send', filePath: args[0]);
    } else {
      print(
          'Couldn\'t find "${args[0]}". Make sure file exists and you are providing correct path.');
    }
  } else if (args[0] == 'receive') {
    _generateQRandServer(action: 'receive');
  } else {
    print('Error!');
    print('Usage:');
    print('Send file: qrcp MyDocument.pdf');
    print('Receive file: qrcp receive');
  }
}

void _generateQRandServer({required String action, String? filePath}) async {
  final address = await getLocalIpAddress();
  final urlPath = getRandomUrlPath();

  final HttpServer _server;

  if (action == 'send') {
    _server = await server.send(
      action: action,
      address: address,
      urlPath: urlPath,
      filePath: filePath!,
    );
  } else {
    print('Implement receiving');
    _server = await server.send(
      action: action,
      address: address,
      urlPath: urlPath,
      filePath: filePath!,
    );
  }

  final qr = generateQR('http://$address:${_server.port}/$action/$urlPath');

  print(
      'Scan the following URL with QR scanner to start the file transfer (press CTRL+C to quit):');
  print('http://$address:${_server.port}/$action/$urlPath');
  print('');
  print(qr);
}
