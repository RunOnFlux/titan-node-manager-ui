import 'package:json_annotation/json_annotation.dart';

part 'info.g.dart';

@JsonSerializable()
class Info {
  int runningFlux;
  int inactiveFlux;
  int active;
  int inactive;
  int cumulus;
  int nimbus;
  int stratus;
  int nextPaymentWindow;
  int time;
  List<String> providers;

  Info({
    required this.runningFlux,
    required this.inactiveFlux,
    required this.active,
    required this.inactive,
    required this.cumulus,
    required this.nimbus,
    required this.stratus,
    required this.nextPaymentWindow,
    required this.time,
    required this.providers,
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}
