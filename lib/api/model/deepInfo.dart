// import 'package:json_annotation/json_annotation.dart';

// part 'deep_info.g.dart';

// @JsonSerializable()
// class DeepInfo {
//   DeepInfo({
//     required this.success,
//     required this.node,
//     this.error,
//   });

//   final bool success;
//   final Node node;
//   final String? error;

//   factory DeepInfo.fromJson(Map<String, dynamic> json) =>
//       _$DeepInfoFromJson(json);
//   Map<String, dynamic> toJson() => _$DeepInfoToJson(this);
// }

// @JsonSerializable()
// class Node {
//   Node({
//     required this.id,
//     required this.results,
//   });

//   final String id;
//   final Results results;

//   factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);
//   Map<String, dynamic> toJson() => _$NodeToJson(this);
// }

// @JsonSerializable()
// class Results {
//   Results({
//     required this.nodeInfo,
//     required this.nodeStatus,
//     required this.benchmark,
//     required this.flux,
//     required this.apps,
//     required this.geolocation,
//     required this.appsHashesTotal,
//     required this.hashesPresent,
//   });

//   final NodeInfo nodeInfo;
//   final NodeStatus nodeStatus;
//   final Benchmark benchmark;
//   final Flux flux;
//   final Apps apps;
//   final Geolocation geolocation;
//   final int appsHashesTotal;
//   final int hashesPresent;

//   factory Results.fromJson(Map<String, dynamic> json) =>
//       _$ResultsFromJson(json);
//   Map<String, dynamic> toJson() => _$ResultsToJson(this);
// }

// @JsonSerializable()
// class NodeInfo {
//   NodeInfo({
//     required this.status,
//     required this.data,
//   });

//   final String status;
//   final NodeInfoData data;

//   factory NodeInfo.fromJson(Map<String, dynamic> json) =>
//       _$NodeInfoFromJson(json);
//   Map<String, dynamic> toJson() => _$NodeInfoToJson(this);
// }

// @JsonSerializable()
// class NodeInfoData {
//   NodeInfoData({
//     required this.daemon,
//     required this.node,
//     required this.benchmark,
//     required this.flux,
//     required this.apps,
//     required this.geolocation,
//     required this.appsHashesTotal,
//     required this.hashesPresent,
//   });

//   final DaemonInfo daemon;
//   final NodeStatusInfo node;
//   final BenchmarkInfo benchmark;
//   final FluxInfo flux;
//   final AppsInfo apps;
//   final GeolocationInfo geolocation;
//   final int appsHashesTotal;
//   final int hashesPresent;

//   factory NodeInfoData.fromJson(Map<String, dynamic> json) =>
//       _$NodeInfoDataFromJson(json);
//   Map<String, dynamic> toJson() => _$NodeInfoDataToJson(this);
// }

// @JsonSerializable()
// class DaemonInfo {
//   DaemonInfo({
//     required this.version,
//     required this.protocolversion,
//     required this.walletversion,
//     required this.blocks,
//     required this.timeoffset,
//     required this.connections,
//     required this.proxy,
//     required this.difficulty,
//     required this.testnet,
//     required this.keypoololdest,
//     required this.keypoolsize,
//     required this.paytxfee,
//     required this.relayfee,
//     required this.errors,
//   });

//   final int version;
//   final int protocolversion;
//   final int walletversion;
//   final int blocks;
//   final int timeoffset;
//   final int connections;
//   final String proxy;
//   final double difficulty;
//   final bool testnet;
//   final int keypoololdest;
//   final int keypoolsize;
//   final int paytxfee;
//   final double relayfee;
//   final String errors;

//   factory DaemonInfo.fromJson(Map<String, dynamic> json) =>
//       _$DaemonInfoFromJson(json);
//   Map<String, dynamic> toJson() => _$DaemonInfoToJson(this);
// }

// @JsonSerializable()
// class NodeStatusInfo {
//   NodeStatusInfo({
//     required this.status,
//     required this.collateral,
//     required this.txhash,
//     required this.outidx,
//     required this.ip,
//     required this.network,
//     required this.added_height,
//     required this.confirmed_height,
//     required this.last_confirmed_height,
//     required this.last_paid_height,
//     required this.tier,
//     required this.payment_address,
//     required this.pubkey,
//     required this.activesince,
//     required this.lastpaid,
//     required this.amount,
//   });

//   final String status;
//   final String collateral;
//   final String txhash;
//   final String outidx;
//   final String ip;
//   final String network;
//   final int added_height;
//   final int confirmed_height;
//   final int last_confirmed_height;
//   final int last_paid_height;
//   final String tier;
//   final String payment_address;
//   final String pubkey;
//   final String activesince;
//   final String lastpaid;
//   final String amount;

//   factory NodeStatusInfo.fromJson(Map<String, dynamic> json) =>
//       _$NodeStatusInfoFromJson(json);
//   Map<String, dynamic> toJson() => _$NodeStatusInfoToJson(this);
// }

// @JsonSerializable()
// class BenchmarkInfo {
//   BenchmarkInfo({
//     required this.info,
//     required this.status,
//     required this.bench,
//   });

//   final BenchmarkVersionInfo info;
//   final BenchmarkStatusInfo status;
//   final BenchmarkData bench;

//   factory BenchmarkInfo.fromJson(Map<String, dynamic> json) =>
//       _$BenchmarkInfoFromJson(json);
//   Map<String, dynamic> toJson() => _$BenchmarkInfoToJson(this);
// }

// @JsonSerializable()
// class BenchmarkVersionInfo {
//   BenchmarkVersionInfo({
//     required this.version,
//     required this.rpcport,
//   });

//   final String version;
//   final int rpcport;

//   factory BenchmarkVersionInfo.fromJson(Map<String, dynamic> json) =>
//       _$BenchmarkVersionInfoFromJson(json);
//   Map<String, dynamic> toJson() => _$BenchmarkVersionInfoToJson(this);
// }

// @JsonSerializable()
// class BenchmarkStatusInfo {
//   BenchmarkStatusInfo({
//     required this.status,
//     required this.benchmarking,
//     required this.flux,
//   });

//   final String status;
//   final String benchmarking;
//   final String flux;

//   factory BenchmarkStatusInfo.fromJson(Map<String, dynamic> json) =>
//       _$BenchmarkStatusInfoFromJson(json);
//   Map<String, dynamic> toJson() => _$BenchmarkStatusInfoToJson(this);
// }

// @JsonSerializable()
// class BenchmarkData {
//   BenchmarkData({
//     // Fill in the properties for BenchmarkData
//   });

//   // Add the fields for BenchmarkData properties
// }

// @JsonSerializable()
// class FluxInfo {
//   FluxInfo({
//     // Fill in the properties for FluxInfo
//   });

//   // Add the fields for FluxInfo properties
// }

// @JsonSerializable()
// class AppsInfo {
//   AppsInfo({
//     // Fill in the properties for AppsInfo
//   });

//   // Add the fields for AppsInfo properties
// }

// @JsonSerializable()
// class GeolocationInfo {
//   GeolocationInfo({
//     // Fill in the properties for GeolocationInfo
//   });

//   // Add the fields for GeolocationInfo properties
// }

// // Run `flutter pub run build_runner build` to generate the .g.dart files.
