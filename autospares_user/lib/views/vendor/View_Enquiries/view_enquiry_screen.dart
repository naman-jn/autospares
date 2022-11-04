import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/shared/widgets/custom_button2.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:flutter/material.dart';

class ViewEnquiryDetailsScreen extends StatelessWidget {
  const ViewEnquiryDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.darkBlue,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: AppColors.darkBlue,
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        color: Colors.blue.shade100.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    _buildTopSection(context),
                    _buildSearchListView(),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  _buildTopSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              AppAssetsPaths.backIcon3x,
              color: Colors.white,
              width: 24,
            ),
          ),
          const ViewEnquiryRadioButton(),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  _buildSearchListView() {
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (_, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              height: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Allie Grater - 99725 62744',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "alliegrater@gmail.com",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const CustomButton2(
                          icon: AppAssetsPaths.callIcon3x, buttonText: "Call"),
                      const SizedBox(width: 10),
                      const CustomButton2(
                          icon: AppAssetsPaths.mailIcon3x, buttonText: "Mail"),
                      const Spacer(),
                      Text(
                        "Chrompet",
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}

class ViewEnquiryRadioButton extends StatefulWidget {
  const ViewEnquiryRadioButton({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewEnquiryRadioButton> createState() => _ViewEnquiryRadioButtonState();
}

class _ViewEnquiryRadioButtonState extends State<ViewEnquiryRadioButton> {
  bool showViews = true;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 60,
      margin: const EdgeInsets.fromLTRB(22, 15, 22, 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                showViews = true;
              });
            },
            child: Container(
              width: screenWidth * 0.39,
              decoration: BoxDecoration(
                color: showViews ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(45),
              ),
              child: Center(
                child: Text(
                  "Views (49)",
                  style: TextStyle(
                      fontSize: 16,
                      color: showViews ? AppColors.darkBlue : Colors.white),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                showViews = false;
              });
            },
            child: Container(
              width: screenWidth * 0.39,
              decoration: BoxDecoration(
                color: showViews ? Colors.transparent : Colors.white,
                borderRadius: BorderRadius.circular(45),
              ),
              child: Center(
                child: Text(
                  "Enquiries (20)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: showViews ? Colors.white : AppColors.darkBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
