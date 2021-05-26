import 'package:qrcp/qr/qr.dart';

void main(List args) {
  if (args.isEmpty) {
    print('Please provide the filename to transfer');
  } else if (args[0] != 'receive') {
    // TODO: check for existance of file
    _generateQRandServe('send');
  } else if (args[0] == 'receive') {
    // TODO: implement file receiving
    _generateQRandServe('receive');
  } else {
    print('Error!');
    print('Usage:');
    print('Send file: qrcp MyDocument.pdf');
    print('Receive file: qrcp receive');
  }
}

void _generateQRandServe(String action) {
  final serverIP = '192.168.0.1:1337';
  final qr = generateQR('http://$serverIP/$action/qWe3');

  print('Scan the following URL with QR scanner to start the file transfer:');
  print('http://$serverIP/$action/qWe3');
  print('');
  print(qr);
}
