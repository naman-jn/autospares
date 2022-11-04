import 'package:autospares_user/models/vendor/vendor.dart';
import 'package:autospares_user/services/api_service.dart';
import 'package:autospares_user/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchVendorDataProvider = Provider<VendorRepo>((ref) {
  return VendorRepo(reader: ref.read);
});

class VendorRepo {
  final Reader reader;
  late Vendor vendorData;

  VendorRepo({
    required this.reader,
  });

  Future<Vendor> fetchVendorData() async {
    String? mobileNumber = reader(clientMobileNumber.notifier).state;

    try {
      final responsClienteData =
          await ApiBaseHelper().getClientData(mobileNumber!);
      vendorData = Vendor.fromJson(responsClienteData.data);
      return vendorData;
    } catch (e) {
      debugPrint("Error in getClientData vendor api response: ${e.toString()}");
      throw UnimplementedError();
    }
  }
}
