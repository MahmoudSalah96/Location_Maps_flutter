import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helper/db_helper.dart';
import '../helper/location_helper.dart';

class Greatplaces with ChangeNotifier {
  List<Place> _list = [];

  List<Place> get list {
    return [..._list];
  }

  Place getPlaceById(String id) {
    return _list.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String pickedTitle,
    File pickedImage,
    PlaceLocation pickedLocaion,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocaion.latitude, pickedLocaion.longitude);
    print(address);
    final updatedLocation = PlaceLocation(
      latitude: pickedLocaion.latitude,
      longitude: pickedLocaion.longitude,
      address: address,
    );
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        location: updatedLocation,
        image: pickedImage);

    _list.add(newPlace);

    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _list = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_lng'],
                address: item['address'],
              ),
            ))
        .toList();
    notifyListeners();
  }
}
