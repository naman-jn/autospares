// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'vendor.freezed.dart';
part 'vendor.g.dart';

@freezed
class Vendor with _$Vendor {
  const Vendor._();

  const factory Vendor({
    String? b_id,
    required String b_name,
    required String category,
    required String phone,
    required String image_url,
    required String location,
    required String longitude,
    required String latitude,
    required String contact_name,
    required String contact_mobile,
    @JsonKey(fromJson: Vendor.distanceStrFromJson) String? distance,
    String? created,
    String? location_id,
  }) = _Vendor;

  static distanceStrFromJson(int? source) {
    if (source == null) {
      return null;
    }
    if (source >= 1000) {
      return "${(source / 1000).toStringAsFixed(1)} km";
    } else {
      return "$source m";
    }
  }

  factory Vendor.empty() => const Vendor(
        b_id: "Undefined",
        b_name: "Undefined",
        category: "Undefined",
        phone: "Undefined",
        image_url: "Undefined",
        location: "Undefined",
        latitude: "Undefined",
        longitude: "Undefined",
        contact_name: "Undefined",
        contact_mobile: "Undefined",
        distance: "Undefined",
      );

  factory Vendor.fromJson(Map<String, dynamic> dataMap) =>
      _$VendorFromJson(dataMap);
}
