import 'package:autospares_user/models/user/user.dart';
import 'package:autospares_user/views/user/home/providers/user_providers/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<User>>((ref) {
  return UserNotifier(
    read: ref.read,
  );
});

class UserNotifier extends StateNotifier<AsyncValue<User>> {
  final Reader read;

  UserNotifier({
    required this.read,
  }) : super(const AsyncLoading()) {
    _initUserDetails();
  }

  Future<void> _initUserDetails() async {
    if (state.asData == null) {
      await read(fetchUserDataProvider).fetchUserData();
      state = AsyncData(read(fetchUserDataProvider).userData);
    }
  }

  Future<void> addUserDetails(User userData) async {
    state = AsyncData(userData);
  }
}
