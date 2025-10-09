import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/entrepreneur_profile.dart';

void showEntrepreneurEditBottomSheet(
  BuildContext context,
  EntrepreneurProfile profile,
  Future<Uint8List?> Function() pickImage,
  void Function(EntrepreneurProfile) onSave,
) {
  String tempName = profile.name;
  String tempAbout = profile.about;
  String tempPhone = profile.phone;
  String tempExperience = profile.experience;
  String tempSkills = profile.skills;
  String tempRole = profile.role;
  Uint8List? tempProfileImage = profile.profileImageBytes;
  Uint8List? tempIdImage = profile.idImageBytes;

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
                          tempProfileImage = bytes;
                        });
                      }
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: cs.tertiary,
                        backgroundImage: tempProfileImage != null
                            ? MemoryImage(tempProfileImage!)
                            : null,
                        child: tempProfileImage == null
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
                              tempIdImage = bytes;
                            });
                          }
                        },
                        child: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: tempIdImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(tempIdImage!,
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
                          onSave(EntrepreneurProfile(
                            name: nameController.text,
                            about: aboutController.text,
                            phone: phoneController.text,
                            experience: experienceController.text,
                            skills: skillsController.text,
                            role: tempRole,
                            profileImageBytes: tempProfileImage,
                            idImageBytes: tempIdImage,
                          ));
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
