import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

  void uploadStatus({
  required String username,
  required String profilePic,
  required String phoneNumber,
  required File statusImage,
  required BuildContext context,
}) async {
  try {
    var statusId = const Uuid().v1();
    String uid = auth.currentUser!.uid;
    String imageUrl =
        await ref.read(FirebasestoragerepoProvider).storeFiletoFirebase(
              '/status/$statusId$uid',
              statusImage,
            );
    List<Contact> contacts = [];
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
    }

    List<String> uidWhoCanSee = [];

    // Get the list of users who can see the status
    for (int i = 0; i < contacts.length; i++) {
      var userDataFirebase = await firestore
          .collection('users')
          .where(
            'phoneNumber',
            isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
          )
          .get();

      if (userDataFirebase.docs.isNotEmpty) {
        var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
        uidWhoCanSee.add(userData.uid);
      }
    }

    // Check if the current user already has a status document
    var statusesSnapshot = await firestore
        .collection('status')
        .where('Uid', isEqualTo: uid)
        .get();

    List<String> statusImageUrls = [];

    if (statusesSnapshot.docs.isNotEmpty) {
      // If a status document exists, update the existing one
      Status status = Status.fromMap(statusesSnapshot.docs[0].data());
      statusImageUrls = status.photoUrl;
      statusImageUrls.add(imageUrl);

      // Update the existing document with the new status image
      await firestore.collection('status').doc(statusesSnapshot.docs[0].id).update({
        'photoUrl': statusImageUrls,
        'createdAt': DateTime.now(),  // Update the timestamp
      });
    } else {
      // If no status document exists, create a new one
      statusImageUrls = [imageUrl];

      Status status = Status(
        Uid: uid,
        Username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusID: statusId,
        whoCanSee: uidWhoCanSee,
      );

      // Create a new document for the user's status
      await firestore.collection('status').doc(statusId).set(status.toMap());
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        var statusesSnapshot = await firestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .where('createdAt',
                isGreaterThan: Timestamp.fromDate(
                    DateTime.now().subtract(const Duration(hours: 24))))
            .get();

        //.get();
        //print(statusesSnapshot.docs.length);
        for (var tempData in statusesSnapshot.docs) {
          print(tempData.data());
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }
}
