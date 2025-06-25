import 'package:flutter/material.dart';
import '../service/translated_text.dart';

/// A helper widget that makes it easy to translate any text widget in the app.
/// This widget takes a text builder function that receives the translated text
/// and returns a widget. This allows for more flexibility in how the translated
/// text is displayed.
class TranslatedTextBuilder extends StatelessWidget {
  final String text;
  final Widget Function(String translatedText) builder;

  const TranslatedTextBuilder({
    super.key,
    required this.text,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return TranslatedText(
      text,
      style: const TextStyle(fontSize: 0, color: Colors.transparent),
      builder: (context, translatedText) => builder(translatedText),
    );
  }
}

/// Extension method to make it easier to wrap any text in a widget with translation
extension TranslatedTextExtension on String {
  Widget translated({
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool softWrap = true,
    TextWidthBasis? textWidthBasis,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    Locale? locale,
    String? semanticsLabel,
  }) {
    return TranslatedText(
      this,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textWidthBasis: textWidthBasis,
      strutStyle: strutStyle,
      textDirection: textDirection,
      locale: locale,
      semanticsLabel: semanticsLabel,
    );
  }
}

/// Helper class for translating RichText spans
class TranslatedSpan {
  static TextSpan text(String text, {TextStyle? style}) {
    return TextSpan(text: text, style: style);
  }
}
