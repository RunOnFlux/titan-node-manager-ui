import 'package:json_annotation/json_annotation.dart';

part 'nodeinfo.g.dart';

// @JsonSerializable()
// class NodeInfoReponse {
//   List<NodeInfo> data;

//   NodeInfoReponse({
//     required this.data,
//   });
// }

@JsonSerializable()
class NodeInfo {
  String? name;
  String? provider;
  int? price;
  String collateral;
  String txhash;
  String outidx;
  String ip;
  String network;
  int? added_height;
  int? confirmed_height;
  int? last_confirmed_height;
  int? last_paid_height;
  String tier;
  String payment_address;
  String pubkey;
  int? activesince;
  int? lastpaid;
  int? amount;
  int? rank;
  int? satoshis;
  int? height;
  int? confirmations;
  String scriptPubKey;

  NodeInfo({
    // required this.name,
    // required this.provider,
    // required this.price,
    required this.collateral,
    required this.txhash,
    required this.outidx,
    required this.ip,
    required this.network,
    // required this.added_height,
    // required this.confirmed_height,
    // required this.last_confirmed_height,
    // required this.last_paid_height,
    required this.tier,
    required this.payment_address,
    required this.pubkey,
    required this.activesince,
    required this.lastpaid,
    required this.amount,
    // required this.rank,
    // required this.satoshis,
    // required this.height,
    // required this.confirmation,
    required this.scriptPubKey,
  });

  factory NodeInfo.fromJson(Map<String, dynamic> json) =>
      _$NodeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$NodeInfoToJson(this);
}
