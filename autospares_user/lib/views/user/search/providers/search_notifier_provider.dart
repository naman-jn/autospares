import 'package:autospares_user/models/vendor/vendor.dart';
import 'package:autospares_user/views/user/search/providers/search_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchNotifierProvider = StateNotifierProvider.family<VendorListNotifier,
    AsyncValue<List<Vendor>>, String>((ref, category) {
  return VendorListNotifier(read: ref.read, category: category);
});

class VendorListNotifier extends StateNotifier<AsyncValue<List<Vendor>>> {
  final Reader read;
  final String category;

  VendorListNotifier({
    required this.read,
    required this.category,
  }) : super(
          const AsyncLoading(),
        ) {
    initVendorList();
  }

  Future<void> initVendorList() async {
    await read(fetchVendorDataProvider).initVendorList(queryParam: category);
    state = AsyncData(read(fetchVendorDataProvider).vendorData);
  }

  Future<void> getOtherVendors({required String lat, required String long}) async {
    await read(fetchVendorDataProvider).fetchByCoordinates(lat, long);
    state = AsyncData(read(fetchVendorDataProvider).vendorData);
  }
}
