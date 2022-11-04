import 'package:autospares_user/views/user/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesGridItem extends ConsumerWidget {
  final String name;

  final String assetPath;
  const CategoriesGridItem({
    Key? key,
    required this.name,
    required this.assetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(
              category: name,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Image.asset(
            assetPath,
            height: 70,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: const TextStyle(),
          ),
        ],
      ),
    );
  }
}
