import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dynamic button({@required BuildContext context, double height, String text, @required VoidCallback onPressed, Widget child, double width, Color color, EdgeInsets padding, Color textColor}){
  Size size = MediaQuery.of(context).size;
  Widget childData;
  if(text != null && text != "") {
    childData = Text(text ?? " ",
      style: Theme.of(context).textTheme.bodyText1.copyWith(color: textColor ?? Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  } else if(child != null) {
    childData = child;
  } else return;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    width: width ?? size.width,
    height: height ?? 0,
    child: FlatButton(
      padding: padding ?? null,
      child: childData,
      color: color ?? Colors.red,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    ),
  );
}