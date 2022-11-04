import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.topPadding = 0,
    this.height = 90,
  }) : super(key: key);
  final double height;
  final double topPadding;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: topPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              AppAssetsPaths.backIcon3x,
              color: Colors.white,
              height: 20,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(width: 28)
        ],
      ),
    );
  }
}
