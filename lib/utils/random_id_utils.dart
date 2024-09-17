import 'dart:math';

String generateRandomId(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length, (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}