import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_prac/controllers/weater_controllers.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome package


  class HomeView extends StatelessWidget {
    final WeatherController controller = Get.put(WeatherController());
    final TextEditingController cityController = TextEditingController(); // Controller for the search bar

    @override
    Widget build(BuildContext context) {
      // Fetch location and weather on app startup
      controller.fetchCurrentLocationAndWeather();

      return Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Icon(
                        FontAwesomeIcons.sun, // Use FontAwesome sun icon
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      // Search Bar for City
                      TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                          hintText: 'Enter city name',
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        onSubmitted: (value) {
                          // Fetch weather when the user submits the city name
                          if (value.isNotEmpty) {
                            controller.fetchWeatherByCity(value);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Location: ${controller.locationName.value}', // Display location name
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Latitude: ${controller.currentLatitude.value}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'Longitude: ${controller.currentLongitude.value}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Toggle Button to switch between Celsius and Fahrenheit
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Celsius',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Switch(
                            value: controller.isCelsius.value,
                            onChanged: (value) {
                              controller.isCelsius.value = value;
                              // Update temperature unit when toggle changes
                              controller.updateTemperatureUnit();
                            },
                            activeColor: Colors.black,
                          ),
                          Text(
                            'Fahrenheit',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Container to display the temperature
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Current Temperature:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              controller.temperature.value,
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      );
    }
  }








