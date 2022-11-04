import 'package:autospares_user/shared/providers.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FullScreenLoading extends StatelessWidget {
  const FullScreenLoading({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      bool isLoading = ref.watch(isLoadingStateProvider);
      return Stack(
        children: [
          (isLoading)
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: const Center(
                    child: SpinKitCircle(
                      color: AppColors.darkBlue,
                      size: 55.0,
                    ),
                  ),
                )
              : const SizedBox(),
          IgnorePointer(
            ignoring: isLoading,
            child: Opacity(
              opacity: isLoading ? 0.3 : 1,
              child: child,
            ),
          ),
        ],
      );
    });
  }
}
