import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'), // English
    const Locale('pt'), // Portuguese
    const Locale('es'), // Spanish
    const Locale('de'), // German
  ];
  
  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'pt':
        return 'Português';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      default:
        return 'English';
    }
  }
}
