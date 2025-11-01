// lib/screens/chat_rooms_screen.dart

import 'package:flutter/material.dart';

class ChatRoomsScreen extends StatefulWidget {
  const ChatRoomsScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Static chat data for demo
  final List<Map<String, dynamic>> _staticChats = [
    {
      'id': '1',
      'userName': 'Ahmed El-Sayed',
      'userPhoto': 'https://i.pravatar.cc/150?img=1',
      'lastMessage': 'I\'m interested in your startup idea. Let\'s discuss the investment details.',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'unreadCount': 3,
    },
    {
      'id': '2',
      'userName': 'Sarah Mohammed',
      'userPhoto': 'https://i.pravatar.cc/150?img=5',
      'lastMessage': 'That sounds great! When can we schedule a meeting?',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'unreadCount': 1,
    },
    {
      'id': '3',
      'userName': 'Mohamed Ali',
      'userPhoto': 'https://i.pravatar.cc/150?img=12',
      'lastMessage': 'Thanks for sharing the business plan. I\'ll review it and get back to you.',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'unreadCount': 0,
    },
    {
      'id': '4',
      'userName': 'Fatma Hassan',
      'userPhoto': 'https://i.pravatar.cc/150?img=9',
      'lastMessage': 'Your company profile looks impressive!',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 0,
    },
    {
      'id': '5',
      'userName': 'Omar Khaled',
      'userPhoto': 'https://i.pravatar.cc/150?img=15',
      'lastMessage': 'Can you send me more details about the equity offer?',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'unreadCount': 5,
    },
    {
      'id': '6',
      'userName': 'Nour Ibrahim',
      'userPhoto': '',
      'lastMessage': 'Let me know if you need any help with the pitch deck.',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'unreadCount': 0,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dateTime.weekday - 1];
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  List<Map<String, dynamic>> _getFilteredChats() {
    if (_searchQuery.isEmpty) return _staticChats;
    
    return _staticChats.where((chat) {
      final userName = chat['userName'].toString().toLowerCase();
      final lastMessage = chat['lastMessage'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return userName.contains(query) || lastMessage.contains(query);
    }).toList();
  }

  int _getTotalUnread() {
    return _staticChats.fold(0, (sum, chat) => sum + (chat['unreadCount'] as int));
  }

  void _showDeleteDialog(String chatId, String userName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Chat'),
        content: Text('Are you sure you want to delete chat with $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _staticChats.removeWhere((chat) => chat['id'] == chatId);
              });
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> chat) {
    final hasUnread = (chat['unreadCount'] as int) > 0;
    
    return InkWell(
      onTap: () {
        // Mark as read
        setState(() {
          chat['unreadCount'] = 0;
        });
        
        // TODO: Navigate to chat screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening chat with ${chat['userName']}')),
        );
      },
      onLongPress: () => _showDeleteDialog(chat['id'], chat['userName']),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasUnread 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: chat['userPhoto'].toString().isNotEmpty
                  ? NetworkImage(chat['userPhoto'])
                  : null,
              child: chat['userPhoto'].toString().isEmpty
                  ? Text(
                      _getInitials(chat['userName']),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(width: 12),
            
            // Chat Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['userName'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat['lastMessage'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                      color: hasUnread ? Colors.black87 : Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Time and Unread Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(chat['time']),
                  style: TextStyle(
                    fontSize: 12,
                    color: hasUnread 
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade600,
                    fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                if (hasUnread)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Text(
                      chat['unreadCount'] > 99 ? '99+' : chat['unreadCount'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredChats = _getFilteredChats();
    final totalUnread = _getTotalUnread();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          // Total Unread Count Badge
          if (totalUnread > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    totalUnread > 99 ? '99+' : totalUnread.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search chats...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),

          // Chat Rooms List
          Expanded(
            child: filteredChats.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty ? Icons.chat_bubble_outline : Icons.search_off,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'No chats yet' : 'No chats found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Start a conversation with\ninvestors or entrepreneurs',
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chats refreshed'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    child: ListView.builder(
                      itemCount: filteredChats.length,
                      itemBuilder: (context, index) {
                        return _buildChatTile(filteredChats[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}