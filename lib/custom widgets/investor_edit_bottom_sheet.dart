import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/investor.dart';

void showEditBottomSheet(
  BuildContext context,
  Investor profile,
  Future<Uint8List?> Function() pickImage,
  void Function(Investor) onSave,
) {
  String tempAbout = profile.about;
  String tempPhone = profile.phoneNumber;
  String tempExperience = profile.experience;
  List<String> tempSkills = List<String>.from(profile.skills);
  int tempInvestmentCapacity = profile.investmentCapacity;
  List<String> tempPreferredIndustries =
      List<String>.from(profile.preferredIndustries);
  String tempInvestorType = profile.investorType;

  Uint8List? tempProfileImageBytes;
  Uint8List? tempIdImageBytes;

  // Controllers
  final aboutController = TextEditingController(text: tempAbout);
  final phoneController = TextEditingController(text: tempPhone);
  final experienceController = TextEditingController(text: tempExperience);
  final skillsController =
      TextEditingController(text: tempSkills.join(', '));
  final investmentCapacityController =
      TextEditingController(text: tempInvestmentCapacity.toString());
  final preferredIndustriesController =
      TextEditingController(text: tempPreferredIndustries.join(', '));

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
                  GestureDetector(
                    onTap: () async {
                      final bytes = await pickImage();
                      if (bytes != null) {
                        setModalState(() {
                          tempProfileImageBytes = bytes;
                        });
                      }
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: cs.tertiary,
                        backgroundImage: tempProfileImageBytes != null
                            ? MemoryImage(tempProfileImageBytes!)
                            : (profile.photoUrl.isNotEmpty
                                ? NetworkImage(profile.photoUrl)
                                : null) as ImageProvider?,
                        child: (tempProfileImageBytes == null &&
                                profile.photoUrl.isEmpty)
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

                  _buildEditField("About", aboutController, cs),
                  _buildEditField("Phone Number", phoneController, cs),
                  _buildEditField("Experience", experienceController, cs),
                  _buildEditField("Skills (comma separated)", skillsController, cs),
                  _buildEditField("Investment Capacity",
                      investmentCapacityController, cs,
                      isNumber: true),
                  _buildEditField("Preferred Industries (comma separated)",
                      preferredIndustriesController, cs),

                  const SizedBox(height: 10),
                  // Investor Type Dropdown
                  _buildInvestorTypeDropdown(
                      tempInvestorType, cs, (value) {
                    setModalState(() {
                      tempInvestorType = value!;
                    });
                  }),

                  const SizedBox(height: 20),

                  // National ID
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Personal ID",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: cs.onSurface)),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () async {
                          final bytes = await pickImage();
                          if (bytes != null) {
                            setModalState(() {
                              tempIdImageBytes = bytes;
                            });
                          }
                        },
                        child: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: tempIdImageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(tempIdImageBytes!,
                                      fit: BoxFit.contain),
                                )
                              : (profile.nationalIdUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                          profile.nationalIdUrl,
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
                                    )),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBottomSheetButton(
                        label: "Cancel",
                        onTap: () => Navigator.pop(context),
                        cs: cs,
                      ),
                      _buildBottomSheetButton(
                        label: "Save",
                        onTap: () {
                          onSave(Investor(
                            uid: profile.uid,
                            name: profile.name,
                            investorType: tempInvestorType,
                            photoUrl: profile.photoUrl,
                            about: aboutController.text,
                            phoneNumber: phoneController.text,
                            experience: experienceController.text,
                            skills: skillsController.text
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList(),
                            investmentCapacity: int.tryParse(
                                    investmentCapacityController.text) ??
                                0,
                            nationalIdUrl: profile.nationalIdUrl,
                            preferredIndustries:
                                preferredIndustriesController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .where((e) => e.isNotEmpty)
                                    .toList(),
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

Widget _buildEditField(String title, TextEditingController controller,
    ColorScheme cs,
    {bool isNumber = false}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: cs.onSurface)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cs.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: const InputDecoration(border: InputBorder.none),
            style: TextStyle(color: cs.onSecondary),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInvestorTypeDropdown(
    String value, ColorScheme cs, ValueChanged<String?> onChanged) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Investor Type",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: cs.onSurface)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cs.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(border: InputBorder.none),
            dropdownColor: cs.secondary,
            items: const [
              DropdownMenuItem(
                  value: "Venture Capital", child: Text("Venture Capital")),
              DropdownMenuItem(
                  value: "Angel Investor", child: Text("Angel Investor")),
            ],
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: cs.onSecondary),
            style: TextStyle(color: cs.onSecondary),
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
