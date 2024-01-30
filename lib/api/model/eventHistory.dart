import 'package:json_annotation/json_annotation.dart';

part 'eventHistory.g.dart';

@JsonSerializable()
class EventHistory {
  List<int?> monthlyCost;
  List<NodeEvent?> nodeActivity;

  EventHistory({
    required this.monthlyCost,
    required this.nodeActivity,
  });

  factory EventHistory.fromJson(Map<String, dynamic> json) =>
      _$EventHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$EventHistoryToJson(this);
}

@JsonSerializable()
class NodeEvent {
  String txhash;
  String outidx;
  int timestamp;
  String provider;
  String status;

  NodeEvent({
    required this.txhash,
    required this.outidx,
    required this.timestamp,
    required this.provider,
    required this.status,
  });

  factory NodeEvent.fromJson(Map<String, dynamic> json) =>
      _$NodeEventFromJson(json);
  Map<String, dynamic> toJson() => _$NodeEventToJson(this);
}
