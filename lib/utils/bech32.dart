const List<int> GENERATOR = [
  0x3b6a57b2,
  0x26508e6d,
  0x1ea119fa,
  0x3d4233dd,
  0x2a1462b3
];
const String CHARSET = 'qpzry9x8gf2tvdw0s3jn54khce6mua7l';

bool isValidBech32Address(String address) {
  // Check if address starts with "bc1"
  if (!address.startsWith("bc1")) {
    return false;
  }

  // Decode the Bech32 address
  try {
    final decoded = _bech32Decode(address);
    return decoded != null;
  } catch (e) {
    return false;
  }
}

List<int>? _bech32Decode(String bech) {
  final separatorIndex = bech.lastIndexOf('1');
  if (separatorIndex == -1) {
    return null;
  }

  final prefix = bech.substring(0, separatorIndex);
  final data =
      bech.substring(separatorIndex + 1).split('').map(_charsetRev).toList();

  if (prefix.isEmpty || data.contains(-1)) {
    return null;
  }

  final polymod = _bech32Polymod([..._expandPrefix(prefix), ...data]);
  if (polymod != 1) {
    return null;
  }

  return data;
}

int _charsetRev(String c) {
  final index = CHARSET.indexOf(c);
  return index == -1 ? -1 : index;
}

int _bech32Polymod(List<int> values) {
  var chk = 1;
  for (final v in values) {
    final top = chk >> 25;
    chk = (chk & 0x1ffffff) << 5 ^ v;
    for (var i = 0; i < 5; ++i) {
      if ((top >> i & 1) == 1) {
        chk ^= GENERATOR[i];
      }
    }
  }
  return chk;
}

List<int> _expandPrefix(String prefix) {
  final ret = <int>[];
  for (final x in prefix.split('')) {
    ret.add(x.codeUnitAt(0) >> 5);
  }
  ret.add(0);
  for (final x in prefix.split('')) {
    ret.add(x.codeUnitAt(0) & 31);
  }
  return ret;
}
