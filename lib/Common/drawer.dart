import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Drawer drawer({@required BuildContext context, @required GlobalKey<ScaffoldState> scaffoldKey}) {
  return Drawer(
    child: SizedBox.shrink(),
  );
}

class DrawerItem {
  final Icon icon;
  final String text;
  final GestureTapCallback onTap;
  DrawerItem({this.icon, this.text, this.onTap});
}
