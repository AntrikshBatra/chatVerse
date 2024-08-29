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

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Expanded(
        child: StreamBuilder<List<ChatContact>>(
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
                                  'uid': chatContactData.contactID
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
      ),
    );
  }
}
