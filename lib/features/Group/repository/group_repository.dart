import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common_used/utils.dart';
import 'package:whatsapp_clone/features/auth/repository/firebaseStorageRepo.dart';
import 'package:whatsapp_clone/models/GroupModel.dart' as model;

final GroupRepoProvider = Provider((ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository(
      {required this.firestore, required this.auth, required this.ref});

  void CreateGroup(String GrpName, File grpImage, BuildContext context,
      List<Contact> selectedContacts) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        var UserCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo:
                  selectedContacts[i].phones[0].number.replaceAll(' ', ''),
            )
            .get();

        if (UserCollection.docs.isNotEmpty && UserCollection.docs[0].exists) {
          uids.add(UserCollection.docs[0].data()['uid']);
        }
      }
      var GrpID = Uuid().v1();

      String profilePicURL = await ref
          .read(FirebasestoragerepoProvider)
          .storeFiletoFirebase('group/$GrpID', grpImage);

      model.Group group = model.Group(
          SenderID: auth.currentUser!.uid,
          name: GrpName,
          GrpID: GrpID,
          lastMessage: '',
          GroupPic: profilePicURL,
          membersUID: [auth.currentUser!.uid, ...uids]);

      await firestore.collection('groups').doc().set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
