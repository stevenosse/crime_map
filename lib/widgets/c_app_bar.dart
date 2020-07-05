import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Widget searchbar;
  final List<Widget> actions;

  CAppBar({this.title, this.searchbar, this.actions});

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
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  if (actions != null) ...actions
                ],
              ),
              SizedBox(height: 5),
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
