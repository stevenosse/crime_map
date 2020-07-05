import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crime_map/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:crime_map/services/users_service.dart';
import 'package:crime_map/utils/helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: size.width,
          child: Column(
            children: <Widget>[
              Spacer(),
              Text(
                "CrimeMap",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
              Spacer(),
              RaisedButton.icon(
                color: Colors.white,
                onPressed: login,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                elevation: 2.5,
                icon: Image.asset("assets/images/google_light.png"),
                label: Text(
                  "Sign in with Google",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  login() {
    usersService.loginUser().then((user) {
      print(user);
    }).catchError((e) {
      print(e);
      Helper.notify(
        context,
        message: e.message,
        type: DialogType.ERROR,
      );
    });
  }
}
