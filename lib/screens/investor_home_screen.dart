import 'package:depi_graduation_project/bloc/investor%20request/investor_requests_bloc.dart';
import 'package:depi_graduation_project/bloc/investor%20request/investor_requests_event.dart';
import 'package:depi_graduation_project/bloc/investor%20request/investor_requests_state.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_bloc.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_state.dart';
import 'package:depi_graduation_project/custom%20widgets/request_tile_investor_view_new.dart';
import 'package:depi_graduation_project/screens/notifications_screen.dart';
import 'package:depi_graduation_project/screens/request_screen_investor_view_new.dart';
import 'package:depi_graduation_project/screens/about_app_screen.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _RequestDetails {
  String? entrepreneurName;
  String? entrepreneurPhotoUrl;
  String? companyName;
  String? companyLogoUrl;
}

class InvestorHomeScreen extends StatelessWidget {
  final VoidCallback? toggleTheme;
  const InvestorHomeScreen({super.key, this.toggleTheme});

  Future<_RequestDetails> _getRequestDetails(request) async {
    final details = _RequestDetails();
    try {
      // Get entrepreneur info
      final entrepreneur = await EntrepreneurFirestoreService().getEntrepreneur(
        uid: request.uid,
      );
      details.entrepreneurName = entrepreneur.name;
      details.entrepreneurPhotoUrl = entrepreneur.profileImageUrl;

      // Get company info if exists
      final companyExists = await CompanyFirestoreService().companyExists(
        uid: request.uid,
      );
      if (companyExists) {
        final company = await CompanyFirestoreService().getCompany(
          uid: request.uid,
        );
        details.companyName = company.name;
        details.companyLogoUrl = company.logoUrl;
      } else {
        details.companyName =
            entrepreneur.name;
      }
    } catch (e) {}
    return details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actionsPadding: EdgeInsets.only(right: 20),
        elevation: 0,
        actions: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.notifications,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 27,
                ),
              ),
              BlocBuilder<NotificationsBloc, NotificationsState>(
                builder: (context, state) {
                  if (state is DisplayNotifications && state.unreadCount > 0) {
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          state.unreadCount > 99
                              ? '99+'
                              : '${state.unreadCount}',
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
          const SizedBox(width: 12),
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
      body: BlocBuilder<InvestorRequestsBloc, InvestorRequestsState>(
        builder: (context, state) {
          if (state is LoadingInvestorRequests) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorLoadingInvestorRequests) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<InvestorRequestsBloc>().add(
                        LoadInvestorRequests(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is DisplayInvestorRequests) {
            if (state.requests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No requests available',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<InvestorRequestsBloc>().add(
                  LoadInvestorRequests(),
                );
                await Future.delayed(const Duration(milliseconds: 400));
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  return FutureBuilder(
                    future: _getRequestDetails(request),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final details = snapshot.data ?? _RequestDetails();

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => RequestScreenInvestorViewNew(
                                    request: request,
                                    entrepreneurName: details.entrepreneurName,
                                    entrepreneurPhotoUrl:
                                        details.entrepreneurPhotoUrl,
                                    companyName: details.companyName,
                                    companyLogoUrl: details.companyLogoUrl,
                                  ),
                            ),
                          );
                        },
                        child: RequestTileInvestorViewNew(
                          request: request,
                          entrepreneurName: details.entrepreneurName,
                          entrepreneurPhotoUrl: details.entrepreneurPhotoUrl,
                          companyName: details.companyName,
                          companyLogoUrl: details.companyLogoUrl,
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
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
                    'Investor Platform',
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
