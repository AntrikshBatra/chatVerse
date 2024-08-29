import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common_used/widgets/error.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_auth.dart';
import 'package:whatsapp_clone/features/auth/screens/user_info.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

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
    default:
      return MaterialPageRoute(
          builder: (context) => Scaffold(
                body: ErrorScreen(error: 'Ths page doesn\'t exist'),
              ));
  }
}
