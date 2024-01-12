import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/commons/resources/TinyLogsStyles.dart';

class TextWidgets {
  static Text getPageTitleText(String text) {
    return Text(
      text,
      style: TinyLogsStyles.pageTitleStyle,
    );
  }

  static Text getSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: TinyLogsStyles.sectionTitleTextStyle,
    );
  }

  static Text getInsightItemTitle(String title) {
    return Text(
      title,
      style: TinyLogsStyles.insightItemTitleStyle,
    );
  }

  static RichText getInsightItemDescription(String subtitle,
      String description) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: subtitle,
            style: TinyLogsStyles.insightItemSubtitleStyle,
          ),
          TextSpan(
            text: description,
            style: TinyLogsStyles.insightItemDescriptionStyle,
          ),
        ],
      ),
    );
  }

  static getMiniTitleText(String title) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: TinyLogsStyles.tinyTitleStyle,
    );
  }

  static Text getSentenceRegularText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TinyLogsStyles.sentenceRegularStyle,
    );
  }

  static RichText getSmallTitleDescription(title, description) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontFamily: "SF Pro Display",
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF662619),
            ),
          ),
          TextSpan(
            text: description,
            style: const TextStyle(
              fontFamily: "SF Pro Display",
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF662619),
            ),
          ),
        ],
      ),
    );
  }

  static Text getButtonText(String title) {
    return Text(
      title,
      style: TinyLogsStyles.smallButtonTextStyle,
    );
  }

  static Text getLogText(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16.0,
      ),
    );
  }

  static RichText getDateText({dayOfWeek, dayOfMonth, visibility = true}) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text:
            dayOfWeek,
            style: TextStyle(
              fontFamily: "SF Pro Text",
              color: visibility
                  ? const Color(0xFF6E6E6E)
                  : Colors.transparent,
              fontWeight: FontWeight.w500,
              fontSize: 10.0,
              height: 1.2,
            ),
          ),
          TextSpan(
            text: dayOfMonth,
            style: TextStyle(
              fontFamily: "SF Pro Text",
              color: visibility ? Colors.black : Colors.transparent,
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
