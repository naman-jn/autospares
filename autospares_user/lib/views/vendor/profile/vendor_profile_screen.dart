import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/services/shared_preferences_service.dart';
import 'package:autospares_user/shared/widgets/custom_loading.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:autospares_user/views/login/login_screen.dart';
import 'package:autospares_user/views/vendor/profile/vendor_providers/vendor_notifier_provider.dart';
import 'package:autospares_user/views/vendor/profile/widgets/bottom_card.dart';
import 'package:autospares_user/views/vendor/profile/widgets/profile_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({Key? key}) : super(key: key);

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final vendorDataNotifierProvider = ref.watch(vendorNotifierProvider);
        return vendorDataNotifierProvider.when(
          data: (data) {
            return Scaffold(
              backgroundColor: AppColors.darkBlue,
              body: SafeArea(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ProfileDetailsWidget(
                      vendorData: data,
                      onTapCallBack: () {
                        ref.refresh(vendorNotifierProvider);
                        SharedPrefsService()
                            .removeKey(SharedPrefKeys.kclientType);
                        SharedPrefsService().removeKey(SharedPrefKeys.kMobile);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                    ),
                    const BottomCard(),
                  ],
                ),
              ),
            );
          },
          error: (error, stacktrace) {
            return const Text("Oops! some error occurred :(");
          },
          loading: () => const LoadingScreen(),
        );
      },
    );
  }
}
