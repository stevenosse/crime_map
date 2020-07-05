import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

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
      title: "Error",
      desc: message,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    )..show();
  }
}
