// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nodeinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeInfo _$NodeInfoFromJson(Map<String, dynamic> json) => NodeInfo(
      collateral: json['collateral'] as String,
      txhash: json['txhash'] as String,
      outidx: json['outidx'] as String,
      ip: json['ip'] as String,
      network: json['network'] as String,
      tier: json['tier'] as String,
      payment_address: json['payment_address'] as String,
      pubkey: json['pubkey'] as String,
      activesince: json['activesince'] as String,
      lastpaid: json['lastpaid'] as String,
      amount: json['amount'] as String,
      scriptPubKey: json['scriptPubKey'] as String,
    )
      ..name = json['name'] as String?
      ..provider = json['provider'] as String?
      ..price = (json['price'] as num?)?.toDouble()
      ..added_height = json['added_height'] as int?
      ..confirmed_height = json['confirmed_height'] as int?
      ..last_confirmed_height = json['last_confirmed_height'] as int?
      ..last_paid_height = json['last_paid_height'] as int?
      ..rank = json['rank'] as int?
      ..satoshis = json['satoshis'] as int?
      ..height = json['height'] as int?
      ..confirmations = json['confirmations'] as int?;

Map<String, dynamic> _$NodeInfoToJson(NodeInfo instance) => <String, dynamic>{
      'name': instance.name,
      'provider': instance.provider,
      'price': instance.price,
      'collateral': instance.collateral,
      'txhash': instance.txhash,
      'outidx': instance.outidx,
      'ip': instance.ip,
      'network': instance.network,
      'added_height': instance.added_height,
      'confirmed_height': instance.confirmed_height,
      'last_confirmed_height': instance.last_confirmed_height,
      'last_paid_height': instance.last_paid_height,
      'tier': instance.tier,
      'payment_address': instance.payment_address,
      'pubkey': instance.pubkey,
      'activesince': instance.activesince,
      'lastpaid': instance.lastpaid,
      'amount': instance.amount,
      'rank': instance.rank,
      'satoshis': instance.satoshis,
      'height': instance.height,
      'confirmations': instance.confirmations,
      'scriptPubKey': instance.scriptPubKey,
    };
