import 'dart:math';
import 'package:autospares_user/models/coordinates/coordinates.dart';
import 'package:autospares_user/models/vendor/vendor.dart';
import 'package:autospares_user/views/user/search/widgets/vendor_listview.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapsBuildingProvider = StateProvider<bool>((ref) => true);

class VendorMapView extends ConsumerStatefulWidget {
  final List<Vendor> vendorList;
  const VendorMapView({required this.vendorList, Key? key}) : super(key: key);
  @override
  _VendorMapViewState createState() => _VendorMapViewState();
}

class _VendorMapViewState extends ConsumerState<VendorMapView>
    with AutomaticKeepAliveClientMixin {
  late LatLng _kMapCenter;

  late CameraPosition _kInitialPosition;

  late Set<Marker> markers;

  late final List<Coordinates> coordinatesList;

  late final SwiperController _swiperController;

  int _highlightedIndex = 0;
  @override
  void initState() {
    super.initState();
    coordinatesList = widget.vendorList
        .map(
          (vendor) => Coordinates(
            lat: double.parse(vendor.latitude),
            long: double.parse(vendor.longitude),
          ),
        )
        .toList();
    _swiperController = SwiperController();
    setMarkers();
  }

  setMarkers() {
    bool hasMarkers = false;

    if (coordinatesList.isNotEmpty) {
      hasMarkers = true;
    }

    if (hasMarkers) {
      final firstMarker = coordinatesList.first;
      final lat = firstMarker.lat;
      final long = firstMarker.long;
      _kMapCenter = LatLng(lat, long);
    } else {
      _kMapCenter = const LatLng(20.5937, 78.9629);
    }

    _kInitialPosition = CameraPosition(target: _kMapCenter, zoom: 0);

    if (hasMarkers) {
      markers = List.generate(
        coordinatesList.length,
        (index) => Marker(
          icon: index == _highlightedIndex
              ? BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                )
              : BitmapDescriptor.defaultMarker,
          markerId: MarkerId(
            index.toString(),
          ),
          position:
              LatLng(coordinatesList[index].lat, coordinatesList[index].long),
          infoWindow: InfoWindow(
              title: widget.vendorList[index].b_name,
              onTap: () {
                if (_highlightedIndex == index) return;
                setState(() {
                  _swiperController.move(index);
                });
              }),
        ),
      ).toSet();
    } else {
      markers = {};
    }
  }

  LatLngBounds getBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    //to bound markers inside mobile device
    var height = topMost - bottomMost;
    var width = rightMost - leftMost;
    if (height > 61) bottomMost = topMost - 61;
    if (width > 90) leftMost = rightMost - 90;

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          Consumer(builder: (context, ref, child) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 20),
                  initialCameraPosition: _kInitialPosition,
                  markers: markers.toSet(),
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  onMapCreated: (GoogleMapController controller) async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    if (markers.isNotEmpty) {
                      controller.animateCamera(CameraUpdate.newLatLngBounds(
                          getBounds(markers.toList()), 100));
                    }
                    ref.read(mapsBuildingProvider.notifier).state = false;
                  },
                ),
                SizedBox(
                  height: 155,
                  width: MediaQuery.of(context).size.width,
                  child: Swiper(
                    controller: _swiperController,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 140,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: VendorDetailsCard(
                          vendor: widget.vendorList[index],
                        ),
                      );
                    },
                    onIndexChanged: (index) {
                      if (_highlightedIndex == index) return;
                      setState(() {
                        _highlightedIndex = index;
                        setMarkers();
                      });
                    },
                    itemCount: widget.vendorList.length,
                    viewportFraction: 0.8,
                    // pagination: const SwiperPagination(),
                    layout: SwiperLayout.DEFAULT,
                    itemHeight: 155,
                    itemWidth: MediaQuery.of(context).size.width * 0.85,
                  ),
                ),
              ],
            );
          }),
          Consumer(builder: (context, ref, child) {
            bool isMapBuilding = ref.watch(mapsBuildingProvider);

            return isMapBuilding
                ? Container(
                    color: Colors.white,
                    height: double.infinity,
                    width: double.infinity,
                  )
                : const SizedBox();
          })
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
