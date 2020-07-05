import 'package:crime_map/routes.dart';
import 'package:flutter/material.dart';

main(List<String> args) {
  return runApp(CrimeMap());
}

class CrimeMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      initialRoute: "/",
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0XFFff1744),
        fontFamily: "Aileron",
      ),
    );
  }
}
