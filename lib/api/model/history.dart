import 'package:json_annotation/json_annotation.dart';

part 'history.g.dart';

@JsonSerializable()
class History {
  List<MonthlyCost?> monthlyCost;
  List<NodeEvent?> nodeActivity;

  // {mm/dd/yyyy: [value, timestamp]}
  Map<String, List<double>?> dailyEarnings; // value = earnings
  Map<String, List<double>?> dailyLoss; // value = loss


  String? _id;

  History({

    required this.monthlyCost,
    required this.nodeActivity,
    required this.dailyEarnings,
    required this.dailyLoss,
  });


  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}

@JsonSerializable()
class NodeEvent {
  String txhash;
  String outidx;
  String name;
  String provider;
  String tier;
  String status;
  String ip;
  int timestamp;

  NodeEvent({
    required this.txhash,
    required this.outidx,
    required this.name,
    required this.provider,
    required this.tier,
    required this.status,
    required this.ip,
    required this.timestamp,

  });

  factory NodeEvent.fromJson(Map<String, dynamic> json) =>
      _$NodeEventFromJson(json);
  Map<String, dynamic> toJson() => _$NodeEventToJson(this);
}

@JsonSerializable()
class MonthlyCost {
  int? cost;
  int? timestamp;

  MonthlyCost({
    required this.cost,
    required this.timestamp,
  });

  factory MonthlyCost.fromJson(Map<String, dynamic> json) =>
      _$MonthlyCostFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyCostToJson(this);
}
