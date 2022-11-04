// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_response.freezed.dart';
part 'custom_response.g.dart';

@freezed
class CustomResponse with _$CustomResponse {
  const CustomResponse._();

  const factory CustomResponse({
    required bool result,
    String? message,
    dynamic data,
    Map<String, dynamic>? subData,
  }) = _CustomResponse;

  factory CustomResponse.empty() => const CustomResponse(
        result: false,
        message: "Undefined",
        data: "Undefined",
      );

  factory CustomResponse.fromJson(Map<String, dynamic> dataMap) =>
      _$CustomResponseFromJson(dataMap);
}
