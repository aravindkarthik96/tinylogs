import 'package:flutter/material.dart';

import '../../generated/assets.dart';
import '../resources/Shadows.dart';
import '../resources/TinyLogsColors.dart';
import 'ButtonWidgets.dart';
import 'Spacers.dart';
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

  static Widget getPromptBox(
    title,
    subtitle,
    buttonText,
    void Function() onDismissed,
    void Function() onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: TinyLogsColors.orangeLight, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidgets.getSmallTitleDescription(
                      title,
                      subtitle,
                    ),
                    Spacers.twelvePx,
                    ButtonWidgets.getSmallNakedButton(buttonText, onPressed)
                  ],
                ),
              ),
            ),
            ButtonWidgets.getIconButton(Assets.imagesIconCross, onDismissed)
          ],
        ),
      ),
    );
  }
}
