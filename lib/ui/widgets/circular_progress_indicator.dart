import 'package:flutter/material.dart';
import '../../constant/color.dart';

CircularProgressIndicator circularProgressIndicator({Color color}) {
  return CircularProgressIndicator(
    strokeWidth: 3,
    valueColor: AlwaysStoppedAnimation(color ?? primaryColor),
  );
}