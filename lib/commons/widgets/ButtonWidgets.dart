import 'package:flutter/material.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';

import '../resources/TinyLogsColors.dart';

class ButtonWidgets {
  static TextButton getSmallNakedButton(
      String title, void Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(TinyLogsColors.transparent),
        padding:
            MaterialStateProperty.all(const EdgeInsets.fromLTRB(8, 0, 8, 0)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: TinyLogsColors.orangeDark, width: 1),
        )),
      ),
      child: TextWidgets.getButtonText(title),
    );
  }

  static IconButton getMiniIconButton(String icon, void Function() onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        icon,
        width: 12,
        height: 12,
      ),
    );
  }

  static IconButton getMediumIconButton(String icon, void Function() onPressed,
      {Color? tintColor}) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        icon,
        width: 28,
        height: 28,
        color: tintColor,
      ),
    );
  }

  static IconButton getSmallIconButton(String icon, void Function() onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        icon,
        width: 24,
        height: 24,
      ),
    );
  }

  static Widget getFloatingActionButton(String icon, void Function() onPressed,
      {buttonColor = TinyLogsColors.orangeRegular}) {
    return SizedBox(
      width: 64.0,
      height: 64.0,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: buttonColor,
        shape: const CircleBorder(),
        child: Image.asset(
          icon,
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  static Widget getPrimaryButton(String buttonText, void Function() onPress) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        foregroundColor: TinyLogsColors.white,
        backgroundColor: TinyLogsColors.orangeRegular,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.408,
        ),
      ),
      child: Text(buttonText),
    );
  }

  static Widget getLargeSecondaryButton(
      String buttonText, void Function() onPress) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        foregroundColor: TinyLogsColors.white,
        backgroundColor: TinyLogsColors.orangePageBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.408,
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
            color: TinyLogsColors.orangeRegular,
            fontSize: 17,
            fontFamily: "SF Pro Display"),
      ),
    );
  }

  static Widget getLargeNakedButton(
      String buttonText, void Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(TinyLogsColors.transparent),
        padding:
            MaterialStateProperty.all(const EdgeInsets.fromLTRB(8, 0, 8, 0)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: TinyLogsColors.orangeDark, width: 1),
        )),
        minimumSize: MaterialStateProperty.all(
          const Size(double.infinity, 56),
        ),
      ),
      child: TextWidgets.getNakedButtonText(buttonText),
    );
  }

  static Widget getMiniFloatingActionButton(
      String icon, void Function() onPressed,
      {buttonColor = TinyLogsColors.orangeRegular}) {
    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: buttonColor,
        shape: const CircleBorder(),
        child: Image.asset(
          icon,
          width: 28,
          height: 28,
        ),
      ),
    );
  }
}
