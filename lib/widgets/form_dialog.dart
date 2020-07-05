import 'package:crime_map/services/crimes_service.dart';
import 'package:crime_map/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:crime_map/services/maps_service.dart';
import 'package:crime_map/models/place_response.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class AddCrimeDialog extends StatefulWidget {
  final String title;

  AddCrimeDialog({this.title});

  @override
  _AddCrimeDialogState createState() => _AddCrimeDialogState();
}

class _AddCrimeDialogState extends State<AddCrimeDialog> {
  final TextEditingController _placeController = TextEditingController();
  LatLng position;
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
              controller: _placeController,
              decoration: InputDecoration(
                helperText: "Tap the button to use your current \n location...",
                hintText: "Enter a city name...",
                suffixIcon: IconButton(
                  icon: Icon(
                    Octicons.location,
                    color: Theme.of(context).accentColor,
                  ),
                  tooltip: "Use your current location",
                  onPressed: () {
                    _useCurrentPosition();
                  },
                ),
              ),
            ),
            suggestionsCallback: (pattern) async {
              if (pattern.isEmpty) return <Features>[];
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
              return ListTile(
                leading: Icon(Octicons.location),
                title: Text(suggestion.text),
                subtitle: Text(
                  suggestion?.context
                          ?.firstWhere((s) => s.id.contains("country"))
                          ?.text ??
                      "-",
                ),
              );
            },
            onSuggestionSelected: (Features suggestion) {
              position = LatLng(
                suggestion.geometry.coordinates.first,
                suggestion.geometry.coordinates.last,
              );
              _placeController.text =
                  "${suggestion.text}, ${suggestion?.context?.firstWhere((s) => s.id.contains("country"))?.text ?? "-"}";
              setState(() {});
            },
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
          onPressed: () {
            _addCrime();
          },
          label: Text("Add"),
          icon: Icon(Octicons.plus),
          textColor: Theme.of(context).accentColor,
        )
      ],
    );
  }

  _useCurrentPosition() async {
    var locationData = await Helper.getCurrentPosition();
    position = LatLng(
      locationData.latitude,
      locationData.longitude,
    );
    var placeInfo = await mapsService.getPlaceFromCoords(position);
    _placeController.text = placeInfo?.features?.first?.text ?? "";
  }

  _addCrime() {
    try {
      crimesService.addCrime(position);
      Navigator.of(context).pop(true);
    } catch (e) {
      Navigator.of(context).pop(false);
    }
  }
}
