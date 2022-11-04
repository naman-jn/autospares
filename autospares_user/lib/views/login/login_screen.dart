import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/models/custom_response/custom_response.dart';
import 'package:autospares_user/services/api_service.dart';
import 'package:autospares_user/shared/providers.dart';
import 'package:autospares_user/shared/widgets/custom_button.dart';
import 'package:autospares_user/shared/widgets/full_screen_loading.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:autospares_user/views/login/otp_screen.dart';
import 'package:autospares_user/views/registration/registration_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController phoneCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: FullScreenLoading(
            child: Container(
              width: double.infinity,
              height: screenheight,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      AppAssetsPaths.autoStuffLogo3x,
                      height: 70,
                    ),
                    const Spacer(flex: 1),
                    Image.asset("assets/illustration@3x.png"),
                    const Spacer(flex: 2),
                    Text(
                      "Please enter your mobile number",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Row(
                      children: [
                        const Text(
                          "+91",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: inputFile(
                            label: "Mobile Number",
                            ctrl: phoneCtrl,
                          ),
                        )
                      ],
                    ),
                    const Spacer(flex: 1),
                    Consumer(builder: (context, ref, _) {
                      return CustomButton(
                        buttonText: "Get started",
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            Map loginDataMap = {
                              "mobileNumber": "+91" + phoneCtrl.text,
                            };
                            ref.read(isLoadingStateProvider.notifier).state =
                                true;
                            CustomResponse res = await ApiBaseHelper().post(
                              endpoint: "/signin.php/?tag=login",
                              body: loginDataMap,
                            );
                            ref.read(isLoadingStateProvider.notifier).state =
                                false;
                            logger.i("login api response: ${res.toString()}");
                            if (res.result == true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpScreen(
                                    mobileNumber: '+91${phoneCtrl.text}',
                                  ),
                                ),
                              );
                            } else {
                              toast(text: res.message!);
                            }
                          }
                        },
                      );
                    }),
                    const Spacer(flex: 6),
                    RichText(
                      text: TextSpan(
                        text: "New user? ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Create account',
                            style: const TextStyle(
                                color: AppColors.darkBlue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

Widget inputFile({label, required TextEditingController ctrl}) {
  return TextFormField(
    maxLength: 10,
    controller: ctrl,
    validator: (value) {
      if (value?.length != 10) {
        return 'Mobile Number must be of 10 digit';
      }
      return null;
    },
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(fontWeight: FontWeight.w300, letterSpacing: 1),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}
