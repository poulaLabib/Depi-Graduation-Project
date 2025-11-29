import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/bloc/auth/auth_event.dart';
import 'package:depi_graduation_project/bloc/auth/auth_state.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationService auth;
  final InvestorFirestoreService investor;
  final EntrepreneurFirestoreService entrepreneur;
  AuthBloc({
    required this.auth,
    required this.investor,
    required this.entrepreneur,
  }) : super(InitialState()) {
    on<SignUpButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        final User? user = await auth.register(
          email: event.email,
          password: event.password,
        );
        if (user == null) {
          emit(AuthUnsuccessfull());
        } else {
          if (event.userType == 'entrepreneur') {
            await entrepreneur.addEntrepreneur(
              uid: auth.currentUser!.uid,
              name: event.fullName,
            );
          } else if (event.userType == 'investor') {
            await investor.addInvestor(
              uid: auth.currentUser!.uid,
              name: event.fullName,
            );
          }
          emit(AuthSuccessfull());
        }
      } catch (e) {
        emit(AuthError());
      }
    });

    on<SignInButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        final User? user = await auth.login(
          email: event.email,
          password: event.password,
        );
        if (user == null) {
          emit(AuthUnsuccessfull());
        } else {
          emit(AuthSuccessfull(user: user));
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LogoutButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        await auth.logout();
        emit(const LoggedOut());
      } catch (e) {
        emit(AuthError());
      }
    });
  }
}
