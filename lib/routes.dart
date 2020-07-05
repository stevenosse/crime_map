import 'package:crime_map/views/home.dart';
import 'package:crime_map/views/login.dart';
import 'package:flutter/material.dart';

var routes = {
  "/": (BuildContext context) => LoginPage(),
  "/home": (BuildContext context) => HomePage(),
};
