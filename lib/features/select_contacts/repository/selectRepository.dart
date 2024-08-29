import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common_used/utils.dart';
import 'package:whatsapp_clone/models/userModel.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

final SelectContactRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withThumbnail: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void SelectContact(Contact selectedContact, BuildContext context) async {
    try {
      var UserCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in UserCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');
        print(selectedContact.phones[0].number);

        if (selectedNumber == userData.phoneNumber) {
          isFound = true;
          print(userData.name);
          Navigator.pushNamed(context, MobileChatScreen.route,arguments: {
            'name':userData.name,
            'uid':userData.uid
          });
        }
      }
      if (isFound == false) {
        print(isFound.toString());
        showSnackBar(
            context: context,
            content: 'This number does not exist on this app');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
