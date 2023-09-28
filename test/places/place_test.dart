import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:place_interest_app/bloc/place_bloc.dart';

import 'package:place_interest_app/main.dart';
import 'package:place_interest_app/models/places_model.dart';
import 'package:place_interest_app/screen/interest_places.dart';
import 'package:place_interest_app/screen/places_maps.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('PlacesMaps should render GoogleMap and InterestPlaces',
      (WidgetTester tester) async {
    currentPosition = {'latitude': 18.4597537, 'longitude': -69.9536171};
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => PlaceBloc()),
            ],
            child:
                const PlacesMaps()),
      ),
    );
    final BuildContext context = tester.element(find.byType(PlacesMaps));
    context.read<PlaceBloc>().setPlace = [
      PlaceModel(
          title: 'Title',
          latitude: 18.4597537,
          longitude: -69.9536171,
          description: 'My best description')
    ];
    // Verify that GoogleMap is rendered
    expect(find.byKey(const Key('place-map')), findsOneWidget);

    // Verify that InterestPlaces is not rendered initially
    expect(find.byType(InterestPlaces), findsNothing);

    // Simulate the loading of places by updating the bloc
    context.read<PlaceBloc>().setLoadingPlaces = true;
    await tester.pump();

    // Verify that InterestPlaces is still not rendered when loadingPlaces is true
    expect(find.byType(InterestPlaces), findsNothing);

    // Simulate the loading of places being done by updating the bloc
    context.read<PlaceBloc>().setLoadingPlaces = false;
    await tester.pumpAndSettle();

    final place = find.byType(InterestPlaces);
    // Verify that InterestPlaces is now rendered when loadingPlaces is false
    expect(place, findsOneWidget);
  });

  testWidgets('My location btn should be pressed', (WidgetTester tester) async {
    currentPosition = {'latitude': 18.4597537, 'longitude': -69.9536171};
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => PlaceBloc()),
            ],
            child:
                const PlacesMaps()), // Replace with the actual name of your widget
      ),
    );
    // Verify that GoogleMap is rendered
    expect(find.byKey(const Key('place-map')), findsOneWidget);

    final myLocationBtn = find.byKey(const Key('my-location-btn'));
    expect(myLocationBtn, findsOneWidget);
    await tester.tap(myLocationBtn);
    await tester.pump();
  });
}
