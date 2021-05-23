import 'package:qr/qr.dart';

String generateQR(String data) {
  final qrCode = QrCode.fromData(
    data: data,
    errorCorrectLevel: QrErrorCorrectLevel.L,
  )..make();

  var result = '';

  for (int y = 0; y < qrCode.moduleCount; y += 2) {
    // even number of rows in qr
    if (y != qrCode.moduleCount - 1) {
      for (int x = 0; x < qrCode.moduleCount; x++) {
        if (qrCode.isDark(x, y) == qrCode.isDark(x, y + 1)) {
          qrCode.isDark(x, y) ? result += '█' : result += ' ';
        } else {
          qrCode.isDark(x, y) ? result += '▀' : result += '▄';
        }
      }
      result += '\n';
    } else {
      // special treatment for last row in odd numbered qr
      for (int x = 0; x < qrCode.moduleCount; x++) {
        qrCode.isDark(x, y) ? result += '▀' : result += ' ';
      }
    }
  }
  return result;
}
