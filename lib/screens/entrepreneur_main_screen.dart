import 'package:depi_graduation_project/screens/chat_rooms_screen.dart';
import 'package:depi_graduation_project/screens/entrepreneur_company_profile_screen.dart';
import 'package:depi_graduation_project/screens/entrepreneur_home_screen.dart';
import 'package:depi_graduation_project/screens/entrepreneur_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class EntrepreneurMainScreen extends StatefulWidget {
  final VoidCallback? toggleTheme;
  const EntrepreneurMainScreen({super.key, this.toggleTheme});

  @override
  State<EntrepreneurMainScreen> createState() => _EntrepreneurMainScreenState();
}

class _EntrepreneurMainScreenState extends State<EntrepreneurMainScreen> {
  late List<Widget> screens;
  
  @override
  void initState() {
    super.initState();
    screens = [
      EntrepreneurHomeScreen(toggleTheme: widget.toggleTheme),
      ChatRoomsScreen(),
      EntrepreneurCompanyProfileScreen(),
      EntrepreneurProfileScreen(),
    ];
  }
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: Container(
        height: 68,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: theme.colorScheme.primary, width: 0.2),
          ),
        ),
        child: SalomonBottomBar(
          selectedColorOpacity: 0.1,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.secondary.withAlpha(120),
          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
          itemPadding: EdgeInsets.symmetric(horizontal: 23, vertical: 5),
          items: List.generate(4, (index) {
            final icons = [
              CupertinoIcons.home,
              Icons.chat_outlined,
              Icons.business,
              Icons.account_circle,
            ];
            final labels = ['Home', 'Chats', 'Company', 'Profile'];

            final isSelected = selectedIndex == index;

            return SalomonBottomBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[index],
                    size: 23,
                    color:
                        isSelected
                            ? theme.colorScheme.primary
                            : (theme.colorScheme.secondary.withAlpha(120)),
                  ),
                  SizedBox(height: 2),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected
                              ? theme.colorScheme.primary
                              : ( theme.colorScheme.secondary.withAlpha(120)),
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
