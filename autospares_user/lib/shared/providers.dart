import 'package:autospares_user/models/coordinates/coordinates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clientType = StateProvider<String?>((ref) => null);

final clientMobileNumber = StateProvider<String?>((ref) => null);

final isLoadingStateProvider = StateProvider<bool>((ref) => false);

final userCoordinatesStateNotifier = StateProvider<Coordinates?>((ref) => null);
