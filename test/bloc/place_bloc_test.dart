import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:place_interest_app/bloc/place_bloc.dart';
import 'package:place_interest_app/main.dart';
import 'package:place_interest_app/screen/places_maps.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Loading place should be false', (WidgetTester tester) async {
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
    context.read<PlaceBloc>().setLoadingPlaces = false;
    expect(false, context.read<PlaceBloc>().loadingPlaces);
  });
  testWidgets('Loading place should be true', (WidgetTester tester) async {

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
    final BuildContext context = tester.element(find.byType(PlacesMaps));
    expect(true, context.read<PlaceBloc>().loadingPlaces);
  });
}
