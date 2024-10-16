import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common_used/enum/message_typpe.dart';
import 'package:whatsapp_clone/common_used/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common_used/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chatController.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/features/chat/widgets/my_chat_card.dart';
import 'package:whatsapp_clone/features/chat/widgets/sender_chat_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserID;
  final bool isGroupChat;
  const ChatList(
      {super.key, required this.receiverUserID, required this.isGroupChat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(String Message, bool isMe, MessageTypeEnum MessageEnum) {
    ref
        .read(messageReplyProvider.state)
        .update((state) => MessageReply(Message, isMe, MessageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref
                .read(ChatControllerProvider)
                .getGroupMessages(widget.receiverUserID)
            : ref
                .read(ChatControllerProvider)
                .getMessages(widget.receiverUserID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('yufgcvhbjkhgfcdxcgh');
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });
          return ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data![index];
                if (messageData.isSeen &&
                    messageData.recieverID ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  ref.read(ChatControllerProvider).setChatMessageSeen(
                      context, widget.receiverUserID, messageData.messageID);
                }
                var TimeSent = DateFormat.Hm().format(messageData.timeSent);
                if (messageData.senderID ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyChatCard(
                      message: messageData.text,
                      date: messages[index]["time"].toString(),
                      typeEnum: messageData.type,
                      repliedText: messageData.repliedMessage,
                      username: messageData.repliedTo,
                      repliedMessageType: messageData.repliedMessageType,
                      onLeftswipe: () => onMessageSwipe(
                          messageData.text, true, messageData.type),
                      isSeen: messageData.isSeen);
                }
                return senderChatCard(
                  message: messageData.text,
                  date: messages[index]["time"].toString(),
                  typeEnum: messageData.type,
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  onRightswipe: () =>
                      onMessageSwipe(messageData.text, false, messageData.type),
                );
              });
        });
  }
}
