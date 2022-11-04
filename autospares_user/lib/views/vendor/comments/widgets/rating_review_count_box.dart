import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:flutter/material.dart';

class RatingReviewCountBox extends StatelessWidget {
  const RatingReviewCountBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth * 0.45,
      width: screenWidth * 0.435,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const Text(
            "4.0",
            style: TextStyle(
              color: AppColors.darkBlue,
              fontSize: 72,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 25,
            width: 125,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  int rating = 4;
                  if (rating <= 1 && index + 1 <= rating) {
                    return Image.asset(
                      AppAssetsPaths.redStar3x,
                      width: 24,
                    );
                  } else if (rating == 2 && index + 1 <= rating) {
                    return Image.asset(
                      AppAssetsPaths.yellowStar3x,
                      width: 24,
                    );
                  } else if (rating == 3 && index + 1 <= rating) {
                    return Image.asset(
                      AppAssetsPaths.lightGreenStar3x,
                      width: 24,
                    );
                  } else if (rating >= 4 && index + 1 <= rating) {
                    return Image.asset(
                      AppAssetsPaths.greenStar3x,
                      width: 24,
                    );
                  } else {
                    return Image.asset(
                      AppAssetsPaths.greywStar3x,
                      width: 24,
                    );
                  }
                }),
          ),
          const SizedBox(height: 12),
          const Text(
            "28 ratings & 12 reviews",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
