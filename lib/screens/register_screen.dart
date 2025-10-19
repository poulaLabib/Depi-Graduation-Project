import 'package:depi_graduation_project/bloc/auth/auth_bloc.dart';
import 'package:depi_graduation_project/bloc/auth/auth_event.dart';
import 'package:depi_graduation_project/bloc/auth/auth_state.dart';
import 'package:depi_graduation_project/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  final String userType;
  const SignUp({required this.userType, super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 240, 225, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // full name
                const Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _fullNameController,
                  decoration: _inputDecoration(),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter your name'
                              : null,
                ),
                const SizedBox(height: 8),

                // username/email
                const Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                const Text(
                  "Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(),
                  validator:
                      (value) =>
                          value == null || value.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                ),
                const SizedBox(height: 8),

                // confirm password
                const Text(
                  "Confirm Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: _inputDecoration(),
                  validator:
                      (value) =>
                          value != _passwordController.text
                              ? 'Passwords don’t match'
                              : null,
                ),
                const SizedBox(height: 15),
                BlocConsumer<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is InitialState) {
                      return SizedBox.shrink();
                    } else if (state is AuthLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is AuthSuccessfull) {
                      return Text(
                        'Success',
                        style: TextStyle(color: Colors.green),
                      );
                    } else if (state is AuthError) {
                      return Text(
                        'Something went wrong',
                        style: TextStyle(color: Colors.red),
                      );
                    } else if (state is InitialState) {
                      return SizedBox.shrink();
                    } else if (state is AuthUnsuccessfull) {
                      return Text(
                        'You entered wrong data',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                    return SizedBox.shrink();
                  },
                  listener: (context, state) {},
                ),
                const SizedBox(height: 15),

                // button
                Center(
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          SignUpButtonPressed(
                            fullName: _fullNameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            userType: widget.userType,
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LogIn(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF91C7E5),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(100),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LogIn();
                          },
                        ),
                      );
                    },
                    child: Column(
                      spacing: 1,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          indent: 90,
                          endIndent: 90,
                          height: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // simple helper for consistent styling
  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF91C7E5),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF91C7E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF91C7E5)),
      ),
    );
  }
}
