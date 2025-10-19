import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_bloc.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_event.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_state.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_profile_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../custom widgets/entrepreneur_profile_field.dart';

class EntrepreneurProfileScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  EntrepreneurProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EpsBloc, EpsState>(
        builder: (context, state) {
          if (state is LoadingProfile) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DisplayInfo) {
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
                            context.read<EpsBloc>().add(EditButtonPressed());
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Image.network(
                        state.entrepreneur.profileImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/elsweedy.jpeg',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      state.entrepreneur.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

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
                    // EntrepreneurProfileField(
                    //   title: "Skills",
                    //   value: state.entrepreneur.skills,
                    // ),
                    EntrepreneurProfileField(
                      title: "Role",
                      value: state.entrepreneur.role,
                    ),

                    SizedBox(height: 20),
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
                        SizedBox(height: 6),
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF91C7E5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Image.network(
                              state.entrepreneur.profileImageUrl,
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
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is EditInfo) {
            _aboutController.text = state.entrepreneur.about;
            _phoneController.text = state.entrepreneur.phoneNumber;
            _experienceController.text = state.entrepreneur.experience;
            _roleController.text = state.entrepreneur.role;
            // _skillsController.text = state.entrepreneur.skills;
            _nameController.text = state.entrepreneur.name;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _topButton(
                          label: "save",
                          onTap: () {
                            context.read<EpsBloc>().add(
                              SaveButtonPressed(
                                name: _nameController.text,
                                about: _aboutController.text,
                                phoneNumber: _phoneController.text,
                                experience: _experienceController.text,
                                skills: [],
                                role: _roleController.text,
                              ),
                            );
                          },
                        ),
                        _topButton(
                          label: "cancel",
                          onTap: () {
                            context.read<EpsBloc>().add(CancelButtonPressed());
                          },
                        ),
                        _topButton(
                          label: "Edit photo1",
                          onTap: () {
                            context.read<EpsBloc>().add(EditProfilePhoto());
                          },
                        ),
                        _topButton(label: "Edit photo2", onTap: () {}),
                      ],
                    ),

                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Image.network(
                        state.entrepreneur.profileImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/elsweedy.jpeg',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10),

                    Center(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    EntrepreneurProfileTextfield(
                      title: "About",
                      controller: _aboutController,
                    ),
                    EntrepreneurProfileTextfield(
                      title: "Phone Number",
                      controller: _phoneController,
                    ),
                    EntrepreneurProfileTextfield(
                      title: "Experience",
                      controller: _experienceController,
                    ),
                    // EntrepreneurProfileField(
                    //   title: "Skills",
                    //   value: state.entrepreneur.skills,
                    // ),
                    EntrepreneurProfileTextfield(
                      title: "Role",
                      controller: _roleController,
                    ),

                    SizedBox(height: 20),
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
                        SizedBox(height: 6),
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF91C7E5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Image.network(
                              state.entrepreneur.profileImageUrl,
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
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return SizedBox.fromSize();
        },
        listener: (context, state) {},
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
                label!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
    ),
  );
}
