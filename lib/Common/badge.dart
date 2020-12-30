import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Stack badge({@required IconButton iconButton, @required BuildContext context, Color badgeColor, int badgeValue, @required Size badgeSize, double top, double bottom, double left, double right}){
  return Stack(
    alignment: Alignment.center,
    children: [
      Positioned(
        top: top ?? 2,
        right: right ?? 2,
        left: left ?? null,
        bottom: bottom ?? null,
        child: Container(
          height: badgeSize.height,
          width: badgeSize.width,
          alignment: Alignment.center,
          child: Text(badgeValue.toString(), style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white, fontSize: 8),),
          decoration: BoxDecoration(
              color: badgeColor ?? Colors.black,
              borderRadius: BorderRadius.circular(20)
          ),
        ),
      ),
      iconButton
    ],
  );
}