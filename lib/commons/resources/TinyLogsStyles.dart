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
    color: TinyLogsColors.orangeDark,
  );

  static TextStyle purpleTitleStyle = const TextStyle(
    fontFamily: "SF Pro Text",
    fontSize: 17,
    color: TinyLogsColors.purpleDark,
    height: 24 / 17,
  );

  static TextStyle weight400 = const TextStyle(
    fontWeight: FontWeight.w400,
  );

  static TextStyle weight700 = const TextStyle(
    fontWeight: FontWeight.w700,
  );

  static TextStyle orangeDescriptionText = const TextStyle(
    fontFamily: "SF Pro Text",
    color: TinyLogsColors.orangeDark,
    fontWeight: FontWeight.w400,
    fontSize: 17.0,
    height: 1.4,
  );

  static TextStyle nakedButtonTextStyle = const TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: TinyLogsColors.orangeDark,
  );

  static TextStyle dialogueTitleTextStyle = const TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 28,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
    color: TinyLogsColors.orangeRegular,
  );

  static TextStyle separatorTitleTextStyle = const TextStyle(
      fontFamily: "SF Pro Display",
      fontSize: 26,
      fontWeight: FontWeight.w400,
      height: 1.2,
      color: TinyLogsColors.orangeDark);

  static var separatorDescriptionTextStyle = const TextStyle(
    fontFamily: "SF Pro Text",
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.3,
  );
}
