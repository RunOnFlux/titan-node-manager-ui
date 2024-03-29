// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inactiveInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InactiveInfo _$InactiveInfoFromJson(Map<String, dynamic> json) => InactiveInfo(
      address: json['address'] as String,
      txid: json['txid'] as String,
      vout: json['vout'] as int,
      scriptPubKey: json['scriptPubKey'] as String,
      amount: json['amount'] as int,
      satoshis: json['satoshis'] as int,
      height: json['height'] as int,
      confirmations: json['confirmations'] as int,
      status: json['status'] as String,
      tier: json['tier'] as String,
      ip: json['ip'] as String,
    )
      ..name = json['name'] as String?
      ..provider = json['provider'] as String?
      ..price = (json['price'] as num?)?.toDouble();

Map<String, dynamic> _$InactiveInfoToJson(InactiveInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'provider': instance.provider,
      'price': instance.price,
      'address': instance.address,
      'txid': instance.txid,
      'vout': instance.vout,
      'scriptPubKey': instance.scriptPubKey,
      'amount': instance.amount,
      'satoshis': instance.satoshis,
      'height': instance.height,
      'confirmations': instance.confirmations,
      'status': instance.status,
      'tier': instance.tier,
      'ip': instance.ip,
    };
