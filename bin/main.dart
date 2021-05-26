import 'package:qrcp/qr/qr.dart';

void main(List args) {
  final serverIP = '192.168.0.1:1337';
  final qr = generateQR('http://$serverIP/${args[0]}/qWe3');

  print('Scan the following URL with QR scanner to start the file transfer:');
  print('http://$serverIP/${args[0]}/qWe3');
  print('');
  print(qr);
}
