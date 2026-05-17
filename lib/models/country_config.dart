class CountryConfig {
  const CountryConfig({
    required this.code,
    required this.name,
    required this.flag,
    required this.docKind,
    required this.locale,
    required this.spellingVariant,
    required this.summaryWordLimit,
    required this.includePhoto,
    required this.preferredPageCount,
    required this.pageFormat,
    required this.tagline,
    required this.atsHints,
  });

  final String code; // ISO: GB, US, CA, AU, IN
  final String name;
  final String flag; // emoji
  final String docKind; // 'CV' | 'Resume'
  final String locale; // e.g. en_GB
  final String spellingVariant; // 'British' | 'American' | 'Canadian' | 'Australian' | 'Indian'
  final int summaryWordLimit;
  final bool includePhoto;
  final String preferredPageCount;
  final CountryPageFormat pageFormat;
  final String tagline;
  final List<String> atsHints;
}

enum CountryPageFormat { a4, letter }
