import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common_used/widgets/button.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.RouteName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Center(
            child: Text(
              "Welcome To Whatsapp",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: size.height / 9,
          ),
          Image.asset(
            'lib/assets/bg.png',
            height: 200,
            width: 200,
            color: tabColor,
          ),
          SizedBox(
            height: size.height / 9,
          ),
          Text(
            'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
            style: TextStyle(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              width: size.width * 0.75,
              child: MyButton(
                  text: "Agree and Continue",
                  onPressed: () => navigateToLoginScreen(context)))
        ],
      )),
    );
  }
}
