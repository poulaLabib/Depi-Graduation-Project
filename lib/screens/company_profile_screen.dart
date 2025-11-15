import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TeamMember {
  String name;
  String role;

  TeamMember({required this.name, required this.role});
}

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  String companyName = "Tech Innovations Inc.";
  String description = "We build innovative solutions for modern businesses";
  String founded = "2020";
  String teamSize = "15";
  String industry = "Technology";
  String stage = "Series A";
  String currency = "USD";
  String location = "Cairo, Egypt";
  Uint8List? companyLogo;
  Uint8List? verifiedCertificate;

  List<TeamMember> teamMembers = [
    TeamMember(name: "Ahmed Ali", role: "CEO"),
    TeamMember(name: "Sara Mohamed", role: "CTO"),
    TeamMember(name: "Omar Hassan", role: "CFO"),
  ];

  final ImagePicker _picker = ImagePicker();

  // ignore: unused_element
  Future<void> _pickImage(bool isLogo) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        if (isLogo) {
          companyLogo = bytes;
        } else {
          verifiedCertificate = bytes;
        }
      });
    }
  }

  void _openEditScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyProfileEditScreen(
          companyName: companyName,
          description: description,
          founded: founded,
          teamSize: teamSize,
          industry: industry,
          stage: stage,
          currency: currency,
          location: location,
          teamMembers: teamMembers,
          companyLogo: companyLogo,
          verifiedCertificate: verifiedCertificate,
          onSave: (
            String newName,
            String newDescription,
            String newFounded,
            String newTeamSize,
            String newIndustry,
            String newStage,
            String newCurrency,
            String newLocation,
            List<TeamMember> newTeamMembers,
            Uint8List? newLogo,
            Uint8List? newCertificate,
          ) {
            setState(() {
              companyName = newName;
              description = newDescription;
              founded = newFounded;
              teamSize = newTeamSize;
              industry = newIndustry;
              stage = newStage;
              currency = newCurrency;
              location = newLocation;
              teamMembers = newTeamMembers;
              companyLogo = newLogo;
              verifiedCertificate = newCertificate;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTopWhiteButton(
                    Icons.arrow_back,
                    () => Navigator.pop(context),
                  ),
                  buildTopWhiteButton(
                    null,
                    _openEditScreen,
                    label: "Edit",
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Company Logo
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.primary, width: 0.2),
                  ),
                  child: companyLogo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            companyLogo!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  companyName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Divider(
                  color: Theme.of(context).colorScheme.secondary,
                  thickness: 0.6,
                ),
              ),
              const SizedBox(height: 8),

              // Company Information
              buildLabel("Description"),
              buildDisplayBox(description),
              Row(
                children: [
                  Expanded(child: buildLabel("Founded")),
                  const SizedBox(width: 12),
                  Expanded(child: buildLabel("Team Size")),
                ],
              ),
              Row(
                children: [
                  Expanded(child: buildDisplayBox(founded)),
                  const SizedBox(width: 12),
                  Expanded(child: buildDisplayBox(teamSize)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: buildLabel("Industry")),
                  const SizedBox(width: 12),
                  Expanded(child: buildLabel("Stage")),
                ],
              ),
              Row(
                children: [
                  Expanded(child: buildDisplayBox(industry)),
                  const SizedBox(width: 12),
                  Expanded(child: buildDisplayBox(stage)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: buildLabel("Currency")),
                  const SizedBox(width: 12),
                  Expanded(child: buildLabel("Location")),
                ],
              ),
              Row(
                children: [
                  Expanded(child: buildDisplayBox(currency)),
                  const SizedBox(width: 12),
                  Expanded(child: buildDisplayBox(location)),
                ],
              ),

              // Team Members
              buildLabel("Team Members"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withAlpha(20),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Theme.of(context).colorScheme.primary, width: 0.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: teamMembers.map((member) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSurface,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${member.name} - ${member.role}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Verified Certificate
              buildLabel("Verified Certificate (optional)"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withAlpha(20),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Theme.of(context).colorScheme.primary, width: 0.2),
                  ),
                  child: verifiedCertificate != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.memory(
                            verifiedCertificate!,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.add,
                            size: 50,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 14),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: theme.colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  Widget buildDisplayBox(String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: theme.colorScheme.secondary.withAlpha(20),
          border: Border.all(color: theme.colorScheme.primary, width: 0.2),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget buildTopWhiteButton(IconData? icon, VoidCallback onPressed,
      {String? label}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.3)),
        ),
        child: icon != null
            ? Icon(icon, color: theme.colorScheme.onSurface)
            : Text(
                label!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
      ),
    );
  }
}

// Edit Screen
class CompanyProfileEditScreen extends StatefulWidget {
  final String companyName;
  final String description;
  final String founded;
  final String teamSize;
  final String industry;
  final String stage;
  final String currency;
  final String location;
  final List<TeamMember> teamMembers;
  final Uint8List? companyLogo;
  final Uint8List? verifiedCertificate;
  final Function(
    String,
    String,
    String,
    String,
    String,
    String,
    String,
    String,
    List<TeamMember>,
    Uint8List?,
    Uint8List?,
  ) onSave;

