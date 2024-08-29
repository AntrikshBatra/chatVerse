import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common_used/utils.dart';
import 'package:whatsapp_clone/features/auth/repository/firebaseStorageRepo.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_auth.dart';
import 'package:whatsapp_clone/features/auth/screens/user_info.dart';
import 'package:whatsapp_clone/models/userModel.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhoneNumber(BuildContext context, String PhoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: PhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Navigator.pushNamed(context, OTPScreen.route,
                arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String VerificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message.toString());
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationID,
      required String OTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: OTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInfoScreen.route, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

   void setUserState(bool isOnline) async {
        await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .update({'isOnline': isOnline});
      }

  void saveUserDataToFirestore(
      {required String name,
      required File? image,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String imageUrl =
          'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg';

      if (imageUrl != null) {
        imageUrl = await ref
            .read(FirebasestoragerepoProvider)
            .storeFiletoFirebase('profilePic/$uid', image!);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: imageUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          GrpID: []);

      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayout()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userID) {
    return firestore
        .collection('users')
        .doc(userID)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }
}
