import 'dart:math';
import 'package:flutter/material.dart';

class Sound with ChangeNotifier {
  double _volume = 1.0; // 0 to 1
  double _frequency = 1.0; // 0.1 to 10
  double _balance = 0; // -1 to 1 for left to right
  String name;

  Sound(this.name);

  void reset() {
    _volume = 1.0;
    _frequency = 1.0;
    _balance = 0;
    notifyListeners();
  }

  Sound.fromJson(Map<String, dynamic> json)
      : _volume = json['volume'],
        _frequency = json['frequency'],
        _balance = json['balance'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        "volume": _volume,
        "frequency": _frequency,
        "balance": _balance,
        "name": name
      };

  double get volume => _volume;
  double get frequency => _frequency;
  double get balance => _balance;

  set volume(double value) {
    _volume = min(max(value, volumeRange[0]), volumeRange[1]);
    notifyListeners();
  }

  set frequency(double value) {
    _frequency = min(max(value, frequencyRange[0]), frequencyRange[1]);
    notifyListeners();
  }

  set balance(double value) {
    _balance = min(max(value, balanceRange[0]), balanceRange[1]);
    notifyListeners();
  }

  List<double> get volumeRange => [0, 1];
  List<double> get frequencyRange => [0.1, 10];
  List<double> get balanceRange => [-1, 1];
}
