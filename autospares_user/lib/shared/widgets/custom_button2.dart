import 'package:autospares_user/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton2 extends StatelessWidget {
  const CustomButton2({
    Key? key,
    required this.icon,
    required this.buttonText,
  }) : super(key: key);
  final String icon;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
          border: Border.all(
            color: AppColors.darkGreen,
            width: 1,
          )),
      child: Row(
        children: [
          Image.asset(
            icon,
            color: Colors.grey.shade800,
            height: 14,
          ),
          const SizedBox(width: 8),
          Text(
            buttonText,
            style: TextStyle(
              color: Colors.grey.shade800,
            ),
          )
        ],
      ),
    );
  }
}
