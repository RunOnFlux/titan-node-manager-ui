import 'package:crypto/crypto.dart';
import 'package:collection/collection.dart';

bool isValidBase58Address(String address) {
  const base58Alphabet =
      '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  // Decode Base58
  BigInt value = BigInt.zero;
  for (var char in address.split('')) {
    value = value * BigInt.from(58) + BigInt.from(base58Alphabet.indexOf(char));
  }

  // Convert the value into a byte array
  List<int> decoded = [];
  while (value > BigInt.zero) {
    decoded.insert(0, (value % BigInt.from(256)).toInt());
    value ~/= BigInt.from(256);
  }

  // Add leading zeroes
  int leadingZeros = address.split('').takeWhile((char) => char == '1').length;
  decoded = List.filled(leadingZeros, 0) + decoded;

  // Calculate checksum
  List<int> checksum = decoded.sublist(decoded.length - 4);
  List<int> data = decoded.sublist(0, decoded.length - 4);
  List<int> hash = sha256.convert(sha256.convert(data).bytes).bytes;

  // Validate checksum
  return const ListEquality().equals(hash.sublist(0, 4), checksum);
}
