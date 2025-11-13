import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:depi_graduation_project/bloc/auth/auth_bloc.dart';
import 'package:depi_graduation_project/bloc/auth/auth_event.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_profile_field.dart';
import 'package:depi_graduation_project/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '../bloc/investor_profile_screen/ips_bloc.dart';
import '../bloc/investor_profile_screen/ips_event.dart';
import '../bloc/investor_profile_screen/ips_state.dart';
import '../custom widgets/entrepreneur_profile_textfield.dart';
import '../custom widgets/entrepreneur_skills_field .dart';
import '../custom widgets/skill_card.dart';

class InvestorProfileScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _investorTypeController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final GlobalKey skillButtonKey = GlobalKey();

  final GlobalKey industryButtonKey = GlobalKey();

  InvestorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<IpsBloc, IpsState>(
        listener: (context, state) {
          if (state is EditInvestorInfo && state.showSkills) {
            final parentContext = context;
            showDialog(
              context: parentContext,
              barrierDismissible: true,
              barrierColor: Colors.black.withAlpha(220),
              builder: (dialogContext) {
                return AlertDialog(
                  backgroundColor: const Color(0xFF2C3E50).withAlpha(150),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  content: StatefulBuilder(
                    builder: (context, setState) {
                      final editState =
                          parentContext.read<IpsBloc>().state
                              as EditInvestorInfo;
                      final availableSkills = List<String>.from(
                        editState.availableSkills,
                      );

                      return SizedBox(
                        height: 320,
                        width: 240,
                        child: SingleChildScrollView(
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            itemCount: availableSkills.length,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(
                              parent: ClampingScrollPhysics(),
                            ),
                            staggeredTileBuilder:
                                (_) => const StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              final skill = availableSkills[index];
                              return SkillCard(
                                text: skill,
                                state: 'toAdd',
                                onTap: () {
                                  parentContext.read<IpsBloc>().add(
                                    AddTempSkillInvestor(skill: skill),
                                  );
                                  setState(() {
                                    availableSkills.removeAt(index);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          if (state is EditInvestorInfo && state.showIndustries) {
            final parentContext = context;
            showDialog(
              context: parentContext,
              barrierDismissible: true,
              barrierColor: Colors.black.withAlpha(220),
              builder: (dialogContext) {
                return AlertDialog(
                  backgroundColor: const Color(0xFF2C3E50).withAlpha(150),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  content: StatefulBuilder(
                    builder: (context, setState) {
                      final editState =
                          parentContext.read<IpsBloc>().state
                              as EditInvestorInfo;
                      final availableIndustries = List<String>.from(
                        editState.availableIndustries,
                      );

                      return SizedBox(
                        height: 320,
                        width: 240,
                        child: SingleChildScrollView(
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            itemCount: availableIndustries.length,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(
                              parent: ClampingScrollPhysics(),
                            ),
                            staggeredTileBuilder:
                                (_) => const StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              final industry = availableIndustries[index];
                              return SkillCard(
                                text: industry,
                                state: 'toAdd',
                                onTap: () {
                                  parentContext.read<IpsBloc>().add(
                                    AddTempIndustryInvestor(industry: industry),
                                  );
                                  setState(() {
                                    availableIndustries.removeAt(index);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingInvestorProfile) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DisplayInvestorInfo) {
            return _viewMode(context, state);
          } else if (state is EditInvestorInfo) {
            _nameController.text = state.investor.name;
            _aboutController.text = state.investor.about;
            _phoneController.text = state.investor.phoneNumber;
            _experienceController.text = state.investor.experience;
            _investorTypeController.text = state.investor.investorType;
            _capacityController.text =
                state.investor.investmentCapacity.toString();
            return _editMode(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _viewMode(BuildContext context, DisplayInvestorInfo state) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.center,

                children: [
                  Container(width: double.infinity),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Logout',
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutButtonPressed());
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LogIn()),
                        );
                      },
                      icon: Icon(
                        CupertinoIcons.square_arrow_right,
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Edit',
                      onPressed: () {
                        context.read<IpsBloc>().add(
                          EditInvestorButtonPressed(),
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
                            barrierColor: Colors.black.withAlpha(220),
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  contentPadding: EdgeInsets.zero,
                                  content: Center(
                                    child: ClipOval(
                                      child: Image.network(
                                        state.investor.photoUrl,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => Image.asset(
                                              'assets/images/elsweedy.jpeg',
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                          );
                        },
                        child: ClipOval(
                          child: Image.network(
                            state.investor.photoUrl,
                            height: 115,
                            width: 115,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Image.asset(
                                  'assets/images/elsweedy.jpeg',
                                  height: 115,
                                  width: 115,
                                  fit: BoxFit.cover,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: AutoText(
                          maxFontSize: 20,
                          minFontSize: 20,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          state.investor.name,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  spacing: 10,
                  children: [
                    EntrepreneurProfileField(
                      title: 'About',
                      value: state.investor.about,
                    ),
                    EntrepreneurProfileField(
                      title: 'Phone Number',
                      value: state.investor.phoneNumber,
                    ),
                    EntrepreneurSkillsField(
                      title: 'Skills',
                      skills: state.investor.skills,
                      state: 'toView',
                    ),
                    EntrepreneurProfileField(
                      title: 'Investor Type',
                      value: state.investor.investorType,
                    ),
                    EntrepreneurProfileField(
                      title: 'Experience',
                      value: state.investor.experience,
                    ),
                    EntrepreneurProfileField(
                      title: 'Investment Capacity',
                      value: state.investor.investmentCapacity.toString(),
                    ),
                    EntrepreneurSkillsField(
                      title: 'Preferred Industries',
                      skills: state.investor.preferredIndustries,
                      state: 'toView',
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'National ID',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                barrierColor: Colors.black.withAlpha(220),
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      content: Image.network(
                                        state.investor.nationalIdUrl,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (_, __, ___) => Image.asset(
                                              'assets/images/elsweedy.jpeg',
                                              fit: BoxFit.contain,
                                            ),
                                      ),
                                    ),
                              );
                            },
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xFF91C7E5).withAlpha(200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  state.investor.nationalIdUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Image.asset(
                                        'assets/images/elsweedy.jpeg',
                                        fit: BoxFit.cover,
                                      ),
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
    );
  }

  Widget _editMode(BuildContext context, EditInvestorInfo state) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: double.infinity),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        context.read<IpsBloc>().add(
                          SaveInvestorButtonPressed(
                            name: _nameController.text,
                            about: _aboutController.text,
                            phoneNumber: _phoneController.text,
                            experience: _experienceController.text,
                            investorType: _investorTypeController.text,
                            skills:
                                {
                                  ...state.investor.skills,
                                  ...state.tempSkills,
                                }.toList(),
                            preferredIndustries:
                                {
                                  ...state.investor.preferredIndustries,
                                  ...state.tempIndustries,
                                }.toList(),
                            investmentCapacity:
                                int.tryParse(_capacityController.text) ??
                                state.investor.investmentCapacity,
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
                      onTap:
                          () => context.read<IpsBloc>().add(
                            CancelInvestorButtonPressed(),
                          ),
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
                    spacing: 10,
                    children: [
                      Stack(
                        children: [
                          ClipOval(
                            child: Image.network(
                              state.investor.photoUrl,
                              height: 115,
                              width: 115,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Image.asset(
                                    'assets/images/elsweedy.jpeg',
                                    height: 115,
                                    width: 115,
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                          Positioned.fill(
                            child: GestureDetector(
                              onTap:
                                  () => context.read<IpsBloc>().add(
                                    EditInvestorPhoto(type: 'profile'),
                                  ),
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
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  spacing: 10,
                  children: [
                    EntrepreneurProfileTextfield(
                      title: 'About',
                      controller: _aboutController,
                    ),
                    EntrepreneurProfileTextfield(
                      title: 'Phone Number',
                      controller: _phoneController,
                    ),
                    Stack(
                      children: [
                        EntrepreneurSkillsField(
                          title: 'Skills',
                          skills: [
                            ...state.investor.skills,
                            ...state.tempSkills,
                          ],
                          state: 'toRemove',
                          onRemove: (skill) {
                            context.read<IpsBloc>().add(
                              RemoveTempSkillInvestor(skill: skill),
                            );
                          },
                        ),
                        Positioned(
                          top: 23.5,
                          bottom: 2,
                          right: 2,
                          child: InkWell(
                            key: skillButtonKey,
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              context.read<IpsBloc>().add(
                                AddTempSkillButtonPressed(),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  245,
                                  245,
                                  245,
                                ).withAlpha(80),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF2C3E50).withAlpha(50),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    EntrepreneurProfileTextfield(
                      title: 'Investor Type',
                      controller: _investorTypeController,
                    ),
                    EntrepreneurProfileTextfield(
                      title: 'Experience',
                      controller: _experienceController,
                    ),
                    EntrepreneurProfileTextfield(
                      title: 'Investment Capacity',
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                    ),

                    // Industries field
                    Stack(
                      children: [
                        EntrepreneurSkillsField(
                          title: 'Preferred Industries',
                          skills: [
                            ...state.investor.preferredIndustries,
                            ...state.tempIndustries,
                          ],
                          state: 'toRemove',
                          onRemove: (industry) {
                            context.read<IpsBloc>().add(
                              RemoveTempIndustryInvestor(industry: industry),
                            );
                          },
                        ),
                        Positioned(
                          top: 23.5,
                          bottom: 2,
                          right: 2,
                          child: InkWell(
                            key: industryButtonKey,
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              context.read<IpsBloc>().add(
                                AddTempIndustryButtonPressed(),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  245,
                                  245,
                                  245,
                                ).withAlpha(80),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF2C3E50).withAlpha(50),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'National ID',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                              letterSpacing: -0.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              color: const Color(0xFF91C7E5).withAlpha(200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      state.investor.nationalIdUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => Image.asset(
                                            'assets/images/elsweedy.jpeg',
                                            fit: BoxFit.cover,
                                          ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<IpsBloc>().add(
                                        EditInvestorPhoto(type: 'id'),
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
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
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
          ],
        ),
      ),
    );
  }
}
