// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stans_cars/data/models/presetModel.dart';
import 'package:stans_cars/utils/constants.dart';
import 'package:stans_cars/utils/prefs.dart';
import 'package:stans_cars/utils/uart.dart';

class Presets extends StatefulWidget {
  final List<PresetModel> presets;
  const Presets({
    Key? key,
    required this.presets,
  }) : super(key: key);

  @override
  State<Presets> createState() => _PresetsState();
}

class _PresetsState extends State<Presets> {
  Prefs prefs = Prefs.instance;
  Uart uart = Uart.instance;
  bool loading = true;
  void initState() {
    super.initState();
  }

  Widget presetFront(int index) {
    return Row(
      children: [
        Text(
          "Front",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Slider(
            min: 0.0,
            max: 10.0,
            value: widget.presets[index].frontSeconds.toDouble(),
            onChanged: (value) {
              setState(() {
                widget.presets[index].frontSeconds = value.toInt();
              });
            },
          ),
        ),
        Text(
          "${widget.presets[index].frontSeconds} S",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            iconSize: 30,
            onPressed: () {
              setState(() {
                widget.presets[index].frontDir =
                    widget.presets[index].frontDir == "u" ? "d" : "u";
              });
            },
            icon: Icon(
              widget.presets[index].frontDir == "u"
                  ? Icons.arrow_circle_up
                  : Icons.arrow_circle_down,
              color: Colors.white,
            ))
      ],
    );
  }

  Widget presetRear(int index) {
    return Row(
      children: [
        Text(
          "Rear",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Slider(
            min: 0.0,
            max: 10.0,
            value: widget.presets[index].rearSeconds.toDouble(),
            onChanged: (value) {
              setState(() {
                widget.presets[index].rearSeconds = value.toInt();
              });
            },
          ),
        ),
        Text(
          "${widget.presets[index].rearSeconds} S",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            iconSize: 30,
            onPressed: () {
              setState(() {
                widget.presets[index].rearDir =
                    widget.presets[index].rearDir == "u" ? "d" : "u";
              });
            },
            icon: Icon(
              widget.presets[index].rearDir == "u"
                  ? Icons.arrow_circle_up
                  : Icons.arrow_circle_down,
              color: Colors.white,
            ))
      ],
    );
  }

  Widget preset(int index) {
    return Column(
      children: [
        Text(
          "Preset ${index + 1}  ",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        presetFront(index),
        presetRear(index),
      ],
    );
  }

  Widget currenState() {
    if (!uart.connected) {
      return Center(
        child: Text(
          "please connect to your device",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return Column(
      children: [
        preset(0),
        preset(1),
        preset(2),
        preset(3),
        Container(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () async {
                prefs.savePresets(widget.presets);
                Fluttertoast.showToast(
                  msg: "your prests saved succesfully",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 4,
                  textColor: Colors.white,
                  backgroundColor: AppTheme.success,
                );
                Navigator.of(context).pushNamed("/home");
              },
              child: Text("save")),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(20), child: currenState()),
    );
  }
}
