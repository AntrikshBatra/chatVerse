import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common_used/utils.dart';
import 'package:whatsapp_clone/features/auth/repository/firebaseStorageRepo.dart';
import 'package:whatsapp_clone/models/status_model.dart';
import 'package:whatsapp_clone/models/userModel.dart';

final StatusRepositoryProvider = Provider((ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository(
      {required this.firestore, required this.auth, required this.ref});

  void UploadStatus(
      {required String username,
      required File ImageUpload,
      required String profilePic,
      required String phoneNumber,
      required BuildContext context}) async {
    try {
      var statusID = const Uuid().v1();
      String Uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(FirebasestoragerepoProvider)
          .storeFiletoFirebase('status/$statusID$Uid', ImageUpload);

      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withThumbnail: true);
      }

      List<String> uidWhoCnSee = [];
      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var UserData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCnSee.add(UserData.uid);
        }
      }

      List<String> statusImageUrls = [];
      var statusSnapshots = await firestore
          .collection('status')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .where('createdAt',
              isLessThan: DateTime.now().subtract(Duration(hours: 24)))
          .get();

      if (statusSnapshots.docs.isNotEmpty) {
        Status status = Status.fromMap(statusSnapshots.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firestore
            .collection('status')
            .doc(statusSnapshots.docs[0].id)
            .update({'photoUrl': statusImageUrls});
        return;
      } else {
        statusImageUrls = [imageUrl];
      }

      Status status = Status(
          Uid: Uid,
          Username: username,
          phoneNumber: phoneNumber,
          photoUrl: statusImageUrls,
          createdAt: DateTime.now(),
          profilePic: profilePic,
          statusID: statusID,
          whoCanSee: uidWhoCnSee);

      await firestore.collection('status').doc(statusID).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
