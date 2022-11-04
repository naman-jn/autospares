import 'package:autospares_user/models/user/user.dart';
import 'package:autospares_user/services/api_service.dart';
import 'package:autospares_user/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchUserDataProvider = Provider<UserRepo>((ref) {
  return UserRepo(reader: ref.read);
});

class UserRepo {
  final Reader reader;
  late User userData;

  UserRepo({
    required this.reader,
  });

  Future<User> fetchUserData() async {
    String? mobileNumber = reader(clientMobileNumber.notifier).state;

    try {
      if (mobileNumber != null) {
        final responsClientData =
            await ApiBaseHelper().getClientData(mobileNumber);
        userData = User.fromJson(responsClientData.data);
      }
    } catch (e) {
      debugPrint("Error in getClientData user api response: ${e.toString()}");
    }
    return userData;
  }
}
