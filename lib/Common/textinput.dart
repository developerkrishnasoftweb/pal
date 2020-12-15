import 'package:flutter/material.dart';

Widget input(
    {@required BuildContext context,
    InputDecoration decoration,
    TextStyle style,
    GestureTapCallback onTap,
    TextEditingController controller,
    bool obscureText,
    ValueChanged<String> onChanged,
    String text,
    TextInputType keyboardType,
    bool readOnly,
    EdgeInsetsGeometry padding,
    double width,
    TextStyle labelStyle,
    int maxLines}) {
  Size size = MediaQuery.of(context).size;
  return Container(
    padding:
        padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    width: size.width ?? width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text ?? " ",
          style: labelStyle ??
              Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          maxLines: maxLines ?? 1,
          decoration: decoration ?? null,
          style: style ?? null,
          onTap: onTap ?? null,
          controller: controller ?? null,
          obscureText: obscureText ?? false,
          onChanged: onChanged ?? null,
          keyboardType: keyboardType,
          readOnly: readOnly ?? false,
        ),
      ],
    ),
  );
}
