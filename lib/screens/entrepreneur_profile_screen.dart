import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:depi_graduation_project/bloc/auth/auth_bloc.dart';
import 'package:depi_graduation_project/bloc/auth/auth_event.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_bloc.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_event.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_state.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_profile_textfield.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_skills_field%20.dart';
import 'package:depi_graduation_project/custom%20widgets/skill_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '../custom widgets/entrepreneur_profile_field.dart';
import '../constants/image_constants.dart';

class EntrepreneurProfileScreen extends StatelessWidget {
  final String? entrepreneurId;
  final bool isViewOnly;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final GlobalKey skillButtonKey = GlobalKey();

  Widget _buildDefaultAvatar(double size) {
    return Image.asset(
      ImageConstants.defaultProfilePhoto,
      height: size,
      width: size,
      fit: BoxFit.cover,
    );
  }

  EntrepreneurProfileScreen({
    super.key,
    this.entrepreneurId,
    this.isViewOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the bloc with the entrepreneur ID if in view-only mode
    if (entrepreneurId != null && isViewOnly) {
      // This will trigger the load of the entrepreneur's profile
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<EpsBloc>().add(LoadEntrepreneurProfile(entrepreneurId!));
      });
    }

    return BlocConsumer<EpsBloc, EpsState>(
      builder: (context, state) {
        if (state is LoadingProfile) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is DisplayInfo) {
          final isViewOnlyMode = state.isViewOnly;

          return Scaffold(
            appBar: isViewOnlyMode
                ? AppBar(
                    title: const Text('Entrepreneur Profile'),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  )
                : null,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (!isViewOnlyMode) ...[
                            Container(
                              width: double.infinity,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                padding: const EdgeInsets.all(4),
                                tooltip: 'Edit',
                                onPressed: () {
                                  context.read<EpsBloc>().add(
                                    EditButtonPressed(),
                                  );
                                },
                                icon: Icon(
                                  CupertinoIcons.square_pencil,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 22,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: IconButton(
                                padding: const EdgeInsets.all(4),
                                tooltip: 'Logout',
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    LogoutButtonPressed(),
                                  );
                                },
                                icon: Icon(
                                  CupertinoIcons.square_arrow_right,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      contentPadding: EdgeInsets.zero,
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: ClipOval(
                                              child: Image.network(
                                                state.entrepreneur.profileImageUrl,
                                                fit: BoxFit.cover,
                                                width: 200,
                                                height: 200,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Image.asset(
                                                    ImageConstants.defaultProfilePhoto,
                                                    fit: BoxFit.cover,
                                                    width: 200,
                                                    height: 200,
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
                                  child: state.entrepreneur.profileImageUrl != null && state.entrepreneur.profileImageUrl!.isNotEmpty
                                    ? Image.network(
                                        state.entrepreneur.profileImageUrl!,
                                        height: 115,
                                        width: 115,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return SizedBox(
                                            height: 115,
                                            width: 115,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(115),
                                      )
                                    : _buildDefaultAvatar(115),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 150,
                                child: AutoText(
                                  state.entrepreneur.name,
                                  maxFontSize: 20,
                                  minFontSize: 16,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    letterSpacing: -0.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5).withAlpha(0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              EntrepreneurProfileField(
                                title: "About",
                                value: state.entrepreneur.about,
                              ),
                              EntrepreneurProfileField(
                                title: "Phone Number",
                                value: state.entrepreneur.phoneNumber,
                              ),
                              EntrepreneurProfileField(
                                title: "Experience",
                                value: state.entrepreneur.experience,
                              ),
                              EntrepreneurProfileField(
                                title: "Role",
                                value: state.entrepreneur.role,
                              ),
                             
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Skills",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Theme.of(context).colorScheme.onSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: state.entrepreneur.skills.map((skill) {
                                        return Chip(
                                          label: Text(skill),
                                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                          labelStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                             
                            ],
                          ),
                          if (state.entrepreneur.idImageUrl != null && state.entrepreneur.idImageUrl!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ID Document",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          contentPadding: EdgeInsets.zero,
                                          content: Image.network(
                                            state.entrepreneur.idImageUrl!,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/images/elsweedy.jpeg',
                                                fit: BoxFit.contain,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 170,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF91C7E5).withAlpha(200),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          state.entrepreneur.idImageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/elsweedy.jpeg',
                                              fit: BoxFit.cover,
                                            );
                                          },
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
              ),
            ),
          );
        } else if (state is EditInfo) {
          _aboutController.text = state.entrepreneur.about;
          _phoneController.text = state.entrepreneur.phoneNumber;
          _experienceController.text = state.entrepreneur.experience;
          _roleController.text = state.entrepreneur.role;
          _nameController.text = state.entrepreneur.name;
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                context.read<EpsBloc>().add(
                                  SaveButtonPressed(
                                    name: _nameController.text,
                                    about: _aboutController.text,
                                    phoneNumber: _phoneController.text,
                                    experience: _experienceController.text,
                                    skills: [
                                      ...state.entrepreneur.skills,
                                      ...state.tempSkills,
                                    ],
                                    role: _roleController.text,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: const Color(0xFF2C3E50).withAlpha(50),
                                    width: 0.5,
                                  ),
                                ),
                                child: const Icon(
                                  CupertinoIcons.check_mark,
                                  color: Color.fromARGB(255, 56, 130, 58),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                context.read<EpsBloc>().add(
                                  CancelButtonPressed(),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: const Color(0xFF2C3E50).withAlpha(50),
                                    width: 0.5,
                                  ),
                                ),
                                child: const Icon(
                                  CupertinoIcons.xmark,
                                  color: Color.fromARGB(255, 173, 47, 38),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Stack(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      state.entrepreneur.profileImageUrl,
                                      height: 115,
                                      width: 115,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.asset(
                                          ImageConstants.defaultProfilePhoto,
                                          height: 115,
                                          width: 115,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () {
                                        context.read<EpsBloc>().add(
                                          EditPhoto(type: 'profile'),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withAlpha(80),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          CupertinoIcons.cloud_upload_fill,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 150,
                                child: TextField(
                                  controller: _nameController,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                  style: GoogleFonts.roboto(
                                    letterSpacing: -0.2,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              EntrepreneurProfileTextfield(
                                title: "About",
                                controller: _aboutController,
                              ),
                              const SizedBox(height: 20),
                              EntrepreneurProfileTextfield(
                                title: "Phone Number",
                                controller: _phoneController,
                              ),
                              const SizedBox(height: 20),
                              EntrepreneurProfileTextfield(
                                title: "Experience",
                                controller: _experienceController,
                              ),
                              const SizedBox(height: 20),
                              EntrepreneurProfileTextfield(
                                title: "Role",
                                controller: _roleController,
                              ),
                              const SizedBox(height: 20),
                              Stack(
                                children: [
                                  EntrepreneurSkillsField(
                                    title: "Skills",
                                    skills: [
                                      ...state.entrepreneur.skills,
                                      ...state.tempSkills,
                                    ],
                                    state: 'toRemove',
                                    onRemove: (skill) {
                                      context.read<EpsBloc>().add(
                                        RemoveTempSkill(skill: skill),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    top: 23.5,
                                    bottom: 2,
                                    right: 25,
                                    child: Builder(
                                      builder: (context) {
                                        return InkWell(
                                          key: skillButtonKey,
                                          borderRadius: BorderRadius.circular(8),
                                          onTap: () {
                                            context.read<EpsBloc>().add(
                                              AddSkillButtonPressed(),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withAlpha(150),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    "Personal ID",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF91C7E5).withAlpha(200),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            state.entrepreneur.idImageUrl,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Image.asset(
                                                'assets/images/elsweedy.jpeg',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: GestureDetector(
                                            onTap: () {
                                              context.read<EpsBloc>().add(
                                                EditPhoto(type: 'id'),
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withAlpha(80),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                CupertinoIcons.cloud_upload_fill,
                                                color: Theme.of(context).colorScheme.primary,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
      listener: (context, state) {
        if (state is EditInfo && state.showSkills) {
          final buttonContext = skillButtonKey.currentContext;
          final parentContext = context;

          if (buttonContext != null) {
            showDialog(
              context: parentContext,
              barrierDismissible: true,
              barrierColor: Theme.of(context).colorScheme.onSurface.withAlpha(220),
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  content: StatefulBuilder(
                    builder: (context, setState) {
                      final editState =
                          parentContext.read<EpsBloc>().state as EditInfo;
                      final availableSkills = List<String>.from(
                        editState.availableSkills,
                      );

                      return SizedBox(
                        height: 320,
                        width: 240,
                        child: SingleChildScrollView(
                          child: StaggeredGridView.countBuilder(
                            physics: const BouncingScrollPhysics(
                              parent: ClampingScrollPhysics(),
                            ),
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            itemCount: availableSkills.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final skill = availableSkills[index];
                              return SkillCard(
                                text: skill,
                                state: 'toAdd',
                                onTap: () {
                                  parentContext.read<EpsBloc>().add(
                                    AddTempSkill(skill: skill),
                                  );
                                  setState(() {
                                    availableSkills.removeAt(index);
                                  });
                                },
                              );
                            },
                            staggeredTileBuilder: (_) => const StaggeredTile.fit(1),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}