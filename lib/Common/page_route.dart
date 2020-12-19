import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget widget;
  CustomPageRoute({this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, animationTime, child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.decelerate);
              return SlideTransition(
                position: Tween<Offset>(
                        end: Offset.zero, begin: const Offset(1.0, 0.0))
                    .animate(animation),
                child: SlideTransition(
                  position: Tween<Offset>(
                          end: const Offset(1.0, 0.0), begin: Offset.zero)
                      .animate(animationTime),
                  child: child,
                ),
              );
            },
            pageBuilder: (context, animation, animationTime) => widget);
}
