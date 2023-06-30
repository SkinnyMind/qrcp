import 'package:qr/qr.dart';

String generateQR(String data) {
  final qrCode = QrCode.fromData(
    data: data,
    errorCorrectLevel: QrErrorCorrectLevel.L,
  );
  final qrImage = QrImage(qrCode);
  final result = StringBuffer();

  // Draws dark blocks in terminal with light background.
  // Swap ternary result if your terminal have dark bacgkround.
  // Most of the qr scanners won't have any problems reading qr either way.
  for (var y = 0; y < qrImage.moduleCount; y += 2) {
    // even number of rows in qr
    if (y != qrImage.moduleCount - 1) {
      for (var x = 0; x < qrImage.moduleCount; x++) {
        if (qrImage.isDark(x, y) == qrImage.isDark(x, y + 1)) {
          qrImage.isDark(x, y) ? result.write('█') : result.write(' ');
        } else {
          qrImage.isDark(x, y) ? result.write('▀') : result.write('▄');
        }
      }
      result.write('\n');
    } else {
      // special treatment for last row in odd numbered qr
      for (var x = 0; x < qrImage.moduleCount; x++) {
        qrImage.isDark(x, y) ? result.write('▀') : result.write(' ');
      }
    }
  }
  return result.toString();
}
