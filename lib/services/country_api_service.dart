import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import 'api_exception.dart';

class CountryApiService {
  final String _baseUrl = 'restcountries.com';
  final Duration _timeout = const Duration(seconds: 10);
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Failed to fetch data. Server responded with status ${response.statusCode}',
      );
    }
  }

  Future<List<Country>> fetchAllCountries() async {
    final uri = Uri.https(
      _baseUrl,
      '/v3.1/all',
      {'fields': 'name,flags,region,population,cca3'},
    );

    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _checkResponse(response);

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Country.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<Country>> searchByName(String name) async {
    final uri = Uri.https(_baseUrl, '/v3.1/name/$name');

    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _checkResponse(response);

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Country.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Country> fetchByCode(String code) async {
    final uri = Uri.https(_baseUrl, '/v3.1/alpha/$code');

    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _checkResponse(response);

    final List<dynamic> data = jsonDecode(response.body);
    if (data.isEmpty) {
      throw const ApiException(statusCode: 404, message: 'Country not found');
    }
    return Country.fromJson(data.first as Map<String, dynamic>);
  }
}
