import 'dart:convert';

class Coordinates {
  final double lat;
  final double long;
  const Coordinates({
    required this.lat,
    required this.long,
  });

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      lat: map['lat'],
      long: map['long'],
    );
  }

  factory Coordinates.fromJson(String source) =>
      Coordinates.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'long': long,
    };
  }

  String toJson() => json.encode(toMap());
}
