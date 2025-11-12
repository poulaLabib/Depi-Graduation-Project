// lib/screens/chat_rooms_screen.dart
import 'package:depi_graduation_project/bloc/chatroom/chatroom_bloc.dart';
import 'package:depi_graduation_project/screens/chat_room_srceen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_bloc.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_state.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_event.dart';
import 'package:depi_graduation_project/models/chat_room.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';

class ChatRoomsScreen extends StatefulWidget {
  const ChatRoomsScreen({super.key});

  @override
  State<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatRoom> _filterRooms(List<ChatRoom> rooms) {
    if (_searchQuery.isEmpty) return rooms;
    final query = _searchQuery.toLowerCase();
    return rooms
        .where(
          (room) =>
              room.participantsNames.any(
                (name) => name.toLowerCase().contains(query),
              ) ||
              (room.lastMessage).toLowerCase().contains(query),
        )
        .toList();
  }

  int _totalUnread(List<ChatRoom> rooms) =>
      rooms.fold<int>(0, (sum, room) => sum + (room.unreadCount));

  void _confirmDelete(BuildContext context, ChatRoom room) {
    showDialog<void>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Delete Chat'),
            content: Text(
              'Are you sure you want to delete chat with ${room.targetName ?? 'this user'}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  context.read<ChatListBloc>().add(
                    DeleteChatRoom(chatRoomId: room.id),
                  );
                  Navigator.pop(dialogContext);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  Widget _buildTile(BuildContext context, ChatRoom room) {
    final hasUnread = (room.unreadCount) > 0;
    final lastMessage = room.lastMessage;
    final formattedTime = room.lastMessageTimeFormatted;
    final profileUrl = room.targetPhotoUrl ?? '';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider(
                  create:
                      (_) => ChatRoomBloc(
                        chatRoomService: ChatRoomFirestoreService(),
                        chatRoomId: room.id,
                        currentUserId: AuthenticationService().currentUser!.uid,
                        receiverId: room.otherParticipantId(
                          AuthenticationService().currentUser!.uid,
                        ),
                      ),
                  child: ChatRoomScreen(room: room),
                ),
          ),
        );
      },
      onLongPress: () => _confirmDelete(context, room),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              hasUnread
                  ? Theme.of(context).colorScheme.primary.withAlpha(11)
                  : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage:
                  profileUrl.isNotEmpty ? NetworkImage(profileUrl) : null,
              child:
                  profileUrl.isEmpty
                      ? Text(
                        room.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.targetName ?? 'Unknown User',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          hasUnread ? FontWeight.w500 : FontWeight.normal,
                      color: hasUnread ? Colors.black87 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        hasUnread
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade600,
                    fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                if (hasUnread)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      room.unreadCount > 99
                          ? '99+'
                          : room.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChatListState state) {
    if (state is ChatListLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ChatListError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Unable to load chats.\n${state.message}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    () => context.read<ChatListBloc>().add(LoadChatRooms()),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is ChatListLoaded) {
      final filtered = _filterRooms(state.chatRooms);
      final totalUnread = _totalUnread(state.chatRooms);

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search chats...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                        : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child:
                filtered.isEmpty
                    ? _EmptyState(hasQuery: _searchQuery.isNotEmpty)
                    : RefreshIndicator(
                      onRefresh: () async {
                        context.read<ChatListBloc>().add(LoadChatRooms());
                        await Future.delayed(const Duration(milliseconds: 400));
                      },
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder:
                            (context, index) =>
                                _buildTile(context, filtered[index]),
                      ),
                    ),
          ),
          if (totalUnread > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  totalUnread > 99 ? '99+' : totalUnread.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ChatListBloc(
            chatRoomService: ChatRoomFirestoreService(),
            auth: AuthenticationService(),
          ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          title: const Text(
            'Chats',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<ChatListBloc, ChatListState>(builder: _buildBody),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasQuery;
  const _EmptyState({required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasQuery ? Icons.search_off : Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            hasQuery ? 'No chats found' : 'No chats yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          if (!hasQuery) ...[
            const SizedBox(height: 8),
            Text(
              'Start a conversation with\ninvestors or entrepreneurs',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }
}
