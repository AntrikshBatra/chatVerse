import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common_used/utils.dart';
import 'package:whatsapp_clone/common_used/widgets/button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const RouteName = "/login-screen";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? _country;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void pickCountry() {
      showCountryPicker(
          context: context,
          onSelect: (Country) {
            setState(() {
              _country = Country;
            });
          });
    }

    void sendPhoneNumber() {
      String phoneNumber = phoneController.text.trim();
      print(phoneNumber);
      print(_country!.phoneCode);
      if (_country != null && phoneNumber.isNotEmpty) {
        ref.read(AuthControllerProvider).signInWithPhone(
            context, '+${_country!.phoneCode}$phoneNumber');
      } else {
        showSnackBar(context: context, content: "Fill all Details");
      }
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your Phone Number"),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Whatsapp will need to verify your number"),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: pickCountry,
                  child: Text(
                    "Pick Country",
                    style: TextStyle(color: Colors.blue),
                  )),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  _country != null
                      ? Text('+${_country!.phoneCode}')
                      : Container(),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(hintText: "Phone Number"),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.5,
              ),
              SizedBox(
                child: MyButton(text: 'Next', onPressed: sendPhoneNumber),
              )
            ],
          ),
        ),
      ),
    );
  }
}
