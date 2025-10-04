import 'package:depi_graduation_project/screens/investor_home_screen.dart';
import 'package:depi_graduation_project/screens/investor_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class InvestorMainScreen extends StatefulWidget {
  const InvestorMainScreen({super.key});

  @override
  State<InvestorMainScreen> createState() => _InvestorMainScreenState();
}

class _InvestorMainScreenState extends State<InvestorMainScreen> {
  List<Widget> screens = [
    InvestorHomeScreen(),
    InvestorProfileScreen(),
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
          SalomonBottomBarItem(icon: Icon(Icons.account_circle), title: Text('Profile')),
        ],
      ),
    );
    
  }
}
