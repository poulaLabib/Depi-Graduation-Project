import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../custom widgets/investor_profile_textfield.dart';
import '../custom widgets/investor_profile_field.dart';
import '../bloc/investor_profile_screen/ips_bloc.dart';
import '../bloc/investor_profile_screen/ips_event.dart';
import '../bloc/investor_profile_screen/ips_state.dart';

class InvestorProfileScreen extends StatefulWidget {
  const InvestorProfileScreen({super.key});

  @override
  State<InvestorProfileScreen> createState() => _InvestorProfileScreenState();
}

class _InvestorProfileScreenState extends State<InvestorProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _investorTypeController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _investmentCapacityController =
      TextEditingController();
  final TextEditingController _preferredIndustriesController =
      TextEditingController();

  // Keep track of which investor uid is currently loaded to avoid redundant setText on rebuilds
  String? _currentUidForControllers;

  @override
  void dispose() {
    _nameController.dispose();
    _investorTypeController.dispose();
    _aboutController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    _skillsController.dispose();
    _investmentCapacityController.dispose();
    _preferredIndustriesController.dispose();
    super.dispose();
  }

  void _populateControllersIfNeeded(EditInfo state) {
    // prevent reassigning same values repeatedly
    if (_currentUidForControllers == state.investor.uid) return;
    _currentUidForControllers = state.investor.uid;

    _nameController.text = state.investor.name;
    _aboutController.text = state.investor.about;
    _phoneController.text = state.investor.phoneNumber;
    _experienceController.text = state.investor.experience;
    _skillsController.text = state.investor.skills.join(', ');
    _investmentCapacityController.text =
        state.investor.investmentCapacity.toString();
    _preferredIndustriesController.text = state.investor.preferredIndustries
        .join(', ');
    _investorTypeController.text = state.investor.investorType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<IpsBloc, IpsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoadingProfile) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DisplayInfo) {
            final inv = state.investor;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _topButton(
                          label: "Edit",
                          onTap: () {
                            context.read<IpsBloc>().add(EditButtonPressed());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          inv.photoUrl.isNotEmpty
                              ? NetworkImage(inv.photoUrl)
                              : null,
                      child:
                          inv.photoUrl.isEmpty
                              ? ClipOval(
                                child: Image.asset(
                                  'assets/images/elsweedy.jpeg',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : null,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      inv.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ProfileField(title: "About", value: inv.about),
                    ProfileField(title: "Phone Number", value: inv.phoneNumber),
                    ProfileField(title: "Experience", value: inv.experience),
                    ProfileField(title: "Skills", value: inv.skills.join(', ')),
                    ProfileField(
                      title: "Investment Capacity",
                      value: inv.investmentCapacity.toString(),
                    ),
                    ProfileField(
                      title: "Preferred Industries",
                      value: inv.preferredIndustries.join(', '),
                    ),
                    ProfileField(
                      title: "Investor Type",
                      value: inv.investorType,
                    ),

                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Personal ID",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF91C7E5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child:
                                inv.nationalIdUrl.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        inv.nationalIdUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
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
                                    )
                                    : Image.asset(
                                      'assets/images/elsweedy.jpeg',
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (state is EditInfo) {
            _populateControllersIfNeeded(state);

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _topButton(
                          label: "Save",
                          onTap: () {
                            // parse safely
                            final investmentCapacity =
                                int.tryParse(
                                  _investmentCapacityController.text.trim(),
                                ) ??
                                0;

                            final skills =
                                _skillsController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .where((e) => e.isNotEmpty)
                                    .toList();

                            final preferredIndustries =
                                _preferredIndustriesController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .where((e) => e.isNotEmpty)
                                    .toList();

                            context.read<IpsBloc>().add(
                              SaveButtonPressed(
                                name: _nameController.text.trim(),
                                about: _aboutController.text.trim(),
                                phoneNumber: _phoneController.text.trim(),
                                experience: _experienceController.text.trim(),
                                skills: skills,
                                investmentCapacity: investmentCapacity,
                                preferredIndustries: preferredIndustries,
                                investorType:
                                    _investorTypeController.text.trim(),
                              ),
                            );
                          },
                        ),
                        _topButton(
                          label: "Cancel",
                          onTap: () {
                            context.read<IpsBloc>().add(CancelButtonPressed());
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () {
                        context.read<IpsBloc>().add(EditProfilePhoto());
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            state.investor.photoUrl.isNotEmpty
                                ? NetworkImage(state.investor.photoUrl)
                                : null,
                        child:
                            state.investor.photoUrl.isEmpty
                                ? ClipOval(
                                  child: Image.asset(
                                    'assets/images/elsweedy.jpeg',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : null,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    InvestorProfileTextfield(
                      title: "About",
                      controller: _aboutController,
                    ),
                    InvestorProfileTextfield(
                      title: "Phone Number",
                      controller: _phoneController,
                    ),
                    InvestorProfileTextfield(
                      title: "Experience",
                      controller: _experienceController,
                    ),
                    InvestorProfileTextfield(
                      title: "Skills",
                      controller: _skillsController,
                    ),
                    InvestorProfileTextfield(
                      title: "Investment Capacity",
                      controller: _investmentCapacityController,
                    ),
                    InvestorProfileTextfield(
                      title: "Preferred Industries",
                      controller: _preferredIndustriesController,
                    ),
                    InvestorProfileTextfield(
                      title: "Investor Type",
                      controller: _investorTypeController,
                    ),

                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Personal ID",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            context.read<IpsBloc>().add(EditNationalIdPhoto());
                          },
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF91C7E5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child:
                                  state.investor.nationalIdUrl.isNotEmpty
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          state.investor.nationalIdUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
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
                                      )
                                      : Image.asset(
                                        'assets/images/elsweedy.jpeg',
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

Widget _topButton({
  String? label,
  IconData? icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          icon != null
              ? Icon(icon, color: Colors.black)
              : Text(
                label ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
    ),
  );
}
