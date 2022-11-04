import 'package:autospares_user/styles/app_colors.dart';
import 'package:flutter/material.dart';

final Map<int, Color> ratingBarColorMap = {
  5: AppColors.darkGreen,
  4: AppColors.darkGreen,
  3: Colors.teal.shade300,
  2: Colors.yellow,
  1: Colors.red,
};
const Map<int, int> ratingValueMap = {
  1: 1,
  2: 3,
  3: 5,
  4: 10,
  5: 12,
};

class RatingBarBox extends StatelessWidget {
  const RatingBarBox({
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
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 15,
                    width: 175,
                    child: Row(
                      children: [
                        Text((5 - index).toString()),
                        const Icon(
                          Icons.star,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        RatingBar(
                          color: ratingBarColorMap[5 - index]!,
                          value: ratingValueMap[5 - index]! / 25,
                        ),
                        const SizedBox(width: 10),
                        Text((ratingValueMap[5 - index]).toString()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }));
  }
}

class RatingBar extends StatelessWidget {
  const RatingBar({
    Key? key,
    required this.color,
    required this.value,
  }) : super(key: key);
  final Color color;
  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: LinearProgressIndicator(
        backgroundColor: Colors.grey.shade200,
        color: color,
        value: value,
      ),
    );
  }
}
