import 'dart:math';
import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 500,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (context, index) {
            return const CommentBox();
          }),
    );
  }
}

class CommentBox extends StatelessWidget {
  const CommentBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Awesome Service"),
                const SizedBox(width: 13),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppAssetsPaths.darkGreyStar3x,
                        width: 12,
                      ),
                      Text(
                        (Random().nextInt(5) + 1).toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 13),
            const Text(
              "dataSanctus dolor gubergren rebum et takimata amet vero diam invidunt, diam eirmod aliquyam dolor justo et ipsum sea eirmod. Stet.",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 13),
            const Text(
              "- John Abraham",
              style: TextStyle(
                  fontWeight: FontWeight.w300, color: AppColors.darkBlue),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
}
