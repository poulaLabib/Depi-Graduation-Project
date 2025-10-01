import 'package:depi_graduation_project/screens/entrepreneur_company_profile_screen.dart';
import 'package:depi_graduation_project/screens/entrepreneur_home_screen.dart';
import 'package:depi_graduation_project/screens/entrepreneur_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class EntrepreneurMainScreen extends StatefulWidget {
  const EntrepreneurMainScreen({super.key});

  @override
  State<EntrepreneurMainScreen> createState() => _EntrepreneurMainScreenState();
}

class _EntrepreneurMainScreenState extends State<EntrepreneurMainScreen> {
  List<Widget> screens = [
    EntrepreneurHomeScreen(),
    EntrepreneurCompanyProfileScreen(),
    EntrepreneurProfileScreen(),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: SalomonBottomBar(
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: [
          SalomonBottomBarItem(icon: Icon(Icons.home), title: Text('Home')),
          SalomonBottomBarItem(icon: Icon(Icons.business), title: Text('Company')),
          SalomonBottomBarItem(icon: Icon(Icons.account_circle), title: Text('Profile')),
        ],
      ),
    );
    
  }
}
