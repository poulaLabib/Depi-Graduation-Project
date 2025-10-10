import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/investor.dart';
import '../custom widgets/investor_profile_field.dart';
import '../custom widgets/investor_edit_bottom_sheet.dart';
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
      home: const InvestorProfileScreen(),
    );
  }
}

class InvestorProfileScreen extends StatefulWidget {
  const InvestorProfileScreen({super.key});

  @override
  State<InvestorProfileScreen> createState() => _InvestorProfileScreenState();
}

class _InvestorProfileScreenState extends State<InvestorProfileScreen> {
  late Investor profile;
  final ImagePicker _picker = ImagePicker();

  Uint8List? tempProfileImageBytes;
  Uint8List? tempIdImageBytes;

  @override
  void initState() {
    super.initState();
    profile = Investor(
      uid: "123",
      name: "Omar Ahmed",
      investorType: "Venture Capital",
      photoUrl: "",
      about: "About section here",
      phoneNumber: "+20123456789",
      experience: "3 years in tech",
      skills: ["Flutter", "Dart"],
      investmentCapacity: 100000,
      nationalIdUrl: "", // ممكن تحط لينك ID
      preferredIndustries: ["Technology"],
    );
  }

  Future<Uint8List?> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      return await picked.readAsBytes();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildTopButton(
                    label: "Edit",
                    onTap: () {
                      showEditBottomSheet(
                        context,
                        profile,
                        _pickImage,
                        (updatedInvestor) {
                          setState(() {
                            profile = updatedInvestor;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
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
                      ? Icon(Icons.camera_alt, size: 40, color: cs.onTertiary)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                profile.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              ProfileField(title: "About", value: profile.about),
              ProfileField(title: "Phone Number", value: profile.phoneNumber),
              ProfileField(title: "Experience", value: profile.experience),
              ProfileField(title: "Skills", value: profile.skills.join(', ')),
              ProfileField(
                  title: "Investment Capacity",
                  value: profile.investmentCapacity.toString()),
              ProfileField(
                  title: "Preferred Industries",
                  value: profile.preferredIndustries.join(', ')),
              ProfileField(title: "Investor Type", value: profile.investorType),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal ID",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: cs.onSurface),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
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
                                child: Image.network(profile.nationalIdUrl,
                                    fit: BoxFit.contain),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: cs.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Icon(Icons.image_not_supported,
                                      size: 40, color: cs.onSecondary),
                                ),
                              )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton(
      {String? label, IconData? icon, required VoidCallback onTap}) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: cs.tertiary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: icon != null
            ? Icon(icon, color: cs.onTertiary)
            : Text(label!,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: cs.onTertiary)),
      ),
    );
  }
}
