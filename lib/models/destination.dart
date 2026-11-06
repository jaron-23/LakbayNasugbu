import 'package:latlong2/latlong.dart';

class Destination {
  final String name;
  final String location;
  final String category;
  final String description;
  final String image;
  final String rating;
  final LatLng coordinates;

  const Destination({
    required this.name,
    required this.location,
    required this.category,
    required this.description,
    required this.image,
    required this.coordinates,
    this.rating = '4.8',
  });
}