import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadChatEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;
  
  SendMessageEvent(this.message);
  
  @override
  List<Object?> get props => [message];
}

class SendQuickReplyEvent extends ChatEvent {
  final String quickReply;
  
  SendQuickReplyEvent(this.quickReply);
  
  @override
  List<Object?> get props => [quickReply];
}