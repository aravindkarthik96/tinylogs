import 'package:flutter/material.dart';

import 'TinyLogsColors.dart';

class TinyLogsStyles {
  static TextStyle insightItemTitleStyle = const TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: Color(0xFF292929),
  );

  static TextStyle pageTitleStyle = const TextStyle(
    fontFamily: "SF Pro Display",
    fontWeight: FontWeight.w700,
    fontSize: 34,
    color: TinyLogsColors.orangeRegular,
  );

  static TextStyle sectionTitleTextStyle = const TextStyle(
      fontFamily: "SF Pro Display",
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: TinyLogsColors.orangeDark);

  static TextStyle insightItemSubtitleStyle = const TextStyle(
      fontFamily: "SF Pro Display",
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: TinyLogsColors.orangeRegular);

  static TextStyle insightItemDescriptionStyle = const TextStyle(
    fontFamily: "SF Pro Text",
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 15.0,
    height: 1.3,
  );

  static TextStyle tinyTitleStyle = const TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: TinyLogsColors.orangeDark,
  );

  static TextStyle sentenceRegularStyle = const TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: TinyLogsColors.orangeDark,
  );

  static TextStyle smallButtonTextStyle = const TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF662619),
  );
}
