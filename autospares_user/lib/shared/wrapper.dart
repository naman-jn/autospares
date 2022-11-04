import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/services/shared_preferences_service.dart';
import 'package:autospares_user/shared/providers.dart';
import 'package:autospares_user/shared/widgets/custom_loading.dart';
import 'package:autospares_user/views/login/login_screen.dart';
import 'package:autospares_user/views/user/home/home_screen.dart';
import 'package:autospares_user/views/vendor/profile/vendor_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (ref.read(clientMobileNumber.notifier).state == null) {
              return LoginScreen();
            }
            if (ref.read(clientType.notifier).state == "user") {
              return const HomeScreen();
            }
            if (ref.read(clientType.notifier).state == "vendor") {
              return const VendorProfileScreen();
            }
          }
          return const LoadingScreen();
        },
      ),
    );
  }

  getData(WidgetRef ref) async {
    ref.read(clientType.notifier).state =
        await SharedPrefsService().getStringValue(SharedPrefKeys.kclientType);
    ref.read(clientMobileNumber.notifier).state =
        await SharedPrefsService().getStringValue(SharedPrefKeys.kMobile);

    logger.i(
        "${ref.read(clientType.notifier).state}\n${ref.read(clientMobileNumber.notifier).state}");
  }
}
