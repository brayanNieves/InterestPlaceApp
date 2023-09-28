import 'package:get_it/get_it.dart';
import 'package:place_interest_app/bloc/place_bloc.dart';
import 'package:place_interest_app/db_helper/db_helper.dart';
import 'package:place_interest_app/repository/geolocator_repository.dart';

final getIt = GetIt.instance;

Future initGetIt() async {
  getIt
    ..registerFactory(() => GeolocatorRepository())
    ..registerFactory(() => PlaceBloc())
    ..registerFactory(() => DatabaseHelper());
}
