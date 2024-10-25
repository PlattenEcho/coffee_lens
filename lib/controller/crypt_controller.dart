import 'package:encrypt/encrypt.dart';

// Adjust the key length to 32 characters (256 bits).
final key = Key.fromUtf8('abcdefghijklmnopqrstuvwxyz123456');
final iv = IV.fromUtf8('0123456789123456');

// Encrypt the data.
String encryptMyData(String text) {
  final e = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted_data = e.encrypt(text, iv: iv);
  return encrypted_data.base64;
}

// Decrypt the data.
String decryptMyData(String text) {
  final e = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypted_data = e.decrypt(Encrypted.fromBase64(text), iv: iv);
  return decrypted_data;
}

void main() {
  String encryptedText = encryptMyData("12345");
  print("Encrypted: $encryptedText");

  String decryptedText = decryptMyData(encryptedText);
  print("Decrypted: $decryptedText");
}
