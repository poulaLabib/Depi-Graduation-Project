import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_bloc.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_event.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_profile_field.dart';
import 'package:depi_graduation_project/models/request.dart';
import 'package:depi_graduation_project/screens/company_profile_screen.dart';
import 'package:depi_graduation_project/screens/entrepreneur_profile_screen.dart';
import 'package:depi_graduation_project/screens/investor_main_screen.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestScreenInvestorViewNew extends StatelessWidget {
  final Request request;
  final String? entrepreneurName;
  final String? entrepreneurPhotoUrl;
  final String? companyName;
  final String? companyLogoUrl;

  const RequestScreenInvestorViewNew({
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
              builder: (context) => InvestorMainScreen(initialTab: 1),
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
    final months = [
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with company logo
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 25),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child:
                      companyLogoUrl != null && companyLogoUrl!.isNotEmpty
                          ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: Image.network(
                              companyLogoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: 25),
                                  ),
                            ),
                          )
                          : Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              child: Text(
                                (companyName ?? 'C')[0].toUpperCase(),
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Company/Entrepreneur name
                  Text(
                    companyName ?? entrepreneurName ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (entrepreneurName != null && companyName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'by $entrepreneurName',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 24),
                  // Request details
                  EntrepreneurProfileField(
                    title: 'Description',
                    value: request.description,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount Requested',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatCurrency(request.amountOfMoney),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Equity in Return',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                request.equityInReturn,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (request.whyAreYouRaising.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    EntrepreneurProfileField(
                      title: 'Why are you raising?',
                      value: request.whyAreYouRaising,
                    ),
                  ],
                  const SizedBox(height: 16),
                  EntrepreneurProfileField(
                    title: 'Submitted At',
                    value: _formatDate(request.submittedAt),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTabButton(
                        "Founder",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EntrepreneurProfileScreen(),
                            ),
                          );
                        },
                        theme.colorScheme.secondary,
                        textColor: theme.colorScheme.onSecondary,
                      ),
                      buildTabButton(
                        "Company",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyProfileScreen(),
                            ),
                          );
                        },
                        theme.colorScheme.secondary,
                        textColor: theme.colorScheme.onSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Negotiate button
                  ElevatedButton.icon(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTabButton(
  String text,
  VoidCallback onTap,
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
