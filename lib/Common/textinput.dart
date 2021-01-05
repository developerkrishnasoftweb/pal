import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget input(
    {@required BuildContext context,
    InputDecoration decoration,
    TextStyle style,
    GestureTapCallback onTap,
    TextEditingController controller,
    bool obscureText,
    bool autoFocus,
    ValueChanged<String> onChanged,
    VoidCallback onEditingComplete,
    String text,
    TextInputType keyboardType,
    bool readOnly,
    EdgeInsetsGeometry padding,
    double width,
    TextStyle labelStyle,
    TextInputAction textInputAction,
    FocusNode focusNode,
    double height,
    int maxLines}) {
  Size size = MediaQuery.of(context).size;
  return Container(
    padding: padding ?? const EdgeInsets.all(10),
    width: width ?? size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text ?? " ",
          style: labelStyle ??
              Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: height,
          child: TextFormField(
            autofocus: autoFocus ?? false,
            maxLines: maxLines ?? 1,
            decoration: decoration ?? null,
            style: style ?? null,
            onTap: onTap ?? null,
            controller: controller ?? null,
            obscureText: obscureText ?? false,
            onChanged: onChanged ?? null,
            onEditingComplete: onEditingComplete ?? null,
            textInputAction: textInputAction ?? null,
            keyboardType: keyboardType,
            readOnly: readOnly ?? false,
            focusNode: focusNode,
          ),
        ),
      ],
    ),
  );
}
