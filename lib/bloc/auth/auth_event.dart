abstract class AuthEvent {}

class SignUpButtonPressed extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String userType;
  SignUpButtonPressed({
    required this.fullName,
    required this.email,
    required this.password,
    required this.userType,
  });
}

class SignInButtonPressed extends AuthEvent {
  final String email;
  final String password;
  SignInButtonPressed({required this.email, required this.password});
}

class LogoutButtonPressed extends AuthEvent {
  
}