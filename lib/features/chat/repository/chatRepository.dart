import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common_used/enum/message_typpe.dart';
import 'package:whatsapp_clone/common_used/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common_used/utils.dart';
import 'package:whatsapp_clone/features/auth/repository/firebaseStorageRepo.dart';
import 'package:whatsapp_clone/models/chatContact.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/userModel.dart';

final ChatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<Message>> getMessages(String receiverUSerID) {
    print('111111111111111111111111111');
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUSerID)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];

      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((snap) async {
      List<ChatContact> contacts = [];
      for (var document in snap.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(ChatContact(
            name: chatContact.name,
            profilePic: chatContact.profilePic,
            contactID: chatContact.contactID,
            TimeSent: chatContact.TimeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }

  void _saveMessageToMessageSubcollection({
    required String receiverUserID,
    required String text,
    required DateTime timeSent,
    required String messageID,
    required String username,
    required String receiverUsername,
    required MessageTypeEnum messageType,
    required MessageReply? messageReply,
    required String senderUserName,
    required String receiverusername,
  }) async {
    //users=>sender ID=>receiver ID=>messages=>message ID=>store message
    final message = Message(
        senderID: auth.currentUser!.uid,
        recieverID: receiverUserID,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageID: messageID,
        isSeen: false,
        repliedMessage: messageReply == null ? '' : messageReply.Message,
        repliedTo: messageReply == null
            ? ''
            : messageReply.isMe
                ? senderUserName
                : receiverusername,
        repliedMessageType: messageReply == null
            ? MessageTypeEnum.text
            : messageReply.MessageEnum);

    //users=>sender ID=>receiver ID=>messages=>message ID=>store message----->store message for other user
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserID)
        .collection('messages')
        .doc(messageID)
        .set(message.toMap());

    //users=>receiver ID=>sender ID=>messages=>message ID=>store message----->store message for other user
    await firestore
        .collection('users')
        .doc(receiverUserID)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageID)
        .set(message.toMap());
  }

  void _saveDataToChatSubcollection(
      UserModel senderUserData,
      UserModel receiverUserData,
      String text,
      DateTime timeSent,
      String receiverUserID) async {
    //users=>receiver user id=>chats=>current user id=>set data----->display message to other user
    var receiverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactID: senderUserData.uid,
        TimeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection('users')
        .doc(receiverUserID)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());

    //users=>current user id=>chats=>receiver user id=>set data------>display message to us
    var senderChatContact = ChatContact(
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        contactID: receiverUserData.uid,
        TimeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserID)
        .set(senderChatContact.toMap());
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String receiverUserID,
      required UserModel senderUser,
      required MessageReply? messageReply}) async {
    //users=>sender ID=>receiver ID=>messages=>message ID=>store message
    try {
      var TimeSent = DateTime.now();
      var userData =
          await firestore.collection('users').doc(receiverUserID).get();

      UserModel receiverUserData = UserModel.fromMap(userData.data()!);

      //current chat contact
      //users=>receiver user id=>chats=>current user id=>set data

      var messageID = const Uuid().v1();

      _saveDataToChatSubcollection(
          senderUser, receiverUserData, text, TimeSent, receiverUserID);

      _saveMessageToMessageSubcollection(
          receiverUserID: receiverUserID,
          timeSent: TimeSent,
          text: text,
          messageType: MessageTypeEnum.text,
          messageID: messageID,
          receiverUsername: receiverUserData.name,
          username: senderUser.name,
          messageReply: messageReply,
          receiverusername: receiverUserData.name,
          senderUserName: senderUser.name);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserID,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageTypeEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageID = const Uuid().v1();

      String fileUrl = await ref
          .read(FirebasestoragerepoProvider)
          .storeFiletoFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/${receiverUserID}/${messageID}}',
              file);

      UserModel receverUserData;
      var Userdata =
          await firestore.collection('users').doc(receiverUserID).get();
      receverUserData = UserModel.fromMap(Userdata.data()!);

      String contactMsg;

      switch (messageEnum) {
        case MessageTypeEnum.image:
          contactMsg = '📷 Image';
          break;
        case MessageTypeEnum.video:
          contactMsg = '📹 Video';
          break;
        case MessageTypeEnum.audio:
          contactMsg = '🎧 audio';
          break;
        case MessageTypeEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'Not Supported';
      }

      _saveDataToChatSubcollection(senderUserData, receverUserData, contactMsg,
          timeSent, receiverUserID);

      _saveMessageToMessageSubcollection(
          receiverUserID: receiverUserID,
          text: fileUrl,
          timeSent: timeSent,
          messageID: messageID,
          username: senderUserData.name,
          receiverUsername: receverUserData.name,
          messageType: messageEnum,
          messageReply: messageReply,
          receiverusername: receverUserData.name,
          senderUserName: senderUserData.name);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage(
      {required BuildContext context,
      required String GIFUrl,
      required String receiverUserID,
      required UserModel senderUser,
      required MessageReply? messageReply}) async {
    //users=>sender ID=>receiver ID=>messages=>message ID=>store message
    try {
      var TimeSent = DateTime.now();
      var userData =
          await firestore.collection('users').doc(receiverUserID).get();

      UserModel receiverUserData = UserModel.fromMap(userData.data()!);

      //current chat contact
      //users=>receiver user id=>chats=>current user id=>set data

      var messageID = const Uuid().v1();

      _saveDataToChatSubcollection(
          senderUser, receiverUserData, 'GIF', TimeSent, receiverUserID);

      _saveMessageToMessageSubcollection(
          receiverUserID: receiverUserID,
          timeSent: TimeSent,
          text: GIFUrl,
          messageType: MessageTypeEnum.gif,
          messageID: messageID,
          receiverUsername: receiverUserData.name,
          username: senderUser.name,
          messageReply: messageReply,
          receiverusername: receiverUserData.name,
          senderUserName: senderUser.name);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatSeenMessage(
      BuildContext context, String receiverUserID, String messageID) async {
    try {
       //users=>sender ID=>receiver ID=>messages=>message ID=>store message----->store message for other user
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserID)
        .collection('messages')
        .doc(messageID)
        .update({
          'isSeen':true
        });

    //users=>receiver ID=>sender ID=>messages=>message ID=>store message----->store message for other user
    await firestore
        .collection('users')
        .doc(receiverUserID)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageID)
        .update({
          'isSeen':true
        });
    } catch (ex) {
      showSnackBar(context: context, content: ex.toString());
    }
  }
}
