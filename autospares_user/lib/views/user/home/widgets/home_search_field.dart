import 'package:autospares_user/configs/constants.dart';
import 'package:flutter/material.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(children: <Widget>[
        const SizedBox(
          width: 30,
        ),
        Image.asset(AppAssetsPaths.searchIcon1x),
        Expanded(
          child: TextField(
            onChanged: (search) {},
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              hintText: "What are you looking for?",
              hintStyle: TextStyle(
                color: Colors.blueGrey.withOpacity(0.5),
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ]),
    );
  }
}
