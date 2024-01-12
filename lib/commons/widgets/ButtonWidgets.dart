import 'package:flutter/material.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';

import '../../generated/assets.dart';
import '../resources/TinyLogsColors.dart';

class ButtonWidgets {
  static TextButton getSmallNakedButton(
      String title, void Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        padding:
            MaterialStateProperty.all(const EdgeInsets.fromLTRB(8, 0, 8, 0)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: Color(0xFF662619), width: 1),
        )),
      ),
      child: TextWidgets.getButtonText(title),
    );
  }

  static IconButton getIconButton(String icon, void Function() onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        icon,
        width: 12,
        height: 12,
      ),
    );
  }

  static getFloatingActionButton(String icon, void Function() onPressed) {
    return SizedBox(
      width: 64.0,
      height: 64.0,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: TinyLogsColors.orangeRegular,
        shape: const CircleBorder(),
        child: Image.asset(
          icon,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
