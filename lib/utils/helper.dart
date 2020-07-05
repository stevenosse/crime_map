import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Helper {
  static notify(
    BuildContext context, {
    @required String message,
    DialogType type = DialogType.INFO,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.BOTTOMSLIDE,
      title: type == DialogType.ERROR ? "Error" : "Info",
      desc: message,
      headerAnimationLoop: false,
      btnOkOnPress: () {},
      btnOkIcon: type == DialogType.ERROR ? Icons.cancel : Icons.check,
      btnOkColor: type == DialogType.ERROR ? Colors.red : Colors.green,
    )..show();
  }

  static Future<LocationData> getCurrentPosition() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return await location.getLocation();
  }
}
