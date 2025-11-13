import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntrepreneurProfileTextfield extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const EntrepreneurProfileTextfield({
    super.key,
    required this.title,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final inputField = TextFormField(
      maxLines: null,
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.multiline,
      style: GoogleFonts.roboto(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
    );

    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: 13,
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
          child: inputField,
        ),
      ],
    );
  }
}
