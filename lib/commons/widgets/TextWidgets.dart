import 'package:flutter/cupertino.dart';
import 'package:tinylogs/commons/resources/TinyLogsStyles.dart';

class TextWidgetsUtil {
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

  static RichText getInsightItemDescription(
      String subtitle, String description) {
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
}
