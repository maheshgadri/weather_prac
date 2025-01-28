import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_prac/app/services/local_database.dart';
import 'package:weather_prac/app/services/weather_services.dart';

import 'package:geocoding/geocoding.dart'; // Correct import for geocoding


class WeatherController extends GetxController {
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  var temperature = '°C'.obs;
  var locationName = ''.obs; // To store the location name
  var isCelsius = true.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs; // For handling errors

  final WeatherService _weatherService = WeatherService();
  final LocalDatabase _localDatabase = LocalDatabase();

  var temperatureInCelsius = 0.0.obs;

  Future<void> fetchCurrentLocationAndWeather() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch user's location
      Position position = await _determinePosition();
      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;

      print("Location: Lat ${currentLatitude.value}, Lon ${currentLongitude.value}");

      // Get location name from latitude and longitude using reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(currentLatitude.value, currentLongitude.value);
      if (placemarks.isNotEmpty) {
        locationName.value = '${placemarks[0].locality}, ${placemarks[0].country}';
      } else {
        locationName.value = 'Unknown Location';
      }

      // Fetch weather data
      final weatherData = await _weatherService.fetchWeatherByLocation(
        currentLatitude.value,
        currentLongitude.value,
      );

      temperatureInCelsius.value = (weatherData['temp'] as num).toDouble();
      temperature.value = '${temperatureInCelsius.value.toStringAsFixed(1)}°C';

      await _localDatabase.insertWeather({
        'city': locationName.value,
        'temperature': weatherData['temp'],
        'description': weatherData['description'],
        'icon': weatherData['icon']
      });

    } catch (e) {
      print("Error fetching weather data: $e");

      final cachedWeather = await _localDatabase.fetchWeather();
      if (cachedWeather.isNotEmpty) {
        temperature.value = '${cachedWeather.last['temperature']}°C';
      } else {
        errorMessage.value = 'No internet connection and no local data available.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Function to fetch weather by city name
  Future<void> fetchWeatherByCity(String city) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch weather data by city name
      final weatherData = await _weatherService.fetchWeatherByCity(city);

      // Update city, latitude, and longitude
      locationName.value = city;
      currentLatitude.value = (weatherData['latitude'] as num).toDouble();
      currentLongitude.value = (weatherData['longitude'] as num).toDouble();

      // Update temperature
      temperatureInCelsius.value = (weatherData['temp'] as num).toDouble();
      temperature.value = '${temperatureInCelsius.value.toStringAsFixed(1)}°C';
    } catch (e) {
      print("Error fetching weather for city: $e");
      errorMessage.value = 'Could not fetch weather for this city.';
    } finally {
      isLoading.value = false;
    }
  }


  void updateTemperatureUnit() {
    if (isCelsius.value) {
      // Display the saved Celsius value
      temperature.value = '${temperatureInCelsius.value.toStringAsFixed(1)}°C';
    } else {
      // Convert Celsius to Fahrenheit and display
      double fahrenheit = (temperatureInCelsius.value * 9 / 5) + 32;
      temperature.value = '${fahrenheit.toStringAsFixed(1)}°F';
    }
  }



  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }
}





