import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common_used/widgets/error.dart';
import 'package:whatsapp_clone/common_used/widgets/loader.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/selectContactController.dart';
import 'package:whatsapp_clone/features/chat/widgets/contacts_list.dart';

class SelectContactScreen extends ConsumerWidget {
  const SelectContactScreen({super.key});

  static const String route = '/selectContact';

  void SelectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) async {
    ref
        .read(SelectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) => ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: ()=>SelectContact(ref,contactList[index],context),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: TextStyle(fontSize: 18),
                      ),
                      leading: contact.photoOrThumbnail == null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small/default-avatar-profile-icon-of-social-media-user-vector.jpg'),
                              radius: 20,
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  MemoryImage(contact.photoOrThumbnail!),
                              radius: 20,
                            ),
                    ),
                  ),
                );
              }),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => Loader()),
    );
  }
}
