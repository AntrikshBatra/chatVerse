import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common_used/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chatController.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/models/chatContact.dart';
import 'package:whatsapp_clone/models/GroupModel.dart' as model;

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<model.Group>>(
                  stream: ref.watch(ChatControllerProvider).chatGroups(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var groupData = snapshot.data![index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, MobileChatScreen.route,
                                      arguments: {
                                        'name': groupData.name,
                                        'uid': groupData.GrpID,
                                        'isGroupChat':true
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(
                                      groupData.name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    subtitle: Padding(
                                        padding: EdgeInsets.only(
                                          top: 6,
                                        ),
                                        child: Text(
                                          groupData.lastMessage,
                                          style: TextStyle(fontSize: 15),
                                        )),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(groupData.GroupPic),
                                      radius: 30,
                                    ),
                                    trailing: Text(
                                      DateFormat.Hm()
                                          .format(groupData.timeSent),
                                      style:
                                          TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                color: dividerColor,
                                indent: 95,
                              )
                            ],
                          );
                        });
                  }),

              StreamBuilder<List<ChatContact>>(
                  stream: ref.watch(ChatControllerProvider).chatContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var chatContactData = snapshot.data![index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, MobileChatScreen.route,
                                      arguments: {
                                        'name': chatContactData.name,
                                        'uid': chatContactData.contactID,
                                        'isGroupChat':false
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(
                                      chatContactData.name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    subtitle: Padding(
                                        padding: EdgeInsets.only(
                                          top: 6,
                                        ),
                                        child: Text(
                                          chatContactData.lastMessage,
                                          style: TextStyle(fontSize: 15),
                                        )),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(chatContactData.profilePic),
                                      radius: 30,
                                    ),
                                    trailing: Text(
                                      DateFormat.Hm()
                                          .format(chatContactData.TimeSent),
                                      style:
                                          TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                color: dividerColor,
                                indent: 95,
                              )
                            ],
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
