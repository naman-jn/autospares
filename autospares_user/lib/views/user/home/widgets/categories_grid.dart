import 'package:autospares_user/configs/constants.dart';
import 'package:flutter/material.dart';
import 'categories_grid_item.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({
    Key? key,
  }) : super(key: key);

  final List categoriesList = const [
    {
      'name': 'Petrol Bunks',
      'assetPath': AppAssetsPaths.petrolBunk3x,
    },
    {
      'name': 'Car Mechanic',
      'assetPath': AppAssetsPaths.carMechanic3x,
    },
    {
      'name': 'Bike Mechanic',
      'assetPath': AppAssetsPaths.bikeMechanic3x,
    },
    {
      'name': 'Auto Spares',
      'assetPath': AppAssetsPaths.autoSpares3x,
    },
    {
      'name': 'Auto Spa',
      'assetPath': AppAssetsPaths.autoSpa3x,
    },
    {
      'name': 'Electric Charging',
      'assetPath': AppAssetsPaths.electricCharging3x,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 6,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, index) {
          Map category = categoriesList[index];
          return CategoriesGridItem(
            name: category['name'],
            assetPath: category['assetPath'],
          );
        });
  }
}
