import 'package:flutter/material.dart';
import 'package:pal/Constant/color.dart';

Future showDialogBox({@required BuildContext context, List<Widget> actions, String title, String content, Widget widget, bool barrierDismissible}) {
  return showDialog(barrierDismissible: barrierDismissible ?? true, context: context, builder: (_) => AlertDialog(
    title: title != null ? Text(title) : widget != null ? widget : null,
    content: content != null ? Text(content) : null,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    actions: actions,
  ));
}


Widget buildAlertButton({@required BuildContext context, @required String text, @required VoidCallback onPressed, Color textColor}){
  return FlatButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: Theme.of(context).textTheme.bodyText1.copyWith(
          color: textColor ?? AppColors.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.bold),
    ),
  );
}