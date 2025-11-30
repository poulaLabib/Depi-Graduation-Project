import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/company_bloc.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/cps_event.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/cps_state.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_profile_field.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_profile_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
      _tempTeamMembers = List<Map<String, dynamic>>.from(
        state.company.teamMembers,
      );
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          if (state is LoadingCompanyProfile) {
            return const Center(child: CircularProgressIndicator());
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
          return const Center(child: Text("Something went wrong!"));
        },
      ),
    );
  }

  Widget _buildDisplayMode(BuildContext context, DisplayCompanyInfo state) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      padding: EdgeInsets.all(4),
                      tooltip: 'Edit',
                      onPressed: () {
                        context.read<CompanyBloc>().add(
                          EditCompanyButtonPressed(),
                        );
                      },
                      icon: Icon(
                        CupertinoIcons.square_pencil,
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  Column(
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            barrierDismissible: true,
                            barrierColor: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(220),
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  contentPadding: EdgeInsets.zero,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: ClipOval(
                                          child: Image.network(
                                            state.company.logoUrl,
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 200,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                width: 200,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                      .withAlpha(20),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  size: 60,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withAlpha(128),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          );
                        },
                        child: ClipOval(
                          child:
                              state.company.logoUrl.isNotEmpty
                                  ? Image.network(
                                    state.company.logoUrl,
                                    height: 115,
                                    width: 115,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 115,
                                        width: 115,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary.withAlpha(20),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(128),
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    height: 115,
                                    width: 115,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary.withAlpha(20),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withAlpha(128),
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: AutoText(
                          state.company.name.isEmpty
                              ? "Company Name"
                              : state.company.name,
                          maxFontSize: 20,
                          minFontSize: 20,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            letterSpacing: -0.2,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Company Information
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245).withAlpha(0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Column(
                    spacing: 20,
                    children: [
                      EntrepreneurProfileField(
                        title: "Description",
                        value:
                            state.company.description.isEmpty
                                ? "No description"
                                : state.company.description,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: EntrepreneurProfileField(
                              title: "Founded",
                              value:
                                  state.company.founded == 0
                                      ? "Not set"
                                      : state.company.founded.toString(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: EntrepreneurProfileField(
                              title: "Team Size",
                              value:
                                  state.company.teamSize == 0
                                      ? "Not set"
                                      : state.company.teamSize.toString(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: EntrepreneurProfileField(
                              title: "Industry",
                              value:
                                  state.company.industry.isEmpty
                                      ? "Not set"
                                      : state.company.industry,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: EntrepreneurProfileField(
                              title: "Stage",
                              value:
                                  state.company.stage.isEmpty
                                      ? "Not set"
                                      : state.company.stage,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: EntrepreneurProfileField(
                              title: "Currency",
                              value:
                                  state.company.currency.isEmpty
                                      ? "Not set"
                                      : state.company.currency,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: EntrepreneurProfileField(
                              title: "Location",
                              value:
                                  state.company.location.isEmpty
                                      ? "Not set"
                                      : state.company.location,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        thickness: 0.6,
                      ),
                      // Team Members
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Team Members",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 15,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondary.withAlpha(20),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 0.2,
                                ),
                              ),
                              child:
                                  state.company.teamMembers.isEmpty
                                      ? Text(
                                        "No team members added",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                      )
                                      : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            state.company.teamMembers.map((
                                              member,
                                            ) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 6,
                                                      height: 6,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onSurface,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        "${member['name'] ?? 'Unknown'} - ${member['role'] ?? 'Unknown'}",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                      ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        thickness: 0.6,
                      ),
                      // Verified Certificate
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Verified Certificate (optional)",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  state.company.certificateUrl.isNotEmpty
                                      ? () {
                                        showDialog(
                                          barrierColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(220),
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: Image.network(
                                                  state.company.certificateUrl,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return _buildCertificatePlaceholder(
                                                      context,
                                                    );
                                                  },
                                                ),
                                              ),
                                        );
                                      }
                                      : null,
                              child: Container(
                                height: 170,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary.withAlpha(20),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child:
                                    state.company.certificateUrl.isNotEmpty
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            state.company.certificateUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return _buildCertificatePlaceholder(
                                                context,
                                              );
                                            },
                                          ),
                                        )
                                        : _buildCertificatePlaceholder(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditMode(BuildContext context, EditCompanyInfo state) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      padding: EdgeInsets.all(4),
                      tooltip: 'Save',
                      onPressed: () {
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
                            teamMembers: List<Map<String, dynamic>>.from(
                              _tempTeamMembers,
                            ),
                          ),
                        );
                        _clearControllers();
                      },
                      icon: Icon(
                        CupertinoIcons.check_mark,
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      padding: EdgeInsets.all(4),
                      tooltip: 'Cancel',
                      onPressed: () {
                        _clearControllers();
                        context.read<CompanyBloc>().add(
                          CancelCompanyButtonPressed(),
                        );
                      },
                      icon: Icon(
                        CupertinoIcons.xmark,
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  Column(
                    spacing: 10,
                    children: [
                      Stack(
                        children: [
                          ClipOval(
                            child:
                                state.company.logoUrl.isNotEmpty
                                    ? Image.network(
                                      state.company.logoUrl,
                                      height: 115,
                                      width: 115,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          height: 115,
                                          width: 115,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withAlpha(20),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 40,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withAlpha(128),
                                          ),
                                        );
                                      },
                                    )
                                    : Container(
                                      height: 115,
                                      width: 115,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary.withAlpha(20),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withAlpha(128),
                                      ),
                                    ),
                          ),
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                context.read<CompanyBloc>().add(
                                  EditCompanyLogo(),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(80),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  CupertinoIcons.cloud_upload_fill,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Company Name",
                            hintStyle: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(102),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: GoogleFonts.roboto(
                            letterSpacing: -0.2,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          cursorColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Fields
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245).withAlpha(0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Column(
                    spacing: 20,
                    children: [
                      EntrepreneurProfileTextfield(
                        title: "Description",
                        controller: _descriptionController,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: EntrepreneurProfileTextfield(
                              title: "Founded",
                              controller: _foundedController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: EntrepreneurProfileTextfield(
                              title: "Team Size",
                              controller: _teamSizeController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: EntrepreneurProfileTextfield(
                              title: "Industry",
                              controller: _industryController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: EntrepreneurProfileTextfield(
                              title: "Stage",
                              controller: _stageController,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: EntrepreneurProfileTextfield(
                              title: "Currency",
                              controller: _currencyController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: EntrepreneurProfileTextfield(
                              title: "Location",
                              controller: _locationController,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        thickness: 0.6,
                      ),
                      // Team Members
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Team Members",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 15,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondary.withAlpha(20),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 0.2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  if (_tempTeamMembers.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        'No team members yet',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(128),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  else
                                    ..._tempTeamMembers.asMap().entries.map((
                                      entry,
                                    ) {
                                      final index = entry.key;
                                      final member = entry.value;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                "${member['name']} - ${member['role']}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.remove_circle,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.error,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _tempTeamMembers.removeAt(
                                                    index,
                                                  );
                                                });
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: _addTeamMember,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).cardColor.withAlpha(179),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface.withAlpha(77),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 18,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Add Team Member',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        thickness: 0.6,
                      ),
                      // Certificate
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Verified Certificate (optional)",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  state.company.certificateUrl.isNotEmpty
                                      ? () {
                                        showDialog(
                                          barrierColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(220),
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: Image.network(
                                                  state.company.certificateUrl,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return _buildCertificatePlaceholder(
                                                      context,
                                                    );
                                                  },
                                                ),
                                              ),
                                        );
                                      }
                                      : null,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary.withAlpha(20),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:
                                        state.company.certificateUrl.isNotEmpty
                                            ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                state.company.certificateUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return _buildCertificatePlaceholder(
                                                    context,
                                                  );
                                                },
                                              ),
                                            )
                                            : _buildCertificatePlaceholder(
                                              context,
                                            ),
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withAlpha(80),
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        onTap: () {
                                          context.read<CompanyBloc>().add(
                                            EditCompanyCertificate(),
                                          );
                                        },
                                        child: Icon(
                                          CupertinoIcons.cloud_upload_fill,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTeamMember() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final roleController = TextEditingController();

        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Add Team Member',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: roleController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Role',
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
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
              child: Text(
                'Add',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCertificatePlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_photography,
            size: 42,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 6),
          Text(
            'No certificate uploaded',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
