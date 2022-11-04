import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/models/coordinates/coordinates.dart';
import 'package:autospares_user/models/user/user.dart';
import 'package:autospares_user/services/shared_preferences_service.dart';
import 'package:autospares_user/shared/providers.dart';
import 'package:autospares_user/shared/widgets/custom_loading.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:autospares_user/views/registration/widgets/vendor_registration_tab.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:autospares_user/views/login/login_screen.dart';
import 'package:autospares_user/views/registration/widgets/google_places_search_bar.dart';
import 'package:autospares_user/views/user/home/providers/user_providers/user_notifier_provider.dart';
import 'package:autospares_user/views/user/home/widgets/home_search_field.dart';
import 'package:autospares_user/views/user/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'widgets/categories_grid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final User userData;
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 600),
      () => determinePosition(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Future.delayed(
    //   const Duration(milliseconds: 600),
    //   () => determinePosition(),
    // );
  }

  Future<void> determinePosition() async {
    bool isServiceEnabled;
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      toast(text: "Location services are disabled.");
      return;
    }

    LocationPermission permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.denied) {
      logger.d("Location permission denied");
      permissionStatus = await Geolocator.requestPermission();
      if (permissionStatus == LocationPermission.denied) {
        //* if permission is denied, show a dialog and open permission request again
        permissionDeniedDialog(
          buttonText: "Grant Permission",
          title: "Permission Denied",
          content: "Location permissions are required for this app.",
          onTap: () {
            Navigator.pop(context);
            determinePosition();
          },
        );
        logger.i('Location permissions temperarily denied');
        return;
      }
    }

    if (permissionStatus == LocationPermission.deniedForever) {
      //* if permissions are denied forever, open dialog and navigate to app settings
      logger.d("Denied permanently");
      permissionDeniedDialog(
        buttonText: "Okay",
        title: "Permission denied",
        content:
            "Location permissions are required for this app. Please grant permission from settings",
        onTap: () async {
          if ((await Geolocator.checkPermission()) ==
              LocationPermission.whileInUse) {
            Navigator.pop(context);
            Geolocator.getCurrentPosition().then((location) {
              Coordinates userCoordinates =
                  Coordinates(lat: location.latitude, long: location.longitude);
              ref.read(userCoordinatesStateNotifier.notifier).state =
                  userCoordinates;
              logger.d(userCoordinates.toJson());

              toast(text: "permitted");
            });
          } else {
            AppSettings.openAppSettings();
          }
        },
      );
      logger.i(
          'Location permissions are permanently denied, we cannot request permissions. ');
      return;
    }
    Position location = await Geolocator.getCurrentPosition();
    Coordinates userCoordinates =
        Coordinates(lat: location.latitude, long: location.longitude);
    ref.read(userCoordinatesStateNotifier.notifier).state = userCoordinates;
    logger.d(userCoordinates.toJson());
  }

  Future<dynamic> permissionDeniedDialog(
      {required String title,
      required String buttonText,
      required String content,
      required Function() onTap}) {
    return showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(15),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.justify,
          ),
          actions: [
            InkWell(
              onTap: onTap,
              child: Container(
                height: 40,
                width: 145,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.darkBlue,
                ),
                child: Center(
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        AsyncValue<User> userProvider = ref.watch(userNotifierProvider);
        return userProvider.when(
            data: (data) {
              return Scaffold(
                backgroundColor: AppColors.darkBlue,
                body: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildTopSection(context, data.name),
                    ),
                    Expanded(
                      flex: 8,
                      child: _buildBottomSection(),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) {
              return const Text("Some error occured, We'll get back shortly");
            },
            loading: () => const LoadingScreen());
      },
    );
  }

  _buildTopSection(BuildContext context, String username) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(
            height: 45,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  SharedPrefsService().removeKey(SharedPrefKeys.kclientType);
                  SharedPrefsService().removeKey(SharedPrefKeys.kMobile);
                  ref.refresh(userNotifierProvider);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Hi $username!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(
                    category: "",
                  ),
                ),
              );
            },
            child: const IgnorePointer(child: HomeSearchField()),
          ),
        ],
      ),
    );
  }

  _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            const Text(
              'Top categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Expanded(child: CategoriesGrid()),
            InkWell(
              onTap: () async {
                bool isUserSearching=true;
                Prediction pred = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GooglePlacesSearchBar(isUserSearching: isUserSearching),
                  ),
                );
                fetchNewLocationVendors(pred, ref);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SearchScreen(category: "")));
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Still didn't find?",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchNewLocationVendors(
      Prediction prediction, WidgetRef ref) async {
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    if (prediction.description != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(prediction.description!);

      String? latitude = detail.result.geometry?.location.lat.toString();
      String? longitude = detail.result.geometry?.location.lng.toString();
      log(latitude.toString() + " -- " + longitude.toString());
      if (latitude != null && longitude != null) {
        await SharedPrefsService()
            .setStringValue(SharedPrefKeys.hLatitude, latitude);
        await SharedPrefsService()
            .setStringValue(SharedPrefKeys.hLongitude, longitude);
      }
    }
  }
}
