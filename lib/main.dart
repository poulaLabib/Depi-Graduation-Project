import 'package:depi_graduation_project/bloc/Investor%20section/investor_section_bloc.dart';
import 'package:depi_graduation_project/bloc/Request%20section/requests_section_bloc.dart';
import 'package:depi_graduation_project/bloc/auth/auth_bloc.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_bloc.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_bloc.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_bloc.dart';
import 'package:depi_graduation_project/bloc/investor%20request/investor_requests_bloc.dart';
import 'package:depi_graduation_project/bloc/investor_profile_screen/ips_bloc.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_bloc.dart';
import 'package:depi_graduation_project/bloc/request_screen/request_screen_bloc.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/company_bloc.dart';
import 'package:depi_graduation_project/fikraty.dart';
import 'package:depi_graduation_project/firebase_options.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
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
              (BuildContext context) => NotificationsBloc(
                auth: AuthenticationService(),
                notificationService: NotificationFirestoreService(),
              ),
        ),
        BlocProvider(create: (BuildContext context) => EhsBloc()),

        BlocProvider(
          create:
              (BuildContext context) => RequestScreenBloc(
                auth: AuthenticationService(),
                request: RequestFirestoreService(),
              ),
        ),
        BlocProvider(
          create:
              (BuildContext context) => RequestsSectionBloc(
                auth: AuthenticationService(),
                request: RequestFirestoreService(),
              ),
        ),
        BlocProvider(
          create:
              (BuildContext context) => InvestorSectionBloc(
                investorService: InvestorFirestoreService(),
              ),
        ),
        BlocProvider(
          create:
              (BuildContext context) => IpsBloc(
                auth: AuthenticationService(),
                investorService: InvestorFirestoreService(),
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
              (BuildContext context) => ChatListBloc(
                chatRoomService: ChatRoomFirestoreService(),
                auth: AuthenticationService(),
              ),
        ),
        BlocProvider(
          create:
              (BuildContext context) => InvestorRequestsBloc(
                requestService: RequestFirestoreService(),
              ),
        ),
        BlocProvider(
          create:
              (BuildContext context) => InvestorSectionBloc(
                investorService: InvestorFirestoreService(),
              ),
        ),
      ],
      child: Fikraty(),
    ),
  );
}