// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventHistory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventHistory _$EventHistoryFromJson(Map<String, dynamic> json) => EventHistory(
      monthlyCost:
          (json['monthlyCost'] as List<dynamic>).map((e) => e as int?).toList(),
      nodeActivity: (json['nodeActivity'] as List<dynamic>)
          .map((e) =>
              e == null ? null : NodeEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventHistoryToJson(EventHistory instance) =>
    <String, dynamic>{
      'monthlyCost': instance.monthlyCost,
      'nodeActivity': instance.nodeActivity,
    };

NodeEvent _$NodeEventFromJson(Map<String, dynamic> json) => NodeEvent(
      txhash: json['txhash'] as String,
      outidx: json['outidx'] as String,
      timestamp: json['timestamp'] as int,
      provider: json['provider'] as String,
      status: json['status'] as String,
      ip: json['ip'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$NodeEventToJson(NodeEvent instance) => <String, dynamic>{
      'txhash': instance.txhash,
      'outidx': instance.outidx,
      'timestamp': instance.timestamp,
      'provider': instance.provider,
      'status': instance.status,
      'ip': instance.ip,
      'name': instance.name,
    };
