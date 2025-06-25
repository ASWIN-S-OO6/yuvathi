import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState.initial()) {
    on<ChangeLanguage>((event, emit) {
      emit(
        state.copyWith(locale: Locale(event.languageCode, event.countryCode)),
      );
    });
  }
}
