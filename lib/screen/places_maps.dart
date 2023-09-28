import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_interest_app/bloc/place_bloc.dart';
import 'package:place_interest_app/constants/constants.dart';
import 'package:place_interest_app/db_helper/db_helper.dart';
import 'package:place_interest_app/main.dart';
import 'package:place_interest_app/repository/geolocator_repository.dart';
import 'package:place_interest_app/screen/interest_places.dart';
import 'package:place_interest_app/screen/create_interest_place_dialog.dart';
import 'package:place_interest_app/services/injection_container.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart' as geo;

class PlacesMaps extends StatefulWidget {
  const PlacesMaps({Key? key}) : super(key: key);

  @override
  State<PlacesMaps> createState() => _PlacesMapsState();
}

class _PlacesMapsState extends State<PlacesMaps> {
  final dbHelper = DatabaseHelper();
  final _ctrlTitle = TextEditingController();
  final _ctrlDesc = TextEditingController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(currentPosition['latitude'], currentPosition['longitude']),
    zoom: Constants.MAP_ZOOM,
  );

  static final CameraPosition _position = CameraPosition(
      //tilt: Constants.MAP_TILT,
      target: LatLng(currentPosition['latitude'], currentPosition['longitude']),
      zoom: Constants.CURRENT_POSITION_ZOOM);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<PlaceBloc>().getPlaces(currentPosition);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PlaceBloc>(
        builder: (BuildContext context, PlaceBloc placeBloc, Widget? child) {
          return Stack(
            children: [
              GoogleMap(
                key: const Key('place-map'),
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                markers: placeBloc.loadingPlaces ? {} : placeBloc.markers ?? {},
                myLocationButtonEnabled: false,
                onTap: (lang) {
                  _ctrlTitle.clear();
                  _ctrlDesc.clear();
                  NewPlaceDialog.show(context,
                          controller: _ctrlTitle,
                          descriptionController: _ctrlDesc)
                      .then((value) {
                    if (value != null) {
                      _savePlace(_ctrlTitle.text, _ctrlDesc.text,
                          lang.latitude.toString(), lang.longitude.toString());
                    }
                  });
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              if (!placeBloc.loadingPlaces)
                InterestPlaces(
                  key: const Key('interest-places'),
                  places: placeBloc.places,
                ),
            ],
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          key: const Key('my-location-btn'),
          onPressed: _goToMyPosition,
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }

  void _savePlace(
      String title, String desc, String latitude, String longitude) async {
    await context
        .read<PlaceBloc>()
        .savePlace(title, desc, latitude, longitude)
        .then((value) async {
      await context.read<PlaceBloc>().getPlaces(currentPosition);
    });
  }

  Future<void> _goToMyPosition() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_position));
  }
}
