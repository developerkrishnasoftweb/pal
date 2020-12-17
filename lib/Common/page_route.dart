import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget widget;
  CustomPageRoute({this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, animationTime, child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return SlideTransition(
                position: Tween<Offset>(
                        end: Offset(-1.0, 0.0), begin: Offset(1.0, 0.0))
                    .animate(animation),
                child: SlideTransition(
                  position: Tween<Offset>(
                          end: Offset(-1.0, 0.0), begin: Offset(1.0, 0.0))
                      .animate(animationTime),
                  child: child,
                ),
              );
            },
            pageBuilder: (context, animation, animationTime) => widget);
}
