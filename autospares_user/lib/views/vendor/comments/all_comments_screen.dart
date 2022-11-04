import 'package:autospares_user/shared/widgets/custom_appbar.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:autospares_user/views/vendor/comments/widgets/comment_list.dart';
import 'package:autospares_user/views/vendor/comments/widgets/rating_box.dart';
import 'package:autospares_user/views/vendor/comments/widgets/rating_review_count_box.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Container(
            color: Colors.blue.shade100.withOpacity(0.4),
            child: Column(
              children: [
                const CustomAppBar(title: "All comments"),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SizedBox(
                              width: screenWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  RatingReviewCountBox(),
                                  RatingBarBox(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const CommentsList()
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
