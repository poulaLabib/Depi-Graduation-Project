import 'package:depi_graduation_project/screens/investor_home_screen.dart';
import 'package:depi_graduation_project/screens/investor_profile_screen.dart';
import 'package:depi_graduation_project/screens/chat_rooms_screen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class InvestorMainScreen extends StatefulWidget {
  final int? initialTab;
  const InvestorMainScreen({super.key, this.initialTab});

  @override
  State<InvestorMainScreen> createState() => _InvestorMainScreenState();
}

class _InvestorMainScreenState extends State<InvestorMainScreen> {
  List<Widget> screens = [
    InvestorHomeScreen(),
    ChatRoomsScreen(),
    InvestorProfileScreen(),
  ];
  late int selectedIndex;
  
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialTab ?? 0;
  }
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
          items: List.generate(3, (index) {
            final icons = [
              Icons.home,
              Icons.chat,
              Icons.account_circle,
            ];
            final labels = ['Home', 'Chats', 'Profile'];

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
