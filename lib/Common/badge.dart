import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Stack badge(
    {@required Widget iconButton,
      Color badgeColor,
      int badgeValue,
      Size badgeSize,
      BadgePosition badgePosition,
      TextStyle badgeTextStyle}) {
  if(badgePosition == null) {
    badgePosition = BadgePosition();
  }
  return Stack(
    alignment: Alignment.center,
    children: [
      Positioned(
        top: badgePosition.top ?? 5,
        right: badgePosition.right ?? 5,
        left: badgePosition.left,
        bottom: badgePosition.bottom,
        child: AnimatedContainer(
          height: badgeValue == 0
              ? 0
              : badgeSize != null
              ? badgeSize.height
              : 17,
          width: badgeValue == 0
              ? 0
              : badgeSize != null
              ? badgeSize.width
              : 17,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 500),
          curve: Curves.bounceInOut,
          child: Text(
            badgeValue.toString(),
            style:
            badgeTextStyle ?? TextStyle(color: Colors.white, fontSize: 10),
          ),
          decoration: BoxDecoration(
              color: badgeColor ?? Colors.black,
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
      iconButton
    ],
  );
}

class BadgePosition {
  final double top, bottom, right, left;
  BadgePosition({this.bottom, this.left, this.right, this.top});
}
