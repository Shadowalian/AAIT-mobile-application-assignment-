import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_api_service.dart';
import '../services/api_exception.dart';

class DetailScreen extends StatefulWidget {
  final String alpha3Code;

  const DetailScreen({super.key, required this.alpha3Code});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CountryApiService _apiService = CountryApiService();
  late Future<Country> _countryFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _countryFuture = _apiService.fetchByCode(widget.alpha3Code);
    });
  }

  String _getErrorMessage(Object error) {
    if (error is SocketException) {
      return 'No internet connection';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    } else if (error is ApiException) {
      return 'Error ${error.statusCode}: ${error.message}';
    } else if (error is FormatException) {
      return 'Unexpected data format received';
    } else {
      return 'An unexpected error occurred: ${error.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Details'),
      ),
      body: FutureBuilder<Country>(
        future: _countryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      _getErrorMessage(snapshot.error!),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Country data not found.'));
          }

          final country = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    country.flagEmoji,
                    style: const TextStyle(fontSize: 100),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    country.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoRow('Region', country.region),
                _buildInfoRow('Capital', country.capital ?? 'N/A'),
                _buildInfoRow('Population', country.population.toString()),
                _buildInfoRow('Area', '${country.area} km²'),
                const Divider(height: 32),
                _buildListInfoRow('Currencies', country.currencies?.values.toList() ?? []),
                _buildListInfoRow('Languages', country.languages ?? []),
                _buildListInfoRow('Timezones', country.timezones ?? []),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListInfoRow(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              items.isEmpty ? 'N/A' : items.join(', '),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
