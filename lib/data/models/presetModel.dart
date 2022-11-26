import 'dart:ffi';

class PresetModel {
  late int frontSeconds;
  late int rearSeconds;
  late String frontDir;
  late String rearDir;

  PresetModel({
    required this.frontSeconds,
    required this.rearSeconds,
    required this.frontDir,
    required this.rearDir,
  });

  PresetModel.fromJson(Map<String, dynamic> json) {
    frontSeconds = json['frontSeconds'];
    rearSeconds = json['rearSeconds'];
    frontDir = json['frontDir'];
    rearDir = json['rearDir'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['frontSeconds'] = frontSeconds;
    data['rearSeconds'] = rearSeconds;
    data['frontDir'] = frontDir;
    data['rearDir'] = rearDir;
    return data;
  }

  static PresetModel newInstance = PresetModel(
    frontSeconds: 0,
    rearSeconds: 0,
    frontDir: 'd',
    rearDir: 'd',
  );
}
