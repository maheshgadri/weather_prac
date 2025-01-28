class Weather {
  final String city;
  final double temperature;
  final String description;
  final String icon;

  Weather({required this.city, required this.temperature, required this.description, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['city'] ?? '',
      temperature: json['temp'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'temperature': temperature,
      'description': description,
      'icon': icon,
    };
  }
}
