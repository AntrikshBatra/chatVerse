import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common_used/widgets/error.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_auth.dart';
import 'package:whatsapp_clone/features/auth/screens/user_info.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/features/status/screens/confirmStatusScreen.dart';
import 'package:whatsapp_clone/features/status/screens/statusStoryScreen.dart';
import 'package:whatsapp_clone/models/status_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.RouteName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.route:
      final verificationID = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(VerificationId: verificationID));
    case UserInfoScreen.route:
      return MaterialPageRoute(builder: (context) => const UserInfoScreen());
    case SelectContactScreen.route:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    case MobileChatScreen.route:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
              ));
    case ConfirmStatusScreen.route:
      final file = settings.arguments as File;
      return MaterialPageRoute(
          builder: (context) => ConfirmStatusScreen(
                file: file,
              ));       
    case StatusStoryScreen.route:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
          builder: (context) => StatusStoryScreen(
                status: status,
              ));                    
    default:
      return MaterialPageRoute(
          builder: (context) => Scaffold(
                body: ErrorScreen(error: 'Ths page doesn\'t exist'),
              ));
  }
}
