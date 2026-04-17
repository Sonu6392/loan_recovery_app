import 'package:flutter/material.dart';

class CustomTextSection extends StatelessWidget {
  final String title;
  final String description;

  const CustomTextSection({
    super.key, required this.title, required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "DM Serif Display",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 10),
        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Lato",
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}