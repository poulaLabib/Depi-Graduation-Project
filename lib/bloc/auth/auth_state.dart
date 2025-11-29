import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {
  final User? user;
  final String? message;

  const AuthState({this.user, this.message});
}

class InitialState extends AuthState {
  const InitialState() : super();
}

class AuthSuccessfull extends AuthState {
  const AuthSuccessfull({super.user});
}

class AuthLoading extends AuthState {
  const AuthLoading() : super();
}

class AuthError extends AuthState {
  const AuthError({super.message});
}

class AuthUnsuccessfull extends AuthState {
  const AuthUnsuccessfull() : super();
}

class LoggedOut extends AuthState {
  const LoggedOut() : super();
}
