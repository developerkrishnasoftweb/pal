import 'package:flutter/cupertino.dart';

Route createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget widget;
  CustomPageRoute({this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, animationTime, child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.decelerate);
              return SlideTransition(
                position: Tween<Offset>(
                        end: Offset(-1.0, 0.0), begin: Offset(1.0, 0.0))
                    .animate(animation),
                child: SlideTransition(
                  position: Tween<Offset>(
                          end: Offset(1.0, 0.0), begin: Offset(-1.0, 0.0))
                      .animate(animationTime),
                  child: child,
                ),
              );
            },
            pageBuilder: (context, animation, animationTime) => widget);
}
