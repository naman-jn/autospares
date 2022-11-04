import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/models/custom_response/custom_response.dart';
import 'package:autospares_user/services/custom_exception_service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiBaseHelper {
  final String _baseUrl = "https://itksolutions.in/autostuffAPI/api";

  Future<CustomResponse> getClientData(String mobileNumber) async {
    CustomResponse responseJson;

    try {
      String mobile = Uri.encodeComponent(mobileNumber);

      final response = await http.get(
        Uri.parse(_baseUrl + "/getClient.php/?mobileNumber=$mobile"),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(ApiConstants.kSocketException);
    }
    return responseJson;
  }

  Future<CustomResponse> get(String url) async {
    CustomResponse responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(ApiConstants.kSocketException);
    }
    return responseJson;
  }

  Future<dynamic> post(
      {required String endpoint, required Object? body}) async {
    dynamic responseJson;
    try {
      final http.Response response = await http.post(
          Uri.parse(_baseUrl + endpoint),
          body: jsonEncode(body),
          headers: <String, String>{
            ApiConstants.kApiContentType: ApiConstants.kApplicationJson,
          });
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(ApiConstants.kSocketException);
    } catch (e) {
      debugPrint(e.toString());
      throw UnimplementedError();
    }
    return responseJson;
  }

  CustomResponse _returnResponse(http.Response response) {
    var responseJson = response.body;
    CustomResponse custromResponseJson =
        CustomResponse.fromJson(jsonDecode(responseJson));
    return custromResponseJson;
  }
}
