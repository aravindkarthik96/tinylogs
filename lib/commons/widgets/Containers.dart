import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import '../../data/logs_data/LogEntry.dart';
import '../../generated/assets.dart';
import '../resources/Shadows.dart';
import '../resources/TinyLogsColors.dart';
import 'ButtonWidgets.dart';
import 'Spacers.dart';
import 'TextWidgets.dart';

class Containers {
  static Widget getTappableLog(String content, void Function() onTap) {
    return Expanded(
      child: InkWell(
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
            ButtonWidgets.getMiniIconButton(Assets.imagesIconCross, onDismissed)
          ],
        ),
      ),
    );
  }

  static Widget getLogSeparator(String title, String prompt) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Container(
        width: double.infinity,
        height: 120,
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          color: TinyLogsColors.orangePageBackground,
          image: DecorationImage(
              image: AssetImage(Assets.imagesBackgroundLogsMonthSeparator),
              fit: BoxFit.fitHeight,
              alignment: Alignment.topRight),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 16, 0),
              child: TextWidgets.getSeparatorTitleText(title),
            ),
            Expanded(
              child: TextWidgets.getSeparatorDescriptionText(prompt),
            )
          ],
        ),
      ),
    );
  }

  static Row getInsightRow(
    String icon,
    String title,
    String subtitle,
    String description,
  ) {
    return Row(
      children: [
        Image.asset(
          icon,
          width: 36,
          height: 36,
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidgets.getInsightItemTitle(title),
            TextWidgets.getInsightItemDescription(subtitle, description)
          ],
        ),
      ],
    );
  }

  static Widget showLogMessageDialogue(
    BuildContext context,
    LogEntry logEntry,
    ScreenshotController controller,
    VoidCallback onSharePressed,
  ) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: TinyLogsColors.orangeRegular,
          content: Screenshot(
            controller: controller,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: width),
              child: Container(
                decoration: BoxDecoration(
                    color: TinyLogsColors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: TextWidgets.getMiniTitleText(
                        DateFormat("dd MMM yyyy").format(logEntry.creationDate),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      thickness: 1,
                      color: TinyLogsColors.buttonDisabled,
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      child: TextWidgets.getLogText(logEntry.content),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: TinyLogsColors.orangePageBackground,
                                borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            )),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: TextWidgets.getSharePromptText(
                                "via ",
                                "Tinylogs",
                                "- thankful everyday :)",
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          surfaceTintColor: TinyLogsColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: ButtonWidgets.getLargeSecondaryButton(
            'Share',
            onSharePressed,
          ),
        ),
      ],
    );
  }
}
