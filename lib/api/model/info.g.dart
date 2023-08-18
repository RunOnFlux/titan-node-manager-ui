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
      'providers': instance.providers,
    };
