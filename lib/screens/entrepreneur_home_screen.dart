import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_bloc.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_event.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_state.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_bloc.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_state.dart';
import 'package:depi_graduation_project/custom widgets/your_requests_section.dart';
import 'package:depi_graduation_project/custom widgets/investors_section.dart';
import 'package:depi_graduation_project/screens/notifications_screen.dart';
import 'package:depi_graduation_project/screens/about_app_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntrepreneurHomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final VoidCallback? toggleTheme;
  EntrepreneurHomeScreen({super.key, this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EhsBloc, EhsState>(
      builder: (context, state) {
        if (state is LoadingHome) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DisplayHome) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _pageController.jumpToPage(state.displayedSectionIndex);
          });

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            drawer: _buildDrawer(context),
            body: Column(
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    spacing: 8,
                    children: [
                      Builder(
                        builder:
                            (context) => GestureDetector(
                              onTap: () => Scaffold.of(context).openDrawer(),
                              child: Icon(
                                Icons.menu,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 27,
                              ),
                            ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            context.read<EhsBloc>().add(ShowInvestors());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  state.displayedSectionIndex == 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color:
                                    state.displayedSectionIndex == 0
                                        ? Colors.transparent
                                        : Theme.of(
                                          context,
                                        ).colorScheme.primary.withAlpha(100),
                                width: 0.3,
                              ),
                            ),
                            child: Text(
                              'Investors',
                              style: TextStyle(
                                color:
                                    state.displayedSectionIndex == 0
                                        ? Theme.of(
                                          context,
                                        ).colorScheme.onPrimary
                                        : Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            context.read<EhsBloc>().add(ShowRequests());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  state.displayedSectionIndex == 1
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                              border: Border.all(
                                color:
                                    state.displayedSectionIndex == 1
                                        ? Colors.transparent
                                        : Theme.of(
                                          context,
                                        ).colorScheme.primary.withAlpha(100),
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              'My requests',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    state.displayedSectionIndex == 1
                                        ? Theme.of(
                                          context,
                                        ).colorScheme.onPrimary
                                        : Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const NotificationsScreen(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.notifications_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 27,
                            ),
                          ),
                          BlocBuilder<NotificationsBloc, NotificationsState>(
                            builder: (context, nState) {
                              if (nState is DisplayNotifications &&
                                  nState.unreadCount > 0) {
                                return Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      nState.unreadCount > 99
                                          ? '99+'
                                          : '${nState.unreadCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: toggleTheme,
                        child: Icon(
                          CupertinoIcons.moon,
                          color: Theme.of(context).colorScheme.onSurface,

                          size: 27,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [InvestorsSection(), YourRequestsSection()],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
      listener: (context, state) {},
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withAlpha(20),
                  theme.colorScheme.secondary.withAlpha(10),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(50),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withAlpha(200),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(30),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    size: 40,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Fikraty',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(50),
                    ),
                  ),
                  child: Text(
                    'Entrepreneur Platform',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildDrawerItem(
                  context,
                  Icons.info_outline,
                  'About the App',
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutAppScreen(),
                      ),
                    );
                  },
                  theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withAlpha(100),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
