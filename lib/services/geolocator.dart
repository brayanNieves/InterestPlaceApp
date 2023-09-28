import 'package:geolocator/geolocator.dart' as geolocator;

mixin Geolocator {
  Future checkPermission();

  Future<geolocator.LocationPermission> requestPermission();

  Future<Map<String, dynamic>> getPosition();

  bool checkPosition(Map position);

  bool wasDeniedForever(geolocator.LocationPermission permission);

  Future<bool> openLocationSettings();

  Future<bool> locationGranted();
}

class GeolocatorUtil implements Geolocator {
  @override
  Future checkPermission() async {
    geolocator.LocationPermission permission;
    permission = await geolocator.Geolocator.checkPermission();
    return _handlePermission(permission);
  }

  @override
  Future<Map<String, dynamic>> getPosition() async {
    bool permission = await checkPermission();
    try {
      if (!permission) {
        return {'latitude': 0.0, 'longitude': 0.0, 'granted': false};
      } else {
        geolocator.Position position =
            await geolocator.Geolocator.getCurrentPosition(
                desiredAccuracy: geolocator.LocationAccuracy.best);
        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'granted': true
        };
      }
    } catch (e) {
      return {'latitude': null, 'longitude': null, 'granted': false};
    }
  }

  bool _handlePermission(geolocator.LocationPermission permission) {
    return (permission == geolocator.LocationPermission.always ||
        permission == geolocator.LocationPermission.whileInUse);
  }

  @override
  bool checkPosition(Map<dynamic, dynamic> position) {
    if (position['latitude'] != null && position['longitude'] != null) {
      if (position['latitude'].toString().length > 3 &&
          position['longitude'].toString().length > 3) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<geolocator.LocationPermission> requestPermission() async {
    geolocator.LocationPermission permission =
        await geolocator.Geolocator.requestPermission();
    return permission;
  }

  @override
  bool wasDeniedForever(geolocator.LocationPermission permission) {
    return permission == geolocator.LocationPermission.deniedForever;
  }

  @override
  Future<bool> openLocationSettings() {
    return geolocator.Geolocator.openLocationSettings();
  }

  @override
  Future<bool> locationGranted() async {
    geolocator.LocationPermission status = await requestPermission();
    switch (status) {
      case geolocator.LocationPermission.denied:
      case geolocator.LocationPermission.deniedForever:
        return false;
      case geolocator.LocationPermission.whileInUse:
      case geolocator.LocationPermission.always:
        return true;
      default:
        return true;
    }
  }
}
