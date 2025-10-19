import 'package:flutter/material.dart';

void showEntrepreneurEditBottomSheet(BuildContext context) {
  final cs = Theme.of(context).colorScheme;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: cs.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: cs.tertiary,
                  child: Icon(Icons.camera_alt, size: 40, color: cs.onTertiary),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Omar Ahmed",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 20),

              _buildEditField("Name", "Omar Ahmed", cs),
              _buildEditField("About", "About section here", cs),
              _buildEditField("Phone Number", "+20123456789", cs),
              _buildEditField("Experience", "3 years in tech", cs),
              _buildEditField("Skills", "Flutter, Dart", cs),

              Container(
                margin: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Role",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: cs.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Entrepreneur",
                            style: TextStyle(color: cs.onSecondary),
                          ),
                          Icon(Icons.arrow_drop_down, color: cs.onSecondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal ID",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cs.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: cs.onSecondary, size: 30),
                          Text(
                            "Upload your national ID",
                            style: TextStyle(color: cs.onSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomSheetButton(label: "Cancel", cs: cs),
                  _buildBottomSheetButton(label: "Save", cs: cs),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildEditField(String title, String value, ColorScheme cs) {
  return Container(
    margin: const EdgeInsets.only(top: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cs.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(color: cs.onSecondary, fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBottomSheetButton({
  required String label,
  required ColorScheme cs,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    decoration: BoxDecoration(
      color: cs.tertiary,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(label, style: TextStyle(color: cs.onTertiary)),
  );
}
