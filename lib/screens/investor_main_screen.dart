import 'package:depi_graduation_project/screens/investor_home_screen.dart';
import 'package:depi_graduation_project/screens/investor_profile_screen.dart';
import 'package:depi_graduation_project/screens/chat_rooms_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class InvestorMainScreen extends StatefulWidget {
  final int? initialTab;
  final VoidCallback? toggleTheme;
  const InvestorMainScreen({super.key, this.initialTab, this.toggleTheme});

  @override
  State<InvestorMainScreen> createState() => _InvestorMainScreenState();
}

class _InvestorMainScreenState extends State<InvestorMainScreen> {
  late List<Widget> screens;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    screens = [
      InvestorHomeScreen(toggleTheme: widget.toggleTheme),
      ChatRoomsScreen(),
      InvestorProfileScreen(),
    ];
    selectedIndex = widget.initialTab ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: Container(
        height: 68,
        padding: EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: theme.colorScheme.primary, width: 0.2),
          ),
        ),
        child: SalomonBottomBar(
          selectedColorOpacity: 0.05,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.secondary.withAlpha(120),
          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
          itemPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          items: List.generate(3, (index) {
            final icons = [
              CupertinoIcons.home,
              Icons.chat_outlined,
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
                    color:
                        isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondary.withAlpha(120),
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
                              : theme.colorScheme.secondary.withAlpha(120),
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
