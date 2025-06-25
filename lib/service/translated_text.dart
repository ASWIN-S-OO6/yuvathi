import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/locale_provider.dart';
import 'translation_service.dart';

class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final TextWidthBasis? textWidthBasis;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final Locale? locale;
  final String? semanticsLabel;
  final Widget Function(BuildContext context, String translatedText)? builder;

  const TranslatedText(
      this.text, {
        super.key,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.softWrap = true,
        this.textWidthBasis,
        this.strutStyle,
        this.textDirection,
        this.locale,
        this.semanticsLabel,
        this.builder,
      });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String? _translatedText;
  bool _isTranslating = false;
  String _currentLanguageCode = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeProvider = Provider.of<LocaleProvider>(context);
    final targetLanguageCode =
        TranslationService.supportedLanguages[localeProvider
            .selectedLanguageName] ??
            'en';

    if (_currentLanguageCode != targetLanguageCode) {
      _currentLanguageCode = targetLanguageCode;
      _translateText();
    }
  }

  @override
  void didUpdateWidget(covariant TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _translatedText = null; // Clear previous translation
      _isTranslating = false; // Reset translation state
      _translateText(); // Re-translate with the new text
    }
  }

  Future<void> _translateText() async {
    if (_isTranslating || _currentLanguageCode.isEmpty) return;

    setState(() {
      _isTranslating = true;
    });

    try {
      final translatedText = await TranslationService.translate(
        widget.text,
        _currentLanguageCode,
      );
      if (mounted) {
        setState(() {
          _translatedText = translatedText;
          _isTranslating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _translatedText = widget.text;
          _isTranslating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = _translatedText ?? widget.text;

    if (widget.builder != null) {
      return widget.builder!(context, text);
    }

    return Text(
      text,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      softWrap: widget.softWrap,
      textWidthBasis: widget.textWidthBasis,
      strutStyle: widget.strutStyle,
      textDirection: widget.textDirection,
      locale: widget.locale,
      semanticsLabel: widget.semanticsLabel,
    );
  }
}