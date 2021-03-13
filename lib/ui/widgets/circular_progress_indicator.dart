import 'package:flutter/material.dart';
import '../../constant/color.dart';

CircularProgressIndicator circularProgressIndicator() {
  return CircularProgressIndicator(
    strokeWidth: 3,
    valueColor: AlwaysStoppedAnimation(primaryColor),
  );
}