  const CompanyProfileEditScreen({
    super.key,
    required this.companyName,
    required this.description,
    required this.founded,
    required this.teamSize,
    required this.industry,
    required this.stage,
    required this.currency,
    required this.location,
    required this.teamMembers,
    required this.companyLogo,
    required this.verifiedCertificate,
    required this.onSave,
  });

  @override
  State<CompanyProfileEditScreen> createState() =>
      _CompanyProfileEditScreenState();
}

class _CompanyProfileEditScreenState extends State<CompanyProfileEditScreen> {
  late TextEditingController companyNameController;
  late TextEditingController descriptionController;
  late TextEditingController foundedController;
  late TextEditingController teamSizeController;
  late TextEditingController industryController;
  late TextEditingController stageController;
  late TextEditingController currencyController;
  late TextEditingController locationController;

  List<TeamMember> tempTeamMembers = [];
  Uint8List? tempCompanyLogo;
  Uint8List? tempCertificate;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    companyNameController = TextEditingController(text: widget.companyName);
    descriptionController = TextEditingController(text: widget.description);
    foundedController = TextEditingController(text: widget.founded);
    teamSizeController = TextEditingController(text: widget.teamSize);
    industryController = TextEditingController(text: widget.industry);
    stageController = TextEditingController(text: widget.stage);
    currencyController = TextEditingController(text: widget.currency);
    locationController = TextEditingController(text: widget.location);

    tempTeamMembers = List.from(widget.teamMembers);
    tempCompanyLogo = widget.companyLogo;
    tempCertificate = widget.verifiedCertificate;
  }

  @override
  void dispose() {
    companyNameController.dispose();
    descriptionController.dispose();
    foundedController.dispose();
    teamSizeController.dispose();
    industryController.dispose();
    stageController.dispose();
    currencyController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isLogo) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        if (isLogo) {
          tempCompanyLogo = bytes;
        } else {
          tempCertificate = bytes;
        }
      });
    }
  }

  void _addTeamMember() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final roleController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Team Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    roleController.text.isNotEmpty) {
                  setState(() {
                    tempTeamMembers.add(TeamMember(
                      name: nameController.text,
                      role: roleController.text,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeTeamMember(int index) {
    setState(() {
      tempTeamMembers.removeAt(index);
    });
  }

  void _saveProfile() {
    widget.onSave(
      companyNameController.text,
      descriptionController.text,
      foundedController.text,
      teamSizeController.text,
      industryController.text,
      stageController.text,
      currencyController.text,
      locationController.text,
      tempTeamMembers,
      tempCompanyLogo,
      tempCertificate,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildTopWhiteButton("Cancel", () {
                    Navigator.pop(context);
                  }),
                  const SizedBox(width: 8),
                  buildTopWhiteButton("Save", _saveProfile),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Company Logo
                    Center(
                      child: GestureDetector(
                        onTap: () => _pickImage(true),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: tempCompanyLogo != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    tempCompanyLogo!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Upload Company Logo',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Fields
                    buildLabel("Company Name"),
                    buildEditBox(companyNameController),
                    buildLabel("Description"),
                    buildEditBox(descriptionController),

                    Row(
                      children: [
                        Expanded(child: buildLabel("Founded")),
                        const SizedBox(width: 12),
                        Expanded(child: buildLabel("Team Size")),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: buildEditBox(foundedController)),
                        const SizedBox(width: 12),
                        Expanded(child: buildEditBox(teamSizeController)),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(child: buildLabel("Industry")),
                        const SizedBox(width: 12),
                        Expanded(child: buildLabel("Stage")),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: buildEditBox(industryController)),
                        const SizedBox(width: 12),
                        Expanded(child: buildEditBox(stageController)),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(child: buildLabel("Currency")),
                        const SizedBox(width: 12),
                        Expanded(child: buildLabel("Location")),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: buildEditBox(currencyController)),
                        const SizedBox(width: 12),
                        Expanded(child: buildEditBox(locationController)),
                      ],
                    ),

                    // Team Members
                    buildLabel("Team Members"),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF91C7E5),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          ...tempTeamMembers.asMap().entries.map((entry) {
                            final index = entry.key;
                            final member = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${member.name} - ${member.role}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.red, size: 20),
                                    onPressed: () => _removeTeamMember(index),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _addTeamMember,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, size: 20),
                                  SizedBox(width: 4),
                                  Text('Add Team Member'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Certificate
                    buildLabel("Verified Certificate (optional)"),
                    GestureDetector(
                      onTap: () => _pickImage(false),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF91C7E5),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: tempCertificate != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.memory(
                                  tempCertificate!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        size: 40, color: Colors.black54),
                                    SizedBox(height: 8),
                                    Text(
                                      'Upload Certificate',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 14),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: theme.colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  Widget buildEditBox(TextEditingController controller, {int maxLines = 1}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: theme.colorScheme.secondary.withAlpha(20),
          border: Border.all(color: theme.colorScheme.primary, width: 0.2),
        ),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: const InputDecoration(border: InputBorder.none),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget buildTopWhiteButton(String text, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}