import 'package:cs/model/User.dart' as UserModel;
import 'package:cs/repository/AuthentificationRepository.dart';
import 'package:cs/single/constant.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:cs/screen/home/home_screen.dart';
import 'package:cs/screen/utils/helpers.dart';
import 'package:cs/screen/widgets/custom_loader.dart';
import 'package:cs/screen//widgets/pin_input_field.dart';
import 'package:get/get.dart';

import 'entreprise_information_screen.dart';


class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;
  String phoneNumber = "";
  late final ScrollController scrollController;
  var authenticationRepository = Get.put(AuthenficationRepository());
  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    phoneNumber  = Get.arguments;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  // scroll to bottom of screen, when pin input field is in focus.
  Future<void> _scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await Future.delayed(const Duration(milliseconds: 250));

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: phoneNumber,
        signOutOnSuccessfulVerification: false,
        linkWithExistingUser: false,
        autoRetrievalTimeOutDuration: const Duration(seconds: 60),
        otpExpirationDuration: const Duration(seconds: 60),
        onCodeSent: () {
          log("VerifyPhoneNumberScreen", msg: 'OTP sent!');
        },
        onLoginSuccess: (userCredential, autoVerified) async {
          log(
            "VerifyPhoneNumberScreen",
            msg: autoVerified
                ? 'OTP was fetched automatically!'
                : 'OTP was verified manually!',
          );

          showSnackBar('Numero verifier avec success');
          log(
            "VerifyPhoneNumberScreen",
            msg: 'Login Success UID: ${userCredential.user?.uid}',
          );
          var response = await authenticationRepository.authentication(phoneNumber);
          if(response.statusCode == 200){
            if(response.body['message'] == "VALIDE"){
              userAuth = UserModel.User.fromJson(response.body['user']);
              storage.write("user",userAuth!.toJson());
              storage.write("token", response.body['token']['token']);
              if(userAuth!.name == null || userAuth!.avatarUrl == null || userAuth!.adresse == null){
                  Get.to(EntrepriseInformationScreen());
              }else{
                Get.to(HomeScreen());
              }
            }else {

            }

          }else {
            showSnackBar('Une erreur est apparue. Veuillez resseyer' + response.statusCode.toString());
          }
        },
        onLoginFailed: (authException, stackTrace) {
          log(
            "VerifyPhoneNumberScreen",
            msg: authException.message,
            error: authException,
            stackTrace: stackTrace,
          );

          switch (authException.code) {
            case 'invalid-phone-number':
              // invalid phone number
              return showSnackBar('Numéro invalide!');
            case 'invalid-verification-code':
              // invalid otp entered
              return showSnackBar('Le code est invalide!');
            // handle other error codes
            default:
              showSnackBar(authException.code);
            // handle error further if needed
          }
        },
        onError: (error, stackTrace) {
          log(
            "VerifyPhoneNumberScreen",
            error: error,
            stackTrace: stackTrace,
          );

          showSnackBar('Une erreur est apparue!');
        },
        builder: (context, controller) {
          return Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: controller.isSendingCode
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CustomLoader(),
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      'Envoyer le code',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Cursors Design \nBusiness",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),textAlign: TextAlign.center,),
                  SizedBox(height: 12,),
                  Text(
                    "Nous avons envoyer un code de verification à ${phoneNumber}",textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 10),
                  if (controller.codeSent)
                    TextButton(
                      onPressed: controller.isOtpExpired
                          ? () async {
                        log("VerifyPhoneNumberScreen", msg: 'Resend OTP');
                        await controller.sendOTP();
                      }
                          : null,
                      child: Text(
                        controller.isOtpExpired
                            ? 'Renvoyer'
                            : '${controller.otpExpirationTimeLeft.inSeconds}s',
                        style: const TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    ),
                  const SizedBox(height: 30),
                  if(!controller.isOtpExpired)
                  Column(
                    children: [
                      const Text(
                        'Entrer le code',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      PinInputField(
                        length: 6,
                        onFocusChange: (hasFocus) async {
                          if (hasFocus) await _scrollToBottomOnKeyboardOpen();
                        },
                        onSubmit: (enteredOtp) async {
                          final verified =
                          await controller.verifyOtp(enteredOtp);
                          if (verified) {
                            // number verify success
                            // will call onLoginSuccess handler
                          } else {
                            // phone verification failed
                            // will call onLoginFailed or onError callbacks with the error
                          }
                        },
                      ),
                    ],
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
