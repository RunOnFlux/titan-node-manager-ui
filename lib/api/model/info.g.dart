// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      runningFlux: json['runningFlux'] as int,
      inactiveFlux: json['inactiveFlux'] as int,
      active: json['active'] as int,
      inactive: json['inactive'] as int,
      cumulus: json['cumulus'] as int,
      nimbus: json['nimbus'] as int,
      stratus: json['stratus'] as int,
      nextPaymentWindow: json['nextPaymentWindow'] as int,
      time: json['time'] as int,
      providers:
          (json['providers'] as List<dynamic>).map((e) => e as String).toList(),
      cost: Cost.fromJson(json['cost'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'runningFlux': instance.runningFlux,
      'inactiveFlux': instance.inactiveFlux,
      'active': instance.active,
      'inactive': instance.inactive,
      'cumulus': instance.cumulus,
      'nimbus': instance.nimbus,
      'stratus': instance.stratus,
      'nextPaymentWindow': instance.nextPaymentWindow,
      'time': instance.time,
      'cost': instance.cost,
      'providers': instance.providers,
    };

Cost _$CostFromJson(Map<String, dynamic> json) => Cost(
      total: json['total'] as int,
      stratus: json['stratus'] as int,
      nimbus: json['nimbus'] as int,
      cumulus: json['cumulus'] as int,
    );

Map<String, dynamic> _$CostToJson(Cost instance) => <String, dynamic>{
      'total': instance.total,
      'stratus': instance.stratus,
      'nimbus': instance.nimbus,
      'cumulus': instance.cumulus,
    };
