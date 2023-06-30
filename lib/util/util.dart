import 'dart:io';
import 'dart:math';

/// Returns a random string of 4 alphanumeric characters
String getRandomUrlPath() {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final rng = Random();
  return String.fromCharCodes(
    Iterable.generate(
      4,
      (_) => chars.codeUnitAt(rng.nextInt(chars.length)),
    ),
  );
}

/// Returns ip of selected interface
Future<String> getLocalIpAddress() async {
  final netInterfaces = await NetworkInterface.list();

  for (var i = 0; i < netInterfaces.length; i++) {
    stdout.write('${i + 1}: ${netInterfaces[i].name} ');
    for (final entry in netInterfaces[i].addresses) {
      stdout.writeln('(${entry.address})');
    }
  }

  while (true) {
    stdout.write('Please select the interface number to use: ');
    final number = int.tryParse(stdin.readLineSync()!);
    if (number != null && number >= 1 && number <= netInterfaces.length) {
      return netInterfaces[number - 1].addresses.first.address;
    }
  }
}
