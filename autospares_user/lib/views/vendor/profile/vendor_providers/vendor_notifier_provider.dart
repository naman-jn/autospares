import 'package:autospares_user/models/vendor/vendor.dart';
import 'package:autospares_user/views/vendor/profile/vendor_providers/vendor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vendorNotifierProvider =
    StateNotifierProvider<VendorNotifier, AsyncValue<Vendor>>((ref) {
  return VendorNotifier(
    read: ref.read,
  );
});

class VendorNotifier extends StateNotifier<AsyncValue<Vendor>> {
  final Reader read;

  VendorNotifier({
    required this.read,
  }) : super(const AsyncLoading()) {
    _initVendorDetails();
  }

  Future<void> _initVendorDetails() async {
    if (state.asData == null) {
      await read(fetchVendorDataProvider).fetchVendorData();
      state = AsyncData(read(fetchVendorDataProvider).vendorData);
    }
  }

  Future<void> addVendorDetails(Vendor vendorData) async {
    state = AsyncData(vendorData);
  }
}
