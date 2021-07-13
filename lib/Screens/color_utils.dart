import 'package:flutter/cupertino.dart';

class HexColor extends Color {

  // ignore: missing_return
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return int.parse("0x$hexColor");
    }
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}