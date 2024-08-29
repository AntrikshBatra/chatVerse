import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const String route = "/otp-screen";
  final String VerificationId;
  const OTPScreen({super.key, required this.VerificationId});

  void VerifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref
        .read(AuthControllerProvider)
        .verifyOTP(context, VerificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifying Phone Number"),
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('We have sent an SMS with OTP'),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: '- - - - - -'),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (val.length == 6) {
                    VerifyOTP(
                      ref,
                      context,
                    val.trim());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
