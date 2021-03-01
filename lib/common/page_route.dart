import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget widget;
  CustomPageRoute({this.widget})
      : super(
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, animationTime, child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.linear);
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset(0, 0),
          ).animate(
            CurvedAnimation(
              curve: Interval(0, 0.5, curve: Curves.easeOutCubic),
              parent: animation,
            ),
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, animationTime) => widget);
}