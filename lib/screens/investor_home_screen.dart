
import 'package:depi_graduation_project/bloc/investor%20request/investor_requests_bloc.dart';
import 'package:depi_graduation_project/bloc/investor%20request/investor_requests_event.dart';
import 'package:depi_graduation_project/bloc/investor%20request/investor_requests_state.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_bloc.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_state.dart';
import 'package:depi_graduation_project/custom%20widgets/request_tile_investor_view_new.dart';
import 'package:depi_graduation_project/screens/notifications_screen.dart';
import 'package:depi_graduation_project/screens/request_screen_investor_view_new.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _RequestDetails {
  String? entrepreneurName;
  String? entrepreneurPhotoUrl;
  String? companyName;
  String? companyLogoUrl;
}

class InvestorHomeScreen extends StatelessWidget {
  const InvestorHomeScreen({super.key});

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
            entrepreneur.name; // Use entrepreneur name as fallback
      }
    } catch (e) {
      // Handle error silently
    }
    return details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actionsPadding: EdgeInsets.only(right: 10),
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
                  color: Theme.of(context).colorScheme.primary,
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
}
