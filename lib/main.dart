import 'package:flutter/material.dart';
import 'package:place_interest_app/bloc/place_bloc.dart';
import 'package:place_interest_app/repository/geolocator_repository.dart';
import 'package:place_interest_app/screen/places_maps.dart';
import 'package:place_interest_app/services/injection_container.dart';
import 'package:provider/provider.dart';

Map<String, dynamic> currentPosition = {};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initGetIt();
  currentPosition = await getIt.get<GeolocatorRepository>().geolocator.getPosition();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlaceBloc()),
      ],
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interest Places',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PlacesMaps(),
    );
  }
}
