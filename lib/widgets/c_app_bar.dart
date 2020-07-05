import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Widget searchbar;

  CAppBar({this.title, this.searchbar});

  final double kheight = 120;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).accentColor,
      ),
    );
    return SafeArea(
      child: Container(
        width: size.width,
        height: kheight,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(0, -5),
              color: Colors.black.withOpacity(0.2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: kheight * 0.15),
              if (searchbar != null) searchbar
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kheight);
}
