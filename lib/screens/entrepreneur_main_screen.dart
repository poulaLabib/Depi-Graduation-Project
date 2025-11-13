import 'package:depi_graduation_project/screens/chat_rooms_screen.dart';
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
        ChatRoomsScreen(),
    EntrepreneurProfileScreen(),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: Container(
        height: 63,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFF2C3E50).withAlpha(30),
              width: 0.5,
            ),
          ),
        ),
        child: SalomonBottomBar(
          selectedColorOpacity: 0.05,
          selectedItemColor: Color(0xFF2C3E50),
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
          backgroundColor: Theme.of(context).colorScheme.surface,
          itemPadding: EdgeInsets.symmetric(horizontal: 23, vertical: 5),
          items: List.generate(4, (index) {
            final icons = [
              Icons.home,
              Icons.business,
              Icons.chat,
              Icons.account_circle,
            ];
            final labels = ['Home', 'Company', 'Chats','Profile'];

            final isSelected = selectedIndex == index;

            return SalomonBottomBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[index],
                    size: 22,
                    color: isSelected ? Color(0xFF2C3E50) : Colors.grey,
                  ),
                  SizedBox(height: 2),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Color(0xFF2C3E50) : Colors.grey,
                    ),
                  ),
                ],
              ),
              title: SizedBox.shrink(),
            );
          }),
        ),
      ),
    );
  }
}
