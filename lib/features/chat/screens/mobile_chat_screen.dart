import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common_used/widgets/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/bottomChatField.dart';
import 'package:whatsapp_clone/models/userModel.dart';
import 'package:whatsapp_clone/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  final bool isGroupChat;
  const MobileChatScreen(
      {super.key,
      required this.name,
      required this.uid,
      required this.isGroupChat});

  static const String route = '/mobileChat';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(name);
    print(uid);
    return Scaffold(
      appBar: AppBar(
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel>(
                stream: ref.read(AuthControllerProvider).userDataByID(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name),
                      Text(
                        snapshot.data!.isOnline ? 'online' : 'offline',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      )
                    ],
                  );
                }),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatList(
            receiverUserID: uid,
            isGroupChat:isGroupChat
          )),
          Container(
            padding: const EdgeInsets.all(8),
            child: BottomChatField(
              receiverUserID: uid,
              isGroupChat:isGroupChat
            ),
          )
        ],
      ),
    );
  }
}
