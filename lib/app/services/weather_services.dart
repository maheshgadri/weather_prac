import 'dart:convert';

import 'package:weather_prac/app/models/weather_model.dart';
import 'package:http/http.dart' as http;


class WeatherService {
  final String _apiKey = '7dlr6j9LBWsHmlsLMCuoMA==shmcObBz3ZiRZfK3';// Replace with your actual API key

  Future<Map<String, dynamic>> fetchWeatherByLocation(double lat, double lon) async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/weather?lat=$lat&lon=$lon');
    final response = await http.get(url, headers: {'X-Api-Key': _apiKey});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("API Error: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Failed to load weather data');
    }
  }

  // Fetch weather by city name
  Future<Map<String, dynamic>> fetchWeatherByCity(String city) async {
    try {
      final encodedCity = Uri.encodeComponent(city); // Ensure city name is properly encoded
      final url = Uri.parse('https://api.api-ninjas.com/v1/weather?city=$encodedCity');

      final response = await http.get(url, headers: {'X-Api-Key': _apiKey});

      if (response.statusCode == 200) {
        final weatherData = json.decode(response.body);

        if (weatherData.isEmpty) {
          throw Exception('No weather data found for $city');
        }
        return weatherData;
      } else {
        // Handle 400 or other HTTP errors
        throw Exception('Failed to fetch weather: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch weather for $city. Please try again later.');
    }
  }


}


