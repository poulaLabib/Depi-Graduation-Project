import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_graduation_project/bloc/chatroom/chatroom_bloc.dart';
import 'package:depi_graduation_project/bloc/chatroom/chatroom_event.dart';
import 'package:depi_graduation_project/bloc/chatroom/chatroom_state.dart';
import 'package:depi_graduation_project/models/chat_room.dart';
import 'package:depi_graduation_project/models/message.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatRoom room;

  const ChatRoomScreen({super.key, required this.room});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final ChatRoomBloc _bloc;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Message? _editingMessage;

  @override
  void initState() {
    super.initState();
    final auth = AuthenticationService();
    final currentUser = auth.currentUser!;
    _bloc = ChatRoomBloc(
      chatRoomService: ChatRoomFirestoreService(),
      chatRoomId: widget.room.id,
      currentUserId: currentUser.uid,
      receiverId: widget.room.otherParticipantId(currentUser.uid),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_editingMessage != null) {
      _bloc.add(EditMessage(messageId: _editingMessage!.id, newContent: text));
    } else {
      _bloc.add(SendMessage(text));
    }

    _messageController.clear();
    setState(() => _editingMessage = null);
    FocusScope.of(context).unfocus();
  }

  void _startEditing(Message message) {
    setState(() => _editingMessage = message);
    _messageController
      ..text = message.content
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: message.content.length),
      );
  }

  void _cancelEditing() {
    setState(() => _editingMessage = null);
    _messageController.clear();
  }

  void _deleteMessage(Message message) {
    _bloc.add(DeleteMessage(message.id));
  }

  void _handleMessageLongPress(Message message) {
    final auth = AuthenticationService();
    final isMine = message.senderId == auth.currentUser!.uid;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isMine)
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit message'),
                    onTap: () {
                      Navigator.pop(context);
                      _startEditing(message);
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Delete message'),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteMessage(message);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
    );
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      final hour = time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[time.weekday - 1];
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  Widget _buildMessageBubble(Message message) {
    final isMine = message.senderId == AuthenticationService().currentUser!.uid;
    final bgColor =
        isMine
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary.withAlpha(20);
    final textColor = isMine
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _handleMessageLongPress(message),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMine ? 16 : 4),
              bottomRight: Radius.circular(isMine ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTimestamp(message.timeCreated),
                    style: TextStyle(
                      fontSize: 11,
                      color: textColor.withAlpha(191),
                    ),
                  ),
                  if (message.isEdited) ...[
                    const SizedBox(width: 6),
                    Text(
                      'Edited',
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withAlpha(191),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    final isEditing = _editingMessage != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEditing)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Editing message...',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _cancelEditing,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.send,
                    maxLines: null,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary.withAlpha(20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton.small(
                  heroTag: 'send_button',
                  onPressed: _sendMessage,
                  child: Icon(isEditing ? Icons.check : Icons.send),
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
    final targetName = widget.room.targetName ?? 'Chat';

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            targetName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: false,
        ),
        body: BlocConsumer<ChatRoomBloc, ChatRoomState>(
          listener: (context, state) {
            if (state is ChatRoomError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }

            if (state is ChatRoomLoaded) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _scrollToBottom(),
              );
              _bloc.add(MarkMessagesAsRead());
            }
          },
          builder: (context, state) {
            if (state is ChatRoomLoading || state is ChatRoomInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ChatRoomLoaded) {
              final messages = List<Message>.from(state.messages)
                ..sort((a, b) => a.timeCreated.compareTo(b.timeCreated));

              return Column(
                children: [
                  Expanded(
                    child:
                        messages.isEmpty
                            ? const _EmptyConversation()
                            : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.only(
                                top: 12,
                                bottom: 8,
                              ),
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (_, index) {
                                final message =
                                    messages[messages.length - 1 - index];
                                return _buildMessageBubble(message);
                              },
                            ),
                  ),
                  _buildInputBar(),
                ],
              );
            }

            if (state is ChatRoomError) {
              return _ErrorState(
                message: state.message,
                onRetry: () => _bloc.add(LoadMessages()),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _EmptyConversation extends StatelessWidget {
  const _EmptyConversation();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 72,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start the conversation by sending a message.',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong.\n$message',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
