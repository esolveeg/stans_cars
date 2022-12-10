// ignore_for_file: non_constant_identifier_names, unused_field

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stans_cars/data/models/presetModel.dart';

class Prefs {
  static Prefs? _instance;
  SharedPreferences? prefs;
  Prefs._internal();
  static Prefs get instance {
    _instance ??= Prefs._internal();
    return _instance!;
  }

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future setDevice(String deviceInfo) async {
    //device Info will hold all needed data about device on list of strings
    // [macAddress , serialNumber]
    await prefs!.setString("device", deviceInfo);
  }

  String? getDevice() {
    return prefs!.getString("device");
  }

  Future savePresets(List<PresetModel> presets) async {
    List<Map<String, dynamic>> jsonList = [];
    presets.forEach((preset) {
      jsonList.add(preset.toJson());
    });
    await prefs!.setString("presets", jsonEncode(jsonList));
  }

  List<PresetModel> getPresets() {
    List<PresetModel> presets = [];
    var airOutPrest = PresetModel(
          frontSeconds: 4,
          rearSeconds: 4,
          frontDir: 'd',
          rearDir: 'd',
        );
    var setting = prefs!.getString("presets");
    if (setting == null) {
      return [
        PresetModel(
          frontSeconds: 0,
          rearSeconds: 0,
          frontDir: 'd',
          rearDir: 'd',
        ),
        PresetModel(
          frontSeconds: 0,
          rearSeconds: 0,
          frontDir: 'd',
          rearDir: 'd',
        ),
        PresetModel(
          frontSeconds: 0,
          rearSeconds: 0,
          frontDir: 'd',
          rearDir: 'd',
        ),
        airOutPrest
      ];
    }
    var decoded = jsonDecode(setting);
    decoded.forEach((preset) {
      presets.add(PresetModel.fromJson(preset));
    });

    presets.add(airOutPrest);

    return presets;
  }





  PresetModel getPreset(index) {
    List<PresetModel> presets = [];
    var setting = prefs!.getString("presets");
    if (setting == null) {
      return PresetModel(
          frontSeconds: 0,
          rearSeconds: 0,
          frontDir: 'd',
          rearDir: 'd',
        );
    }
    var decoded = jsonDecode(setting);
    decoded.forEach((preset) {
      presets.add(PresetModel.fromJson(preset));
    });
    return PresetModel.fromJson(decoded[index]);
  }
}
