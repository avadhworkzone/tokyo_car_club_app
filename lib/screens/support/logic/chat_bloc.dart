import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<Map<String, dynamic>> _messages = [];

  ChatBloc() : super(ChatInitial()) {
    on<LoadChatEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        _messages = [
          {
            'id': '1',
            'message': 'Hello! How can I help you today?',
            'isUser': false,
            'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
          },
        ];
        emit(ChatLoaded(List.from(_messages)));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      if (state is ChatLoaded) {
        // Add user message
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'message': event.message,
          'isUser': true,
          'timestamp': DateTime.now(),
        });
        emit(ChatLoaded(List.from(_messages)));

        // Simulate support response
        await Future.delayed(const Duration(seconds: 2));
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'message': 'Thank you for your message. Our team will assist you shortly.',
          'isUser': false,
          'timestamp': DateTime.now(),
        });
        emit(ChatLoaded(List.from(_messages)));
      }
    });

    on<SendQuickReplyEvent>((event, emit) async {
      if (state is ChatLoaded) {
        // Add user quick reply
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'message': event.quickReply,
          'isUser': true,
          'timestamp': DateTime.now(),
        });
        emit(ChatLoaded(List.from(_messages)));

        // Simulate support response based on quick reply
        await Future.delayed(const Duration(seconds: 1));
        String response = 'Thank you for contacting us about "${event.quickReply}". How can we help you further?';
        
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'message': response,
          'isUser': false,
          'timestamp': DateTime.now(),
        });
        emit(ChatLoaded(List.from(_messages)));
      }
    });
  }
}