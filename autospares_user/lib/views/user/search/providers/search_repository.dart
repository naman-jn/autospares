import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/models/coordinates/coordinates.dart';
import 'package:autospares_user/models/custom_response/custom_response.dart';
import 'package:autospares_user/models/vendor/vendor.dart';
import 'package:autospares_user/services/api_service.dart';
import 'package:autospares_user/services/shared_preferences_service.dart';
import 'package:autospares_user/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchVendorDataProvider = Provider<VendorRepo>((ref) {
  return VendorRepo(reader: ref.read);
});

class VendorRepo {
  final Reader reader;
  late List<Vendor> vendorData;

  VendorRepo({
    required this.reader,
  });

  Future<void> initVendorList({required String queryParam}) async {
    try {
      vendorData = await _fetchVendorList(queryParam);
    } catch (e) {
      debugPrint("Error in get all vendor list api response: ${e.toString()}");
    }
  }

  Future<List<Vendor>> _fetchVendorList(String queryParam) async {
    Coordinates? userCoord =
        reader(userCoordinatesStateNotifier.notifier).state;
    String url =
        "/getAllVendors.php/?userLat=${userCoord!.lat}&userLong=${userCoord.long}&category=$queryParam";
    List<Vendor> tempList = [];
    CustomResponse response = await ApiBaseHelper().get(url);
    if (response.result == true) {
      tempList = List<Vendor>.from(response.data.map(
        (vendor) {
          return Vendor.fromJson(vendor);
        },
      ));
    } else {
      return [];
    }
    return tempList;
  }

  Future<List<Vendor>> fetchByCoordinates(String lat, String long) async {
    String url = "/getAllVendors.php/?userLat=$lat&userLong=$long";
    CustomResponse response = await ApiBaseHelper().get(url);
    if (response.result == true) {
      vendorData = List<Vendor>.from(response.data.map(
        (vendor) {
          return Vendor.fromJson(vendor);
        },
      ));
    } else {
      return [];
    }
    return vendorData;
  }
}
