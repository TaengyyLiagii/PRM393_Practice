import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exchange_rate.dart';

class ApiService {
  Future<ExchangeRate> fetchRates() async {
    final response = await http.get(
      Uri.parse(
        'https://open.er-api.com/v6/latest/USD',
      ),
    );

    if (response.statusCode == 200) {
      return ExchangeRate.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Failed to load rates');
    }
  }
}