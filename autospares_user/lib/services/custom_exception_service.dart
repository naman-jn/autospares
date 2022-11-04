// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:autospares_user/configs/constants.dart';

class AppException implements Exception {
  final _prefix;
  final _message;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return _prefix + _message;
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, ApiConstants.kErrorDuringCommunication);
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, ApiConstants.kInvalidRequest);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, ApiConstants.kUnauthorised);
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message, ApiConstants.kInvalidInput);
}
