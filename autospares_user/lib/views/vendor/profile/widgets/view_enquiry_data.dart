import 'package:autospares_user/styles/app_colors.dart';
import 'package:autospares_user/views/vendor/View_Enquiries/view_enquiry_screen.dart';
import 'package:flutter/material.dart';

class ViewEnquiryData extends StatelessWidget {
  const ViewEnquiryData({
    Key? key,
    required this.count,
    required this.text,
    required this.icon,
  }) : super(key: key);
  final int count;
  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewEnquiryDetailsScreen(),
          ),
        );
      },
      child: SizedBox(
        width: screenWidth * 0.35,
        child: Column(
          children: [
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w300),
            ),
            Row(
              children: [
                const Spacer(),
                Image.asset(
                  icon,
                  height: 18,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
