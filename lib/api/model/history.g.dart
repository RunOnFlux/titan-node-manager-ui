// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      monthlyCost: (json['monthlyCost'] as List<dynamic>)
          .map((e) => e == null
              ? null
              : MonthlyCost.fromJson(e as Map<String, dynamic>))
          .toList(),
      nodeActivity: (json['nodeActivity'] as List<dynamic>)
          .map((e) =>
              e == null ? null : NodeEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyEarnings: (json['dailyEarnings'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k,
            (e as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList()),
      ),
      dailyLoss: (json['dailyLoss'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k,
            (e as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList()),
      ),
    );

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'monthlyCost': instance.monthlyCost,
      'nodeActivity': instance.nodeActivity,
      'dailyEarnings': instance.dailyEarnings,
      'dailyLoss': instance.dailyLoss,
    };

NodeEvent _$NodeEventFromJson(Map<String, dynamic> json) => NodeEvent(
      txhash: json['txhash'] as String,
      outidx: json['outidx'] as String,
      name: json['name'] as String,
      provider: json['provider'] as String,
      tier: json['tier'] as String,
      status: json['status'] as String,
      ip: json['ip'] as String,
      timestamp: json['timestamp'] as int,
    );

Map<String, dynamic> _$NodeEventToJson(NodeEvent instance) => <String, dynamic>{
      'txhash': instance.txhash,
      'outidx': instance.outidx,
      'name': instance.name,
      'provider': instance.provider,
      'tier': instance.tier,
      'status': instance.status,
      'ip': instance.ip,
      'timestamp': instance.timestamp,
    };

MonthlyCost _$MonthlyCostFromJson(Map<String, dynamic> json) => MonthlyCost(
      cost: json['cost'] as int?,
      timestamp: json['timestamp'] as int?,
    );

Map<String, dynamic> _$MonthlyCostToJson(MonthlyCost instance) =>
    <String, dynamic>{
      'cost': instance.cost,
      'timestamp': instance.timestamp,
    };
