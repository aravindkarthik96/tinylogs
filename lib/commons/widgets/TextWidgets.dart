import 'package:flutter/cupertino.dart';
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
}
