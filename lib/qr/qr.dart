import 'package:qr/qr.dart';

String generateQR(String data) {
  final qrCode = QrCode.fromData(
    data: data,
    errorCorrectLevel: QrErrorCorrectLevel.L,
  )..make();

  var result = StringBuffer();

  // Draws dark blocks in terminal with light background.
  // Swap ternary result if your terminal have dark bacgkround.
  // Most of the qr scanners won't have any problems reading qr either way.
  for (var y = 0; y < qrCode.moduleCount; y += 2) {
    // even number of rows in qr
    if (y != qrCode.moduleCount - 1) {
      for (var x = 0; x < qrCode.moduleCount; x++) {
        if (qrCode.isDark(x, y) == qrCode.isDark(x, y + 1)) {
          qrCode.isDark(x, y) ? result.write('█') : result.write(' ');
        } else {
          qrCode.isDark(x, y) ? result.write('▀') : result.write('▄');
        }
      }
      result.write('\n');
    } else {
      // special treatment for last row in odd numbered qr
      for (var x = 0; x < qrCode.moduleCount; x++) {
        qrCode.isDark(x, y) ? result.write('▀') : result.write(' ');
      }
    }
  }
  return result.toString();
}
