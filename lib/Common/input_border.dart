import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

OutlineInputBorder border({double borderRadius}){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius ?? 10),
    borderSide: BorderSide(color: Colors.grey)
  );
}