import 'package:place_interest_app/services/geolocator.dart';

class GeolocatorRepository {
  Geolocator geolocator = GeolocatorUtil();

  Future<Map<String, dynamic>> position() async {
    return await geolocator.getPosition();
  }
}
