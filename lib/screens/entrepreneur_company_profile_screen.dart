import 'package:depi_graduation_project/bloc/company_profile_screen/company_bloc.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/cps_event.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/cps_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntrepreneurCompanyProfileScreen extends StatefulWidget {
  const EntrepreneurCompanyProfileScreen({super.key});

  @override
  State<EntrepreneurCompanyProfileScreen> createState() =>
      _EntrepreneurCompanyProfileScreenState();
}

class _EntrepreneurCompanyProfileScreenState
    extends State<EntrepreneurCompanyProfileScreen> {
  // Controllers for edit mode
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _foundedController = TextEditingController();
  final TextEditingController _teamSizeController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _stageController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<Map<String, dynamic>> _tempTeamMembers = [];
  bool _controllersInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _foundedController.dispose();
    _teamSizeController.dispose();
    _industryController.dispose();
    _stageController.dispose();
    _currencyController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _initializeControllers(EditCompanyInfo state) {
    if (!_controllersInitialized) {
      _nameController.text = state.company.name;
      _descriptionController.text = state.company.description;
      _foundedController.text = state.company.founded.toString();
      _teamSizeController.text = state.company.teamSize.toString();
      _industryController.text = state.company.industry;
      _stageController.text = state.company.stage;
      _currencyController.text = state.company.currency;
      _locationController.text = state.company.location;
      _tempTeamMembers =
          List<Map<String, dynamic>>.from(state.company.teamMembers);
      _controllersInitialized = true;
    }
  }

  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _foundedController.clear();
    _teamSizeController.clear();
    _industryController.clear();
    _stageController.clear();
    _currencyController.clear();
    _locationController.clear();
    _tempTeamMembers.clear();
    _controllersInitialized = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8EE),
      body: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          if (state is LoadingCompanyProfile) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DisplayCompanyInfo) {
            // Reset controllers when switching to display mode
            _controllersInitialized = false;
            return _buildDisplayMode(context, state);
          } else if (state is EditCompanyInfo) {
            // Initialize controllers only once
            _initializeControllers(state);
            return _buildEditMode(context, state);
          } else if (state is CompanyError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CompanyBloc>().add(LoadCompanyProfileData());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text("Something went wrong!"),
          );
        },
      ),
    );
  }

  Widget _buildDisplayMode(BuildContext context, DisplayCompanyInfo state) {
    return SafeArea(
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
                  () {
                    context.read<CompanyBloc>().add(EditCompanyButtonPressed());
                  },
                  label: "Edit",
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Company Logo
            Center(
              child: GestureDetector(
                onTap: () {
                  context.read<CompanyBloc>().add(EditCompanyLogo());
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: state.company.logoUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            state.company.logoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey,
                              );
                            },
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
            const SizedBox(height: 12),
            Center(
              child: Text(
                state.company.name.isEmpty
                    ? "Company Name"
                    : state.company.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.black12, thickness: 1),
            const SizedBox(height: 8),

            // Company Information
            buildLabel("Description"),
            buildDisplayBox(state.company.description.isEmpty
                ? "No description"
                : state.company.description),

            Row(
              children: [
                Expanded(child: buildLabel("Founded")),
                const SizedBox(width: 12),
                Expanded(child: buildLabel("Team Size")),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: buildDisplayBox(state.company.founded == 0
                        ? "Not set"
                        : state.company.founded.toString())),
                const SizedBox(width: 12),
                Expanded(
                    child: buildDisplayBox(state.company.teamSize == 0
                        ? "Not set"
                        : state.company.teamSize.toString())),
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
                Expanded(
                    child: buildDisplayBox(state.company.industry.isEmpty
                        ? "Not set"
                        : state.company.industry)),
                const SizedBox(width: 12),
                Expanded(
                    child: buildDisplayBox(state.company.stage.isEmpty
                        ? "Not set"
                        : state.company.stage)),
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
                Expanded(
                    child: buildDisplayBox(state.company.currency.isEmpty
                        ? "Not set"
                        : state.company.currency)),
                const SizedBox(width: 12),
                Expanded(
                    child: buildDisplayBox(state.company.location.isEmpty
                        ? "Not set"
                        : state.company.location)),
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
              child: state.company.teamMembers.isEmpty
                  ? const Text(
                      "No team members added",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: state.company.teamMembers.map((member) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${member['name'] ?? 'Unknown'} - ${member['role'] ?? 'Unknown'}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),

            // Verified Certificate
            buildLabel("Verified Certificate (optional)"),
            GestureDetector(
              onTap: () {
                context.read<CompanyBloc>().add(EditCompanyCertificate());
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF91C7E5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: state.company.certificateUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          state.company.certificateUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.add,
                                size: 50,
                                color: Colors.black54,
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.black54,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditMode(BuildContext context, EditCompanyInfo state) {
    return SafeArea(
      child: Column(
        children: [
          // Top Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildTopWhiteButton(
                  null,
                  () {
                    _clearControllers();
                    context.read<CompanyBloc>().add(CancelCompanyButtonPressed());
                  },
                  label: "Cancel",
                ),
                const SizedBox(width: 8),
                buildTopWhiteButton(
                  null,
                  () {
                    // Debug print
                    print('Saving team members: $_tempTeamMembers');
                    
                    context.read<CompanyBloc>().add(
                          SaveCompanyButtonPressed(
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                            founded: int.tryParse(_foundedController.text) ?? 0,
                            teamSize:
                                int.tryParse(_teamSizeController.text) ?? 0,
                            industry: _industryController.text.trim(),
                            stage: _stageController.text.trim(),
                            currency: _currencyController.text.trim(),
                            location: _locationController.text.trim(),
                            teamMembers: List<Map<String, dynamic>>.from(_tempTeamMembers),
                          ),
                        );

                    _clearControllers();
                  },
                  label: "Save",
                ),
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
                      onTap: () {
                        context.read<CompanyBloc>().add(EditCompanyLogo());
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: state.company.logoUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  state.company.logoUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Colors.grey,
                                    );
                                  },
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
                      'Tap to upload logo',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Fields
                  buildLabel("Company Name"),
                  buildEditBox(_nameController),

                  buildLabel("Description"),
                  buildEditBox(_descriptionController, maxLines: 3),

                  Row(
                    children: [
                      Expanded(child: buildLabel("Founded")),
                      const SizedBox(width: 12),
                      Expanded(child: buildLabel("Team Size")),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: buildEditBox(_foundedController,
                              keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: buildEditBox(_teamSizeController,
                              keyboardType: TextInputType.number)),
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
                      Expanded(child: buildEditBox(_industryController)),
                      const SizedBox(width: 12),
                      Expanded(child: buildEditBox(_stageController)),
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
                      Expanded(child: buildEditBox(_currencyController)),
                      const SizedBox(width: 12),
                      Expanded(child: buildEditBox(_locationController)),
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
                        if (_tempTeamMembers.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'No team members yet',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          )
                        else
                          ..._tempTeamMembers.asMap().entries.map((entry) {
                            final index = entry.key;
                            final member = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${member['name']} - ${member['role']}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.red, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _tempTeamMembers.removeAt(index);
                                      });
                                    },
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
                    onTap: () {
                      context.read<CompanyBloc>().add(EditCompanyCertificate());
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF91C7E5),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: state.company.certificateUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                state.company.certificateUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
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
                                  );
                                },
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
    );
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
                    _tempTeamMembers.add({
                      'name': nameController.text,
                      'role': roleController.text,
                    });
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

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget buildDisplayBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF91C7E5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildEditBox(TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF91C7E5),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildTopWhiteButton(IconData? icon, VoidCallback onPressed,
      {String? label}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: icon != null
            ? Icon(icon, color: Colors.black)
            : Text(
                label!,
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