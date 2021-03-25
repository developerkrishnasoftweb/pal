import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pal/constant/color.dart';

Widget customButton({@required BuildContext context, double height, String text, @required VoidCallback onPressed, Widget child, double width, Color color, EdgeInsets padding, Color textColor, EdgeInsets margin, ShapeBorder shape}){
  Size size = MediaQuery.of(context).size;
  Widget childData;
  if(text != null && text != "") {
    childData = Text(text ?? " ",
      style: Theme.of(context).textTheme.bodyText1.copyWith(color: textColor ?? Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  } else if(child != null) {
    childData = child;
  } else return Container();

  return Container(
    margin: margin ?? const EdgeInsets.symmetric(horizontal: 10),
    width: width ?? size.width,
    height: height ?? 50,
    child: FlatButton(
      padding: padding ?? null,
      child: childData,
      color: color ?? primaryColor,
      onPressed: onPressed,
      shape: shape ?? RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    ),
  );
}