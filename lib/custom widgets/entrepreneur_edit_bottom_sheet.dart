import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/entrepreneur.dart';

void showEntrepreneurEditBottomSheet(
  BuildContext context,
  Entrepreneur profile,
  Future<Uint8List?> Function() pickImage,
  void Function(Entrepreneur) onSave,
) {
  String tempName = profile.name;
  String tempAbout = profile.about;
  String tempPhone = profile.phoneNumber;
  String tempExperience = profile.experience;
  String tempSkills = profile.skills.join(', ');
  String tempRole = profile.role;
  String tempProfileImage = profile.profileImageUrl;
  String tempIdImage = profile.idImageUrl;

  final nameController = TextEditingController(text: tempName);
  final aboutController = TextEditingController(text: tempAbout);
  final phoneController = TextEditingController(text: tempPhone);
  final experienceController = TextEditingController(text: tempExperience);
  final skillsController = TextEditingController(text: tempSkills);

  final cs = Theme.of(context).colorScheme;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: cs.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
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
                  // Profile Image
                  GestureDetector(
                    onTap: () async {
                      final bytes = await pickImage();
                      if (bytes != null) {
                        setModalState(() {
                          tempProfileImage = String.fromCharCodes(bytes);
                        });
                      }
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: cs.tertiary,
                        backgroundImage: tempProfileImage.isNotEmpty
                            ? MemoryImage(Uint8List.fromList(
                                tempProfileImage.codeUnits))
                            : null,
                        child: tempProfileImage.isEmpty
                            ? Icon(Icons.camera_alt,
                                size: 40, color: cs.onTertiary)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(profile.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface)),
                  const SizedBox(height: 20),

                  // Fields
                  _buildEditField("Name", nameController, cs),
                  _buildEditField("About", aboutController, cs),
                  _buildEditField("Phone Number", phoneController, cs),
                  _buildEditField("Experience", experienceController, cs),
                  _buildEditField("Skills", skillsController, cs),

                  // Role Dropdown
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Role",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: cs.onSurface)),
                        const SizedBox(height: 6),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: cs.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: tempRole,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            dropdownColor: cs.secondary,
                            items: const [
                              DropdownMenuItem(
                                  value: "Entrepreneur",
                                  child: Text("Entrepreneur")),
                              DropdownMenuItem(
                                  value: "Founder", child: Text("Founder")),
                              DropdownMenuItem(
                                  value: "Co-Founder",
                                  child: Text("Co-Founder")),
                            ],
                            onChanged: (value) {
                              setModalState(() {
                                tempRole = value!;
                              });
                            },
                            icon: Icon(Icons.arrow_drop_down,
                                color: cs.onSecondary),
                            style: TextStyle(color: cs.onSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ID Image
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Personal ID",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: cs.onSurface)),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () async {
                          final bytes = await pickImage();
                          if (bytes != null) {
                            setModalState(() {
                              tempIdImage = String.fromCharCodes(bytes);
                            });
                          }
                        },
                        child: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: tempIdImage.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                      Uint8List.fromList(tempIdImage.codeUnits),
                                      fit: BoxFit.contain),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: cs.secondary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add,
                                            color: cs.onSecondary, size: 30),
                                        Text("Upload your national ID",
                                            style: TextStyle(
                                                color: cs.onSecondary)),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBottomSheetButton(
                          label: "Cancel",
                          onTap: () => Navigator.pop(context),
                          cs: cs),
                      _buildBottomSheetButton(
                        label: "Save",
                        onTap: () {
                          onSave(
                            Entrepreneur(
                              uid: profile.uid,
                              name: nameController.text,
                              about: aboutController.text,
                              phoneNumber: phoneController.text,
                              experience: experienceController.text,
                              skills: skillsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
                              role: tempRole,
                              profileImageUrl: tempProfileImage,
                              idImageUrl: tempIdImage,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        cs: cs,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildEditField(
    String title, TextEditingController controller, ColorScheme cs,
    {bool isNumber = false}) {
  return Container(
    margin: const EdgeInsets.only(top: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: cs.onSurface)),
        const SizedBox(height: 6),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cs.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
            ),
            style: TextStyle(color: cs.onSecondary, fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBottomSheetButton({
  required String label,
  required VoidCallback onTap,
  required ColorScheme cs,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: cs.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: cs.onTertiary)),
    ),
  );
}
