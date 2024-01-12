import 'package:flutter/material.dart';

import '../resources/Shadows.dart';
import 'TextWidgets.dart';

class Containers {
  static Widget getTappableLog(String content, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: Shadows.getCardShadow(),
        ),
        child: TextWidgets.getLogText(content),
      ),
    );
  }
}
