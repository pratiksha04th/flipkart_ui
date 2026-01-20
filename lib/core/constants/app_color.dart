import 'dart:ui';
import 'package:flutter/material.dart';

class AppColor {
  static Color backgroundColor = Color(0xFF047BD5); // yellow color used in flipkart
  static const Gradient headerColor1 = LinearGradient(    //  color used in the header of the home screen
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xEFFF3D00),Color(0xF0FF6A00),],
  );
  static const Color  headerColor2 = Color(0xFFB3E5FC); // lightBlue color used in the header of the Product_detail_screen
}