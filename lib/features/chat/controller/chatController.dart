import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common_used/enum/message_typpe.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/repository/chatRepository.dart';
import 'package:whatsapp_clone/models/chatContact.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/userModel.dart';

final ChatControllerProvider = Provider((ref) {
  final ChatRepository = ref.watch(ChatRepositoryProvider);
  return ChatController(chatRepository: ChatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<Message>> getMessages(String receiverUserID) {
    return chatRepository.getMessages(receiverUserID);
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserID,
  ) async {
    ref.read(UserDataProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserID: receiverUserID,
            senderUser: value!));
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserID,
    MessageTypeEnum TypeEnum,
  ) async {
    ref.read(UserDataProvider).whenData((value) =>
        chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserID: receiverUserID,
            senderUserData: value!,
            ref: ref,
            messageEnum: TypeEnum));
  }

  void sendGIFMessage(
      BuildContext context, String GIFUrl, String receiverUserID) {
    int gifUrlPartIndex = GIFUrl.lastIndexOf('-') + 1;
    String gifUrlPart = GIFUrl.substring(gifUrlPartIndex);
    String newGIFUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    print(newGIFUrl);
    ref.read(UserDataProvider).whenData((value) {
      chatRepository.sendGIFMessage(
          context: context,
          GIFUrl: newGIFUrl,
          receiverUserID: receiverUserID,
          senderUser: value!);
    });
  }
}
