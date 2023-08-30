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
  Cost cost;

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
    required this.cost,
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

@JsonSerializable()
class Cost {
  int total;
  int stratus;
  int nimbus;
  int cumulus;

  Cost(
      {required this.total,
      required this.stratus,
      required this.nimbus,
      required this.cumulus});

  factory Cost.fromJson(Map<String, dynamic> json) => _$CostFromJson(json);
  Map<String, dynamic> toJson() => _$CostToJson(this);
}
