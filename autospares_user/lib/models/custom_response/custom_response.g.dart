// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'custom_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CustomResponse _$$_CustomResponseFromJson(Map<String, dynamic> json) =>
    _$_CustomResponse(
      result: json['result'] as bool,
      message: json['message'] as String?,
      data: json['data'],
      subData: json['subData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$_CustomResponseToJson(_$_CustomResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'message': instance.message,
      'data': instance.data,
      'subData': instance.subData,
    };
