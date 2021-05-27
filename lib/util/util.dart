import 'dart:math';

/// Returns a random string of 4 alphanumeric characters
String getRandomUrlPath() {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final _rng = Random();
  return String.fromCharCodes(
    Iterable.generate(
      4,
      (_) => _chars.codeUnitAt(_rng.nextInt(_chars.length)),
    ),
  );
}
