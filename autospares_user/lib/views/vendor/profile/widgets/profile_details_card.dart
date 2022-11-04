import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/models/vendor/vendor.dart';
import 'package:autospares_user/views/vendor/comments/all_comments_screen.dart';
import 'package:flutter/material.dart';

class ProfileDetailsWidget extends StatelessWidget {
  const ProfileDetailsWidget({
    Key? key,
    required this.vendorData,
    required this.onTapCallBack,
  }) : super(key: key);
  final Vendor vendorData;
  final Function() onTapCallBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              InkWell(
                onTap: onTapCallBack,
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.logout,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  AppAssetsPaths.hamburgerIcon3x,
                  height: 18,
                ),
              ),
            ],
          ),
          Container(
              height: 135,
              width: 135,
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    vendorData.image_url,
                  ))),
          const SizedBox(height: 30),
          Text(
            vendorData.b_name,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 22,
                width: 120,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      int rating = 4;
                      if (index + 1 <= rating) {
                        return Image.asset(
                          AppAssetsPaths.yellowStarFilled3x,
                          height: 12,
                        );
                      } else {
                        return Image.asset(
                          AppAssetsPaths.yellowStarEmpty3x,
                          height: 12,
                        );
                      }
                    }),
              ),
              const Text(
                "4.0",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommentsScreen()),
              );
            },
            child: const Text(
              "View comments",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }
}
