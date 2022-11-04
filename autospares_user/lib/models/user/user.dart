// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    String? id,
    required String name,
    required String mobile,
    required String email,
    required String pincode,
    required String city,
    String? created,
  }) = _User;

  factory User.empty() => const User(
        id: "Undefined",
        name: "Undefined",
        mobile: "Undefined",
        email: "Undefined",
        pincode: "Undefined",
        city: "Undefined",
        created: "Undefined",
      );

  factory User.fromJson(Map<String, dynamic> dataMap) =>
      _$UserFromJson(dataMap);
}
