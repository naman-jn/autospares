import 'dart:async';
import 'dart:math' as math;
import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/models/custom_response/custom_response.dart';
import 'package:autospares_user/models/user/user.dart';
import 'package:autospares_user/models/vendor/vendor.dart';
import 'package:autospares_user/services/api_service.dart';
import 'package:autospares_user/services/shared_preferences_service.dart';
import 'package:autospares_user/shared/providers.dart';
import 'package:autospares_user/shared/widgets/custom_button.dart';
import 'package:autospares_user/shared/widgets/full_screen_loading.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:autospares_user/views/user/home/home_screen.dart';
import 'package:autospares_user/views/user/home/providers/user_providers/user_notifier_provider.dart';
import 'package:autospares_user/views/vendor/profile/vendor_profile_screen.dart';
import 'package:autospares_user/views/vendor/profile/vendor_providers/vendor_notifier_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final String mobileNumber;

  TextEditingController textEditingController = TextEditingController();
  late final StreamController<ErrorAnimationType> errorController;
  late int timer;
  bool hasError = false;
  String otpString = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late bool loading;
  @override
  void initState() {
    super.initState();
    mobileNumber = widget.mobileNumber;
    errorController = StreamController<ErrorAnimationType>();
    loading = false;
    timer = 30;
    WidgetsBinding.instance.addPostFrameCallback(startTimer);
  }

  void startTimer(timestamp) {
    timer = 31;
    Timer.periodic(const Duration(seconds: 1), (time) {
      if (!mounted) return;

      setState(() {
        timer = timer - 1;
      });
      if (timer == 0) {
        time.cancel();
      }
    });
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FullScreenLoading(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAppBar(),
              const Spacer(
                flex: 2,
              ),
              const Text(
                'Check your mobile',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              const Text(
                'We have sent the code to',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              Text(
                mobileNumber.replaceRange(4, 11, '*******'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 50),
              _buildOtpField(context),
              const Spacer(
                flex: 1,
              ),
              Consumer(builder: (context, ref, _) {
                return CustomButton(
                  buttonText: 'Get Started',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      Map<String, dynamic> otpDataMap = {
                        "mobileNumber": mobileNumber,
                        "otp": textEditingController.text
                      };
                      ref.read(isLoadingStateProvider.notifier).state = true;
                      CustomResponse res = await ApiBaseHelper().post(
                        endpoint: "/signin.php/?tag=verifyOtp",
                        body: otpDataMap,
                      );
                      logger.i("otp verify api response: ${res.toString()}");
                      ref.read(isLoadingStateProvider.notifier).state = false;
                      if (res.result == true && res.data != null) {
                        setData(ref: ref, response: res);

                        navigateClient(ref: ref, response: res);
                      } else {
                        toast(text: res.message!);
                      }
                    }
                  },
                );
              }),
              const Spacer(
                flex: 1,
              ),
              const Text(
                "Didn’t recieve the code?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 10),
              Builder(builder: (context) {
                return Center(
                  child: timer == 0
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform(
                              transform: Matrix4.rotationY(math.pi),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.refresh,
                                color: AppColors.darkGreen,
                                size: 28,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Resend",
                              style: TextStyle(
                                color: AppColors.darkBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        )
                      : RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Resend",
                            style: TextStyle(
                              color: timer != 0
                                  ? Colors.grey.shade600
                                  : AppColors.darkBlue,
                              fontWeight: timer != 0
                                  ? FontWeight.w500
                                  : FontWeight.w800,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                if (timer == 0) {
                                  setState(() {
                                    loading = true;
                                  });
                                }
                              },
                            children: [
                              timer != 0
                                  ? TextSpan(
                                      text: " in $timer seconds",
                                      style: TextStyle(
                                        color: Colors.deepOrange.shade700,
                                      ),
                                    )
                                  : const TextSpan(),
                            ],
                          ),
                        ),
                );
              }),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildOtpField(BuildContext context) {
    return SizedBox(
      width: 280,
      child: PinCodeTextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        appContext: context,
        length: 4,
        animationType: AnimationType.scale,
        autoFocus: true,
        validator: (v) {
          return null;
        },
        cursorColor: AppColors.darkBlue,
        animationDuration: const Duration(milliseconds: 300),
        textStyle: const TextStyle(fontSize: 20, height: 1.6),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: textEditingController,
        keyboardType: TextInputType.number,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          fieldHeight: 65,
          fieldWidth: 50,
          borderRadius: const BorderRadius.all(Radius.circular(9)),
          activeColor: AppColors.lightGreen,
          activeFillColor: AppColors.lightGreen,
          inactiveColor: AppColors.lightGreen,
          inactiveFillColor: AppColors.lightGreen,
          selectedColor: AppColors.lightGreen,
          selectedFillColor: AppColors.lightGreen,
        ),
        onCompleted: (v) async {},
        onChanged: (value) {},
        beforeTextPaste: (text) {
          return false;
        },
      ),
    );
  }

  Padding _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 50, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              AppAssetsPaths.backIcon3x,
              width: 24,
            ),
          ),
          const Text(
            'Login',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            width: 44,
          ),
        ],
      ),
    );
  }

  Future<void> setData(
      {required WidgetRef ref, required CustomResponse response}) async {
    SharedPrefsService().setStringValue(SharedPrefKeys.kMobile, mobileNumber);
    SharedPrefsService()
        .setStringValue(SharedPrefKeys.kclientType, response.subData!['type']);
    ref.read(clientType.notifier).state =
        await SharedPrefsService().getStringValue(SharedPrefKeys.kclientType);
    ref.read(clientMobileNumber.notifier).state =
        await SharedPrefsService().getStringValue(SharedPrefKeys.kMobile);
  }

  void navigateClient(
      {required WidgetRef ref, required CustomResponse response}) {
    if (response.subData!['type'] == "user") {
      ref
          .read(userNotifierProvider.notifier)
          .addUserDetails(User.fromJson(response.data!));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    }
    if (response.subData!['type'] == "vendor") {
      ref
          .read(vendorNotifierProvider.notifier)
          .addVendorDetails(Vendor.fromJson(response.data!));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const VendorProfileScreen(),
          ),
          (route) => false);
    }
  }
}
