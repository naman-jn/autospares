import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:autospares_user/views/vendor/profile/widgets/view_enquiry_data.dart';
import 'package:flutter/material.dart';

class BottomCard extends StatelessWidget {
  const BottomCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight * 0.48,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: const [
            SizedBox(height: 65),
            ViewEnquiryStrip(),
          ],
        ),
      ),
    );
  }
}

class ViewEnquiryStrip extends StatelessWidget {
  const ViewEnquiryStrip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const ViewEnquiryData(
          count: 49,
          text: " VIEWS",
          icon: AppAssetsPaths.viewIcon3x,
        ),
        Container(
          height: 105,
          width: 1,
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          color: Colors.black,
        ),
        const ViewEnquiryData(
          count: 20,
          text: " ENQUIRIES",
          icon: AppAssetsPaths.callIcon3x,
        ),
      ],
    );
  }
}
