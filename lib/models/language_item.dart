import 'package:uuid/uuid.dart';

class LanguageItem {
  LanguageItem({
    String? id,
    this.language = '',
    this.proficiency = LanguageProficiency.professional,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String language;
  final LanguageProficiency proficiency;

  LanguageItem copyWith({String? language, LanguageProficiency? proficiency}) =>
      LanguageItem(
        id: id,
        language: language ?? this.language,
        proficiency: proficiency ?? this.proficiency,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'language': language,
        'proficiency': proficiency.name,
      };

  factory LanguageItem.fromJson(Map<String, dynamic> json) => LanguageItem(
        id: json['id'] as String?,
        language: (json['language'] as String?) ?? '',
        proficiency: LanguageProficiency.values.firstWhere(
          (LanguageProficiency e) => e.name == json['proficiency'],
          orElse: () => LanguageProficiency.professional,
        ),
      );
}

enum LanguageProficiency {
  basic,
  conversational,
  professional,
  fluent,
  native;

  String get label => switch (this) {
        LanguageProficiency.basic => 'Basic',
        LanguageProficiency.conversational => 'Conversational',
        LanguageProficiency.professional => 'Professional',
        LanguageProficiency.fluent => 'Fluent',
        LanguageProficiency.native => 'Native',
      };
}
