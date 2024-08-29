import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_clone/models/userModel.dart';

final AuthControllerProvider = Provider((ref) {
  final AuthRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: AuthRepository, ref: ref);
});

final UserDataProvider = FutureProvider((ref) {
  final authController = ref.watch(AuthControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  void signInWithPhone(BuildContext context, String PhoneNumber) {
    authRepository.signInWithPhoneNumber(context, PhoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationID, String OTP) {
    authRepository.verifyOTP(
        context: context, verificationID: verificationID, OTP: OTP);
  }

  void saveUserDataToFirestore(BuildContext context, String name, File? image) {
    authRepository.saveUserDataToFirestore(
        name: name, image: image, ref: ref, context: context);
  }

  void setUserState(bool isOnline){
    authRepository.setUserState(isOnline);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel> userDataByID(String userID) {
    return authRepository.userData(userID);
  }
}
