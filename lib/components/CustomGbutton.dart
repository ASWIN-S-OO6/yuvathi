import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomGButton {
  static GButton build({
    required String text,
    String? svgAssetPath,
    IconData? icon,
    double? iconSize,
    Color? iconColor,
    Color? iconActiveColor,
    TextStyle? textStyle,
    bool? active,
    Function()? onPressed,
  }) {
    return GButton(
      icon: icon ?? Icons.circle, // Fallback icon (will be hidden)
      text: text,
      iconSize: iconSize,
      iconColor: Colors.transparent, // Hide the fallback icon
      iconActiveColor: Colors.transparent,
      textStyle: textStyle,
      leading: svgAssetPath != null
          ? SvgPicture.asset(
        svgAssetPath,
        width: iconSize,
        height: iconSize,
        color: active ?? false ? iconActiveColor : iconColor,
      )
          : null,
      onPressed: onPressed,
    );
  }
}