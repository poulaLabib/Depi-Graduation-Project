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
    final theme = Theme.of(context);
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: theme.colorScheme.onSecondary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),

            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: theme.colorScheme.secondary.withAlpha(20),
              border: Border.all(color: theme.colorScheme.primary, width: 0.2),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
                // height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
