import 'package:flutter/cupertino.dart';

class Shadows {
  static List<BoxShadow> getCardShadow() {
    return [
      const BoxShadow(
        color: Color(0x50000026),
        blurRadius: 2.0,
        spreadRadius: 0,
        offset: Offset(1, 1),
      )
    ];
  }
}
