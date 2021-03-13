import 'package:flutter/material.dart';
import '../../constant/color.dart';


Future showDialogBox(
    {@required BuildContext context,
    List<Widget> actions,
    String title,
    String content,
    Widget titleWidget,
    Widget widget,
    bool barrierDismissible}) {
  return showDialog(
      barrierDismissible: barrierDismissible ?? true,
      context: context,
      builder: (_) => AlertDialog(
            title: title != null
                ? Text(title)
                : titleWidget != null
                    ? titleWidget
                    : null,
            content: content != null ? Text(content) : widget,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            actions: actions,
          ));
}

Widget buildAlertButton(
    {@required BuildContext context,
    @required String text,
    @required VoidCallback onPressed,
    Color textColor}) {
  return FlatButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: Theme.of(context).textTheme.bodyText1.copyWith(
          color: textColor ?? primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.bold),
    ),
  );
}
