// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Vendor _$$_VendorFromJson(Map<String, dynamic> json) => _$_Vendor(
      b_id: json['b_id'] as String?,
      b_name: json['b_name'] as String,
      category: json['category'] as String,
      phone: json['phone'] as String,
      image_url: json['image_url'] as String,
      location: json['location'] as String,
      longitude: json['longitude'] as String,
      latitude: json['latitude'] as String,
      contact_name: json['contact_name'] as String,
      contact_mobile: json['contact_mobile'] as String,
      distance: Vendor.distanceStrFromJson(json['distance'] as int?),
      created: json['created'] as String?,
      location_id: json['location_id'] as String?,
    );

Map<String, dynamic> _$$_VendorToJson(_$_Vendor instance) => <String, dynamic>{
      'b_id': instance.b_id,
      'b_name': instance.b_name,
      'category': instance.category,
      'phone': instance.phone,
      'image_url': instance.image_url,
      'location': instance.location,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'contact_name': instance.contact_name,
      'contact_mobile': instance.contact_mobile,
      'distance': instance.distance,
      'created': instance.created,
      'location_id': instance.location_id,
    };
