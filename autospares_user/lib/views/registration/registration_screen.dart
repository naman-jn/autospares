import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:autospares_user/views/registration/widgets/user_registration_tab.dart';
import 'package:autospares_user/views/registration/widgets/vendor_registration_tab.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  PageController pageController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAppBar(),
          _buildToggleSwitch(),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                UserRegistrationTab(),
                VendorRegistrationTab(),
              ],
            ),
          ),
        ],
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
            'Registration',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            width: 44,
          ),
        ],
      ),
    );
  }

  Container _buildToggleSwitch() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                pageIndex = 0;
              });
              pageController.jumpToPage(
                0,
              );
            },
            child: _buildToggleItem(index: 0, title: 'User'),
          ),
          InkWell(
            onTap: () {
              setState(() {
                pageIndex = 1;
              });
              pageController.jumpToPage(
                1,
              );
            },
            child: _buildToggleItem(index: 1, title: 'Vendor'),
          )
        ],
      ),
    );
  }

  _buildToggleItem({
    required int index,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      decoration: BoxDecoration(
        color: pageIndex == index ? AppColors.darkBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(title,
          style: TextStyle(
            color: pageIndex == index ? Colors.white : Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          )),
    );
  }
}
