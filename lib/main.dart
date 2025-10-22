import 'package:depi_graduation_project/bloc/auth/auth_bloc.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_bloc.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/company_bloc.dart';
import 'package:depi_graduation_project/bloc/investor_profile_screen/ips_bloc.dart';
import 'package:depi_graduation_project/fikraty.dart';
import 'package:depi_graduation_project/firebase_options.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://tqoyfzbnysoxqqjywbkc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxb3lmemJueXNveHFxanl3YmtjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzMzAyODEsImV4cCI6MjA3NDkwNjI4MX0.xtEnp2TGYmy4HyXhkMZWNdy1uV8BZCbWVoHCMJ0t68k',
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (BuildContext context) => AuthBloc(
                auth: AuthenticationService(),
                investor: InvestorFirestoreService(),
                entrepreneur: EntrepreneurFirestoreService(),
              ),
        ),
        BlocProvider(
          create:
              (BuildContext context) => EpsBloc(
                auth: AuthenticationService(),
                entrepreneur: EntrepreneurFirestoreService(),
              ),
        ),
        BlocProvider(
          create:
              (BuildContext context) => CompanyBloc(
                auth: AuthenticationService(),
                company: CompanyFirestoreService(),
              ),
        ),
        BlocProvider(
          create:
              (BuildContext context) => IpsBloc(
                auth: AuthenticationService(),
                investor: InvestorFirestoreService(),
              ),
        ),
      ],
      child: Fikraty(),
    ),
  );
}
