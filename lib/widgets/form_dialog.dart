import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:crime_map/services/maps_service.dart';
import 'package:crime_map/models/place_response.dart';

class AddCrimeDialog extends StatefulWidget {
  final String title;

  AddCrimeDialog({this.title});

  @override
  _AddCrimeDialogState createState() => _AddCrimeDialogState();
}

class _AddCrimeDialogState extends State<AddCrimeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? "New form"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              decoration: InputDecoration(
                helperText: "Tap the button to use your current \n location...",
                hintText: "Enter a city name...",
                suffixIcon: IconButton(
                  icon: Icon(
                    Octicons.location,
                    color: Theme.of(context).primaryColor,
                  ),
                  tooltip: "Use your current location",
                  onPressed: () {
                    print("Save crime");
                  },
                ),
              ),
            ),
            suggestionsCallback: (pattern) async {
              PlaceResponse response = await mapsService.getPlaces(pattern);
              return response.features;
            },
            noItemsFoundBuilder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "No match found",
                  style: TextStyle(fontSize: 12.0, color: Colors.black45),
                ),
              );
            },
            errorBuilder: (context, error) {
              print(error);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "An error occured.",
                  style: TextStyle(fontSize: 12.0, color: Colors.redAccent),
                ),
              );
            },
            itemBuilder: (context, Features suggestion) {
              print(suggestion);
              return ListTile(
                leading: Icon(Octicons.location),
                title: Text(suggestion.text),
                subtitle: Text(
                  suggestion.context
                      .firstWhere((element) => element.id.contains("country"))
                      .text,
                ),
              );
            },
            onSuggestionSelected: (suggestion) {},
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          label: Text("Cancel"),
          textColor: Colors.black45,
          icon: Icon(Octicons.x),
        ),
        FlatButton.icon(
          onPressed: () {},
          label: Text("Add"),
          icon: Icon(Octicons.plus),
          textColor: Theme.of(context).accentColor,
        )
      ],
    );
  }
}
