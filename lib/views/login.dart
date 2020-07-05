import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crime_map/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:crime_map/services/users_service.dart';
import 'package:crime_map/widgets/footer_painter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10)).then((value) async {
      if (await usersService.isLoggedIn()) {
        Navigator.of(context).pushReplacementNamed("/home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: size.width,
          child: Stack(
            children: <Widget>[
              Container(
                width: size.width,
                height: size.height,
                child: CustomPaint(
                  painter: FooterPainter(),
                ),
              ),
              Column(
                children: <Widget>[
                  Spacer(),
                  Container(
                    width: 200,
                    height: 200,
                    child:
                        Image.asset("assets/images/map.png", fit: BoxFit.cover),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Crime",
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).accentColor,
                      ),
                      children: [
                        TextSpan(
                          text: "MAP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: size.width,
                      child: RaisedButton.icon(
                        color: Colors.white,
                        onPressed: login,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        elevation: 2,
                        icon: Image.asset("assets/images/google_light.png"),
                        label: Text(
                          "Sign in with Google",
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() {
    usersService.loginUser().then((user) {
      Navigator.of(context).pushReplacementNamed("/home");
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
