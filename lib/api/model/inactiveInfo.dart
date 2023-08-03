import 'package:json_annotation/json_annotation.dart';

part 'inactiveInfo.g.dart';

@JsonSerializable()
class InactiveInfo {
  String address;
  String txid;
  int vout;
  String scriptPubKey;
  int amount;
  int satoshis;
  int height;
  int confirmations;

  InactiveInfo({
    required this.address,
    required this.txid,
    required this.vout,
    required this.scriptPubKey,
    required this.amount,
    required this.satoshis,
    required this.height,
    required this.confirmations,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InactiveInfo &&
        other.txid == txid; // compare other properties if needed
  }

  @override
  int get hashCode => txid.hashCode; // include other properties if needed

  factory InactiveInfo.fromJson(Map<String, dynamic> json) =>
      _$InactiveInfoFromJson(json);
  Map<String, dynamic> toJson() => _$InactiveInfoToJson(this);
}
