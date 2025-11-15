import 'package:flutter/material.dart';

class InvestorProfileTextfield extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const InvestorProfileTextfield({
    super.key,
    required this.title,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputField = TextFormField(
      maxLines: null,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
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
            child: inputField,
          ),
        ],
      ),
    );
  }
}
