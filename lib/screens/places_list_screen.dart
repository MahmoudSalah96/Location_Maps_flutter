import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/add_place_screen.dart';
import '../providers/great_places.dart';
import './place_detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Greatplaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? CircularProgressIndicator()
            : Consumer<Greatplaces>(
                child: Center(
                  child: Text('You have no Places, Please Enter some'),
                ),
                builder: (ctx, greatPlace, ch) => greatPlace.list.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: greatPlace.list.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlace.list[i].image),
                          ),
                          title: Text(greatPlace.list[i].title),
                          subtitle: Text(greatPlace.list[i].location.address),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlaceDetailScreen.routeName,
                              arguments: greatPlace.list[i].id,
                            );
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
