import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/models/vendor/vendor.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VendorListView extends StatelessWidget {
  const VendorListView({Key? key, required this.vendorList}) : super(key: key);
  final List<Vendor> vendorList;

  @override
  Widget build(BuildContext context) {
    if (vendorList.isEmpty) {
      return const Center(
        child: Text(
          "Oops! No record found",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }
    return Container(
      color: AppColors.darkBlue.withOpacity(0.2),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: vendorList.length,
        itemBuilder: (_, index) {
          return VendorDetailsCard(vendor: vendorList[index]);
        },
      ),
    );
  }
}

class VendorDetailsCard extends StatelessWidget {
  const VendorDetailsCard({Key? key, required this.vendor}) : super(key: key);
  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  vendor.b_name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                vendor.distance.toString(),
                style: const TextStyle(
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            vendor.location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              InkWell(
                onTap: () async {
                  String phone = "tel:${vendor.contact_mobile}";
                  logger.d(phone);
                  if (await canLaunchUrlString(phone)) {
                    await launchUrlString(phone);
                  } else {
                    throw 'Could not launch $phone';
                  }
                },
                child: Image.asset(
                  AppAssetsPaths.callButton3x,
                  height: 28,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () async {
                  String googleUrl = Uri.encodeFull(
                      "https://www.google.com/maps/search/?api=1&query=${vendor.latitude},${vendor.longitude}");
                  if (await canLaunchUrlString(googleUrl)) {
                    await launchUrlString(googleUrl);
                  } else {
                    throw 'Could not open the map.';
                  }
                },
                child: Image.asset(
                  AppAssetsPaths.directionButton3x,
                  height: 28,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
