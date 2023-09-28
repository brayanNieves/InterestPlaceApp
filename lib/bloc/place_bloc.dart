import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_interest_app/db_helper/db_helper.dart';
import 'package:place_interest_app/models/places_model.dart';
import 'package:place_interest_app/utils.dart';

class PlaceBloc with ChangeNotifier {
  final dbHelper = DatabaseHelper();
  bool _loadingPlaces = true;
  Set<Marker>? _markerList;
  List<PlaceModel> _places = [];

  Set<Marker>? get markers => _markerList;

  bool get loadingPlaces => _loadingPlaces;

  List<PlaceModel> get places => _places;

  set setMarkers(Set<Marker> markerList) {
    _markerList = markerList;
  }

  set setPlace(List<PlaceModel> places) {
    _places = places;
  }

  set setLoadingPlaces(bool loading) {
    _loadingPlaces = loading;
    notifyListeners();
  }

  Future<void> getMarkers() async {}

  Future<void> savePlace(
      String title, String desc, String latitude, String longitude) async {
    await dbHelper.init();
    Map<String, dynamic> row = {
      DatabaseHelper.title: title,
      DatabaseHelper.latitude: latitude,
      DatabaseHelper.longitude: longitude,
      DatabaseHelper.description: desc
    };
    await dbHelper.insert(row);
  }

  Future<void> getPlaces(Map<String, dynamic> currentPosition) async {
    setLoadingPlaces = true;
    await dbHelper.init();
    final allRows = await dbHelper.queryAllRows();
    if (allRows.isNotEmpty) {
      Set<Marker>? markers = {};
      List<PlaceModel> places = [];
      for (final row in allRows) {
        double latitude = double.parse(row[DatabaseHelper.latitude]);
        double longitude = double.parse(row[DatabaseHelper.longitude]);
        String distance = Utils.getDistanceText(currentPosition['latitude'],
            currentPosition['longitude'], latitude, longitude);
        markers.add(Marker(
          markerId: MarkerId(row[DatabaseHelper.title]),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: row[DatabaseHelper.title],
            snippet: 'Distance - $distance',
          ),
        ));
        places.add(PlaceModel(
            title: row[DatabaseHelper.title],
            latitude: latitude,
            longitude: longitude,
            description: row[DatabaseHelper.description] ?? ''));
      }
      setPlace = places;
      setMarkers = markers;
    } else {
      _places = [];
    }
    setLoadingPlaces = false;
  }
}
