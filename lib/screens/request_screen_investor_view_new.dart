import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_bloc.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_event.dart';
import 'package:depi_graduation_project/models/request.dart';
import 'package:depi_graduation_project/screens/company_profile_view_screen.dart';
import 'package:depi_graduation_project/screens/entrepreneur_profile_screen.dart';
import 'package:depi_graduation_project/screens/investor_main_screen.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class RequestScreenInvestorViewNew extends StatelessWidget {
  final Request request;
  final String? entrepreneurName;
  final String? entrepreneurPhotoUrl;
  final String? companyName;
  final String? companyLogoUrl;
  final bool isOwner;

  const RequestScreenInvestorViewNew({
    this.isOwner = false,
    required this.request,
    this.entrepreneurName,
    this.entrepreneurPhotoUrl,
    this.companyName,
    this.companyLogoUrl,
    super.key,
  });

  Future<void> _negotiate(BuildContext context) async {
    final auth = AuthenticationService();
    final currentUser = auth.currentUser;
    if (currentUser == null) return;

    try {
      // Get investor info
      final investor = await InvestorFirestoreService().getInvestor(
        uid: currentUser.uid,
      );

      if (request.uid.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid entrepreneur information')),
          );
        }
        return;
      }

      // Get entrepreneur info
      final entrepreneur = await EntrepreneurFirestoreService().getEntrepreneur(
        uid: request.uid,
      );

      // Get chat room ID
      final chatRoomId =
          currentUser.uid.compareTo(request.uid) <= 0
              ? '${currentUser.uid}_${request.uid}'
              : '${request.uid}_${currentUser.uid}';

      // Check if chat room already exists
      final chatRoomDoc =
          await FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(chatRoomId)
              .get();

      final chatRoomExists = chatRoomDoc.exists;

      // Create or get chat room
      final chatRoomService = ChatRoomFirestoreService();
      await chatRoomService.addOrGetChatRoom(
        currentUser.uid,
        request.uid,
        name1: investor.name,
        name2: entrepreneur.name,
        photoUrl1: investor.photoUrl,
        photoUrl2: entrepreneur.profileImageUrl,
      );

      // Send notification to entrepreneur only if chat is new
      if (!chatRoomExists) {
        final notificationService = NotificationFirestoreService();
        await notificationService.addNotification(
          receiverId: request.uid,
          senderId: currentUser.uid,
          senderName: investor.name,
          type: 'chat',
          message:
              '${investor.name} started a chat with you about your request',
        );

        // Create initial message only if chat is new
        await chatRoomService.addMessage(
          chatRoomId,
          'Hello! I\'m interested in discussing your request.',
          currentUser.uid,
          request.uid,
        );
      }

      // Reload chat list
      if (context.mounted) {
        context.read<ChatListBloc>().add(LoadChatRooms());
      }

      // Navigate to chats tab in bottom navigation
      if (context.mounted) {
        // Pop back to the main screen
        Navigator.of(context).popUntil((route) {
          return route.isFirst;
        });

        // If chat exists, navigate to chats tab by replacing the main screen
        if (chatRoomExists) {
          // Replace the current route with InvestorMainScreen showing chats tab
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const InvestorMainScreen(initialTab: 1),
            ),
          );
        } else {
          // For new chats, just pop back
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '\$${amount.toStringAsFixed(0)}';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Company Logo
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            floating: false,
            backgroundColor: theme.colorScheme.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.cardColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  if (companyLogoUrl != null && companyLogoUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        companyLogoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              child: Icon(
                                Icons.business,
                                size: 60,
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                              ),
                            ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.business,
                          size: 80,
                          color: theme.colorScheme.onPrimary.withOpacity(0.8),
                        ),
                      ),
                    ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),

                  // Company Name and Entrepreneur Info
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          companyName ?? 'Company Name',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (entrepreneurName != null)
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage:
                                    entrepreneurPhotoUrl != null &&
                                            entrepreneurPhotoUrl!.isNotEmpty
                                        ? NetworkImage(entrepreneurPhotoUrl!)
                                        : null,
                                child:
                                    entrepreneurPhotoUrl == null ||
                                            entrepreneurPhotoUrl!.isEmpty
                                        ? const Icon(Icons.person, size: 14)
                                        : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'By $entrepreneurName',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Request Summary Cards
                  Row(
                    children: [
                      // Amount Card
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          'Amount',
                          _formatCurrency(request.amountOfMoney),
                          Icons.attach_money,
                          theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Equity Card
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          'Equity',
                          request.equityInReturn,
                          Icons.pie_chart,
                          theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Request Details Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Request Details',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            context,
                            'Amount Requested',
                            _formatCurrency(request.amountOfMoney),
                            Icons.attach_money,
                            theme.colorScheme.primary,
                          ),
                          const Divider(height: 32),
                          _buildDetailRow(
                            context,
                            'Equity Offered',
                            request.equityInReturn,
                            Icons.pie_chart,
                            theme.colorScheme.secondary,
                          ),
                          const Divider(height: 32),
                          _buildDetailRow(
                            context,
                            'Date Submitted',
                            _formatDate(request.submittedAt),
                            Icons.calendar_today,
                            theme.colorScheme.tertiary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // About Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About This Request',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            request.description ?? 'No description provided',
                            style: textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Why Raising Section (if available)
                  if (request.whyAreYouRaising != null &&
                      request.whyAreYouRaising!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Why We\'re Raising',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                request.whyAreYouRaising!,
                                style: textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Profile Buttons - Only show if not the owner
                  if (!isOwner) ...[
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EntrepreneurProfileScreen(
                                        entrepreneurId: request.uid,
                                        isViewOnly: true,
                                      ),
                                ),
                              );
                            },
                            child: buildTabButton(
                              "Entrepreneur",
                              theme.colorScheme.secondary,
                              textColor: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CompanyProfileViewScreen(
                                        companyName: companyName ?? 'Company',
                                        description: 'Company description',
                                        founded: '2020',
                                        teamSize: '15',
                                        industry: 'Technology',
                                        stage: 'Series A',
                                        location: 'Cairo, Egypt',
                                        logoUrl: companyLogoUrl,
                                        isViewOnly: true,
                                      ),
                                ),
                              );
                            },
                            child: buildTabButton(
                              "Company",
                              theme.colorScheme.secondary,
                              textColor: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Negotiate button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _negotiate(context),
                      icon: const Icon(Icons.chat),
                      label: const Text(
                        'Negotiate',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabButton(
    String text,
    Color bgColor, {
    Color textColor = Colors.black,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
