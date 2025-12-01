import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokyo_car_club/core/utils/string_utils.dart';
import 'package:tokyo_car_club/core/constants/app_colors.dart';
import 'package:tokyo_car_club/core/theme/app_theme.dart';
import 'package:tokyo_car_club/core/widgets/app_text.dart';
import 'logic/chat_bloc.dart';
import 'logic/chat_event.dart';
import 'logic/chat_state.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(LoadChatEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
          title: Text(
            StringUtils.t('support'),
            style: TextStyle(color: AppColors.textPrimary(context)),
          ),
          backgroundColor: AppColors.background(context),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: AppColors.surface(context),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary(context),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        body: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatLoaded) {
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ChatError) {
              return Center(
                child: AppText(
                  state.message,
                  style: TextStyle(color: AppColors.textPrimary(context)),
                ),
              );
            }

            if (state is ChatLoaded) {
              return Column(
                children: [
                  // Quick Reply Suggestions
                  _buildQuickReplies(context),

                  // Chat Messages
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
                  ),

                  // Message Input
                  _buildMessageInput(context),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildQuickReplies(BuildContext context) {
    final quickReplies = [
      StringUtils.t('booking_issue'),
      StringUtils.t('payment_problem'),
      StringUtils.t('car_location'),
      StringUtils.t('general_inquiry'),
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: quickReplies.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.read<ChatBloc>().add(
                    SendQuickReplyEvent(quickReplies[index]),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.blueAccent, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      quickReplies[index],
                      style: const TextStyle(
                        color: AppColors.blueAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final messageText = message['message'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.blueAccent,
              child: const Icon(
                Icons.support_agent,
                color: AppColors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.blueAccent
                    : AppColors.cardBackground(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                messageText,
                style: TextStyle(
                  color: isUser ? Colors.white : AppColors.textPrimary(context),
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surface(context),
              backgroundImage: const AssetImage("assets/images/user.png"),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        border: Border(top: BorderSide(color: AppColors.white24, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background(context),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: AppColors.textPrimary(context)),
                decoration: InputDecoration(
                  hintText: StringUtils.t('type_message'),
                  hintStyle: TextStyle(color: AppColors.textTertiary(context)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (message) {
                  if (message.trim().isNotEmpty) {
                    context.read<ChatBloc>().add(
                      SendMessageEvent(message.trim()),
                    );
                    _messageController.clear();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final message = _messageController.text.trim();
                if (message.isNotEmpty) {
                  context.read<ChatBloc>().add(SendMessageEvent(message));
                  _messageController.clear();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: AppColors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
