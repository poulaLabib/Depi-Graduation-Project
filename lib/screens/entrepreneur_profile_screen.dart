import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/entrepreneur.dart';
import '../custom widgets/entrepreneur_profile_field.dart';
import '../theme/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const EntrepreneurProfileScreen(),
    );
  }
}

class EntrepreneurProfileScreen extends StatefulWidget {
  const EntrepreneurProfileScreen({super.key});

  @override
  State<EntrepreneurProfileScreen> createState() =>
      _EntrepreneurProfileScreenState();
}

class _EntrepreneurProfileScreenState
    extends State<EntrepreneurProfileScreen> {
  Entrepreneur profile = Entrepreneur(
    uid: "1",
    name: "Omar Ahmed",
    about: "About section here",
    phoneNumber: "+20123456789",
    experience: "3 years in tech",
    skills: ["Flutter", "Dart"],
    role: "Entrepreneur",
    profileImageUrl: "",
    idImageUrl: "", 
    nationalIdUrl: '305000123456789',
  );

  final ImagePicker _picker = ImagePicker();

  Future<String?> _pickImageAndConvert() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    final bytes = await picked.readAsBytes();
    return String.fromCharCodes(bytes);
  }

  void _openEditBottomSheet() {
    final cs = Theme.of(context).colorScheme;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          String tempAbout = profile.about;
          String tempPhone = profile.phoneNumber;
          String tempExperience = profile.experience;
          List<String> tempSkills = profile.skills;
          String tempRole = profile.role;
          String tempProfileImage = profile.profileImageUrl;
          String tempIdImage = profile.idImageUrl;

          final aboutController = TextEditingController(text: tempAbout);
          final phoneController = TextEditingController(text: tempPhone);
          final experienceController =
              TextEditingController(text: tempExperience);
          final skillsController = TextEditingController(text: tempSkills.join(', '));
          final roleController = TextEditingController(text: tempRole);

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
                      final imgStr = await _pickImageAndConvert();
                      if (imgStr != null) {
                        setModalState(() => tempProfileImage = imgStr);
                      }
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: cs.tertiary,
                        backgroundImage: tempProfileImage.isNotEmpty
                            ? MemoryImage(
                                Uint8List.fromList(tempProfileImage.codeUnits))
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
                  _buildEditField("About", aboutController, cs),
                  _buildEditField("Phone Number", phoneController, cs),
                  _buildEditField("Experience", experienceController, cs),
                  _buildEditField("Skills", skillsController, cs),
                  _buildEditField("Role", roleController, cs),
                  const SizedBox(height: 20),
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
                          final imgStr = await _pickImageAndConvert();
                          if (imgStr != null) {
                            setModalState(() => tempIdImage = imgStr);
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
                          setState(() {
                            profile = Entrepreneur(
                              uid: profile.uid,
                              name: profile.name,
                              about: aboutController.text,
                              phoneNumber: phoneController.text,
                              experience: experienceController.text,
                              skills: skillsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
                              role: roleController.text,
                              profileImageUrl: tempProfileImage,
                              idImageUrl: tempIdImage,
                              nationalIdUrl: tempIdImage,
                            );
                          });
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
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.pop(context)),
                  _topButton(label: "Edit", onTap: _openEditBottomSheet),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 120,
                width: 120,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: profile.profileImageUrl.isNotEmpty
                      ? MemoryImage(
                          Uint8List.fromList(profile.profileImageUrl.codeUnits))
                      : null,
                  child: profile.profileImageUrl.isEmpty
                      ? const Icon(Icons.camera_alt,
                          size: 40, color: Colors.black)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                profile.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              EntrepreneurProfileField(title: "About", value: profile.about),
              EntrepreneurProfileField(
                  title: "Phone Number", value: profile.phoneNumber),
              EntrepreneurProfileField(
                  title: "Experience", value: profile.experience),
              EntrepreneurProfileField(title: "Skills", value: profile.skills.join(', ')),
              EntrepreneurProfileField(title: "Role", value: profile.role),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Personal ID",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: profile.idImageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              Uint8List.fromList(profile.idImageUrl.codeUnits),
                              fit: BoxFit.contain,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF91C7E5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  size: 40, color: Colors.black),
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topButton(
      {String? label, IconData? icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: icon != null
            ? Icon(icon, color: Colors.black)
            : Text(label!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }
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
