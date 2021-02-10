import 'package:flutter/material.dart';

import '../Constant/global.dart';
import 'localization.dart';

String translate(BuildContext context, String key) {
  return AppLocalizations.of(context).translate(key) ?? "N/A";
}

//Language Codes
const String ENGLISH = 'en';
const String HINDI = 'hi';
const String PUNJABI = 'pa';

const String LANGUAGE_CODE = 'languageCode';

Future<Locale> setLocale(String languageCode) async {
  sharedPreferences.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  String languageCode = sharedPreferences.get(LANGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale locale;
  switch (languageCode) {
    case ENGLISH:
      locale = Locale(languageCode, 'US');
      break;
    case HINDI:
      locale = Locale(languageCode, 'IN');
      break;
    case PUNJABI:
      locale = Locale(languageCode, 'IN');
      break;
    default:
      locale = Locale(languageCode, 'US');
      break;
  }
  return locale;
}
