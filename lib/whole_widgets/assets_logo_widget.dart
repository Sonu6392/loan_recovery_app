import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.width = double.infinity,
    this.height = 300,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/logos/app_logo.png",
      width: width,
      height: height,
      fit: fit,
    );
  }
}