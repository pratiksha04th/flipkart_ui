import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/features/cart/logic/cart_function.dart';
import 'core/features/home/home_screen.dart';

void main() {
  Get.put(CartController());
  runApp(const FlipkartApp());

}

class FlipkartApp extends StatelessWidget {
  const FlipkartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flipkart UI',
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const HomeScreen(),
    );
  }
}


