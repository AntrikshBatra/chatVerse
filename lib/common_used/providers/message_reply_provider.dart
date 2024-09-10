import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReply {
  final String Message;
  final bool isMe;
  final MessageEnum;

  MessageReply(this.Message, this.isMe, this.MessageEnum);
}

final messageReplyProvider = StateProvider<MessageReply?>((ref)=>null);
