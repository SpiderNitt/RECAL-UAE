import 'package:flutter/material.dart';
class UIUtills {
  factory UIUtills() {
    return _singleton;
  }

  static final UIUtills _singleton = UIUtills._internal();

  UIUtills._internal() {
    print("Instance created UIUtills");
  }

//region Screen Size and Proportional according to device
  double _screenHeight;
  double _screenWidth;

  double get screenHeight => _screenHeight;

  double get screenWidth => _screenWidth;
  final double _refrenceScreenHeight = 640;
  final double _refrenceScreenWidth = 360;

  void updateScreenDimesion({double width, double height}) {
    _screenWidth = (width != null) ? width : _screenWidth;
    _screenHeight = (height != null) ? height : _screenHeight;
  }

  double getProportionalHeight({double height}) {
    if (_screenHeight == null) return height;
    return _screenHeight * height / _refrenceScreenHeight;
  }

  double getProportionalWidth({double width}) {
    if (_screenWidth == null) return width;
    var w = _screenWidth * width / _refrenceScreenWidth;
    return w.ceilToDouble();
  }
}