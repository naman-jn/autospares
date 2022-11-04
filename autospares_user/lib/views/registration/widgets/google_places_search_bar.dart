import 'dart:developer';

import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/shared/providers.dart';
import 'package:autospares_user/shared/widgets/custom_appbar.dart';
import 'package:autospares_user/shared/widgets/full_screen_loading.dart';
import 'package:autospares_user/views/registration/widgets/uuid.dart';
import 'package:autospares_user/views/user/search/providers/search_notifier_provider.dart';
import 'package:autospares_user/views/user/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyDEMh8qk-IDMId-85Ag4OMtJa5mfzoagWk";

class GooglePlacesSearchBar extends PlacesAutocompleteWidget {
  final bool isUserSearching;
  GooglePlacesSearchBar({Key? key, this.isUserSearching = false})
      : super(
          key: key,
          apiKey: kGoogleApiKey,
          sessionToken: Uuid().generateV4(),
          language: "en",
          components: [Component(Component.country, "in")],
          types: [],
          strictbounds: false,
        );
  @override
  _GooglePlacesSearchBarState createState() =>
      _GooglePlacesSearchBarState(isUserSearching: isUserSearching);
}

class _GooglePlacesSearchBarState extends PlacesAutocompleteState {
  final bool isUserSearching;
  _GooglePlacesSearchBarState({
    required this.isUserSearching,
  });

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    //Handle errors in response
    debugPrint("Response Error : ${response.errorMessage}");
  }

  @override
  void onResponse(PlacesAutocompleteResponse? response) {
    super.onResponse(response);
    //Handle response success
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Consumer(builder: (context, ref, _) {
            return FullScreenLoading(
              child: Column(
                children: [
                  const CustomAppBar(
                    title: "Search location",
                    height: 60,
                    topPadding: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppBarPlacesAutoCompleteTextField(
                      textDecoration: InputDecoration(
                        hintText: 'Search',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        border: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                        enabledBorder: outlineInputBorder,
                      ),
                    ),
                  ),
                  Expanded(
                    child: PlacesAutocompleteResult(
                      onTap: (p) async {
                        FocusScope.of(context).unfocus();
                        logger.d(p.description);

                        try {
                          if (isUserSearching) {
                            await fetchLocationVendors(ref, p);
                          } else {
                            Navigator.pop(context, p);
                          }
                        } on Exception catch (e) {
                          logger.d(e);
                          ref.read(isLoadingStateProvider.notifier).state =
                              false;
                          toast(text: "Some error occurred, Please try again!");
                        }
                      },
                      logo: null,
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }

  Future<void> fetchLocationVendors(WidgetRef ref, Prediction p) async {
    ref.read(isLoadingStateProvider.notifier).state = true;
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    if (p.description != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);

      String? latitude = detail.result.geometry?.location.lat.toString();
      String? longitude = detail.result.geometry?.location.lng.toString();
      log(latitude.toString() + " -- " + longitude.toString());
      if (latitude != null && longitude != null) {
        ref
            .read(searchNotifierProvider("").notifier)
            .getOtherVendors(lat: latitude, long: longitude);
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SearchScreen(category: "")));
    }
    ref.read(isLoadingStateProvider.notifier).state = false;
  }

  final outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.grey),
  );
}
