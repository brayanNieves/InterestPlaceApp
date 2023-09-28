import 'package:geolocator/geolocator.dart';

class Utils {
  static double calculateDistance(lat1, lon1, lat2, lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  static String getDistanceText(lat1, lon1, lat2, lon2) {
    double distanceInMeters = calculateDistance(lat1, lon1, lat2, lon2);
    String distance = '';
    if (distanceInMeters >= 1000) {
      distanceInMeters = ((distanceInMeters / 1000) * 2);
      distance = '${distanceInMeters.floorToDouble()} km';
    } else {
      distance = '${distanceInMeters.floorToDouble()} mts';
    }
    return distance;
  }
}
