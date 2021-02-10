import 'localizations_constraints.dart';

class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language({this.id, this.name, this.flag, this.languageCode});

  static List<Language> languageList() {
    return <Language>[
      Language(flag: '', id: 1, languageCode: ENGLISH, name: 'English'),
      Language(flag: '', id: 2, languageCode: HINDI, name: 'हिन्दी'),
      Language(flag: '', id: 3, languageCode: PUNJABI, name: 'ਪੰਜਾਬੀ'),
    ];
  }
}
