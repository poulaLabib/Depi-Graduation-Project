import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntrepreneurProfileField extends StatelessWidget {
  final String title;
  final String value;

  const EntrepreneurProfileField({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
            letterSpacing: -0.1,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF91C7E5).withAlpha(200),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black.withAlpha(40), width: 1),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
