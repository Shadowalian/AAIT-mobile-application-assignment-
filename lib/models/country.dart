class Country {
  final String name;
  final String flagEmoji;
  final String region;
  final String? capital;
  final int population;
  final Map<String, String>? currencies;
  final List<String>? languages;
  final double area;
  final List<String>? timezones;
  final String alpha3Code;

  const Country({
    required this.name,
    required this.flagEmoji,
    required this.region,
    this.capital,
    required this.population,
    this.currencies,
    this.languages,
    required this.area,
    this.timezones,
    required this.alpha3Code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    // Parse currencies
    Map<String, String>? parsedCurrencies;
    if (json['currencies'] != null) {
      final currenciesMap = json['currencies'] as Map<String, dynamic>;
      parsedCurrencies = currenciesMap.map((key, value) {
        final currencyData = value as Map<String, dynamic>;
        return MapEntry(key, currencyData['name'] as String? ?? 'Unknown');
      });
    }

    // Parse languages
    List<String>? parsedLanguages;
    if (json['languages'] != null) {
      final langsMap = json['languages'] as Map<String, dynamic>;
      parsedLanguages = langsMap.values.map((v) => v as String).toList();
    }

    // Parse timezones
    List<String>? parsedTimezones;
    if (json['timezones'] != null) {
      final tzList = json['timezones'] as List<dynamic>;
      parsedTimezones = tzList.map((tz) => tz as String).toList();
    }

    // Parse capital (some countries don't have a capital)
    String? parsedCapital;
    if (json['capital'] != null) {
      final capList = json['capital'] as List<dynamic>;
      if (capList.isNotEmpty) {
        parsedCapital = capList.first as String;
      }
    }

    return Country(
      name: (json['name'] as Map<String, dynamic>)['common'] as String,
      flagEmoji: json['flag'] as String? ?? '🏳️',
      region: json['region'] as String? ?? 'Unknown',
      capital: parsedCapital,
      population: json['population'] as int? ?? 0,
      currencies: parsedCurrencies,
      languages: parsedLanguages,
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      timezones: parsedTimezones,
      alpha3Code: json['cca3'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'flag': flagEmoji,
      'region': region,
      'capital': capital != null ? [capital] : null,
      'population': population,
      'currencies': currencies?.map((key, value) => MapEntry(key, {'name': value})),
      'languages': languages != null ? {for (var lang in languages!) lang: lang} : null,
      'area': area,
      'timezones': timezones,
      'cca3': alpha3Code,
    };
  }

  Country copyWith({
    String? name,
    String? flagEmoji,
    String? region,
    String? capital,
    int? population,
    Map<String, String>? currencies,
    List<String>? languages,
    double? area,
    List<String>? timezones,
    String? alpha3Code,
  }) {
    return Country(
      name: name ?? this.name,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      region: region ?? this.region,
      capital: capital ?? this.capital,
      population: population ?? this.population,
      currencies: currencies ?? this.currencies,
      languages: languages ?? this.languages,
      area: area ?? this.area,
      timezones: timezones ?? this.timezones,
      alpha3Code: alpha3Code ?? this.alpha3Code,
    );
  }
}
