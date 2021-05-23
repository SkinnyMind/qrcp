import 'package:qrcp/qr/qr.dart';

void main(List args) {
  final serverIP = '192.168.0.1';
  final qr = generateQR('http://$serverIP/${args[0]}/qWe3');

  print(qr);
}
