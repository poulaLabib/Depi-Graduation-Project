import 'package:depi_graduation_project/bloc/auth/auth_bloc.dart';
import 'package:depi_graduation_project/bloc/auth/auth_event.dart';
import 'package:depi_graduation_project/custom%20widgets/request_tile_investor_view.dart';
import 'package:depi_graduation_project/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvestorHomeScreen extends StatelessWidget {
  
  const InvestorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actionsPadding: EdgeInsets.only(right: 10),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.primary,
              size: 27,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: RequestTileInvestorView(),
          ),

          InkWell(
            onTap: () {
              context.read<AuthBloc>().add(LogoutButtonPressed());
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => WelcomePage(),));
            },
            child: Container(
              width: 100,
              height: 100,
              color:  Colors.white,
            ),
          )
        ],
      ),
    );
  }
}