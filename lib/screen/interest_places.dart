import 'package:flutter/material.dart';
import 'package:place_interest_app/main.dart';
import 'package:place_interest_app/models/places_model.dart';
import 'package:place_interest_app/utils.dart';

class InterestPlaces extends StatelessWidget {
  final List<PlaceModel> places;

  const InterestPlaces({Key? key, required this.places}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .2,
      minChildSize: .1,
      maxChildSize: .6,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12))),
          child: Column(
            children: [
              buildBottomSheetLine(),
              const Text(
                'Interests Places',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: places.length,
                  controller: scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        places[index].title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(places[index].description),
                      trailing: Text(Utils.getDistanceText(
                          currentPosition['latitude'],
                          currentPosition['longitude'],
                          places[index].latitude,
                          places[index].longitude)),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      endIndent: 12.0,
                      indent: 12.0,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildBottomSheetLine() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Center(
          child: Container(
            width: 40.0,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey[300],
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}
