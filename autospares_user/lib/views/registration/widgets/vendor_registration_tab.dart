// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:autospares_user/shared/providers.dart';
import 'package:autospares_user/shared/widgets/full_screen_loading.dart';
import 'package:autospares_user/views/registration/widgets/google_places_search_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/models/custom_response/custom_response.dart';
import 'package:autospares_user/services/api_service.dart';
import 'package:autospares_user/shared/widgets/custom_button.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final locProvider = StateProvider<String?>((ref) => null);

class VendorRegistrationTab extends StatefulWidget {
  const VendorRegistrationTab({Key? key}) : super(key: key);

  @override
  _VendorRegistrationTabState createState() => _VendorRegistrationTabState();
}

class _VendorRegistrationTabState extends State<VendorRegistrationTab> {
  final items = ['Petrol Bunk', 'Car Mechanic', 'Bike Mechanic', 'Auto Spares'];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController imageNameCtrl = TextEditingController();

  String? b_image_name;

  String? value;
  String? b_name;
  String? b_phone_number;
  String? b_location;
  String? b_location_id;
  double? b_latitude;
  double? b_longitude;
  String? contact_number;
  String? contact_name;
  String? image;

  Future<void> pickImage() async {
    var imageBytes = await ImagePicker().pickImage(source: ImageSource.gallery);
    File? imageFile = File(imageBytes!.path);
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    image = base64Image;
    setState(() {
      b_image_name = imageBytes.name.substring(12);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: FullScreenLoading(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          // height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Consumer(builder: (context, ref, _) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildTextField(label: "Business name", isString: true),
                    const SizedBox(height: 15),
                    _buildDropdown(),
                    const SizedBox(height: 25),
                    _buildTextField(
                        label: "Business phone number", isString: false),
                    const SizedBox(height: 20),
                    _buildImagePickerButton(),
                    const SizedBox(height: 25),
                    _buildBusinessLocationButton(
                        label: "Business location", ref: ref),
                    const SizedBox(height: 25),
                    _buildTextField(label: "Contact name", isString: true),
                    _buildTextField(
                        label: "Contact mobile number", isString: false),
                    CustomButton(
                      buttonText: "Create listing",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (image == null) {
                            toast(text: "Please upload an image");
                            return;
                          }
                          if (b_location == null) {
                            toast(text: "Please select your business location");
                            return;
                          }
                          if (value == null) {
                            toast(text: "Please select business category");
                            return;
                          }
                          Map vendorDataMap = {
                            "b_name": b_name!,
                            "category": value!,
                            "phone": "+91" + b_phone_number!,
                            "image": image,
                            "location": b_location,
                            "latitude": b_latitude,
                            "longitude": b_longitude,
                            "location_id": b_location_id,
                            "contact_name": contact_name!,
                            "contact_mobile": "+91" + contact_number!,
                          };
                          logger.v(vendorDataMap);
                          ref.watch(isLoadingStateProvider.notifier).state =
                              true;
                          CustomResponse res = await ApiBaseHelper().post(
                            endpoint: "/register.php/?type=vendor",
                            body: vendorDataMap,
                          );
                          ref.watch(isLoadingStateProvider.notifier).state =
                              false;

                          logger.i(
                              "register vendor api response:${res.toString()}");
                          if (res.result == true) {
                            ref.refresh(locProvider);
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                content: Text(
                                  res.message??'',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                content: Text(
                                  res.message??"Some error occured, Try again later",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        } else {
                          toast(text: "Some fields are empty or invalid!");
                        }
                      },
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  InkWell _buildImagePickerButton() {
    return InkWell(
      onTap: pickImage,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: DottedBorder(
          color: AppColors.darkBlue,
          borderType: BorderType.RRect,
          radius: const Radius.circular(60),
          dashPattern: const [8, 4],
          strokeWidth: 2,
          child: Center(
            child: Text(
              b_image_name ?? '+ Upload business image',
              style: const TextStyle(color: AppColors.darkBlue),
            ),
          ),
        ),
      ),
    );
  }

  DropdownButton<String> _buildDropdown() {
    return DropdownButton<String>(
      iconEnabledColor: Colors.black,
      value: value,
      underline: Container(
        height: 1.0,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade600,
              width: 1,
            ),
          ),
        ),
      ),
      hint: const Text('  Select category'),
      isExpanded: true,
      items: items.map(buildMenuItem).toList(),
      onChanged: (value) => setState(() {
        this.value = value;
      }),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));

  Widget _buildTextField({required String label, required bool isString}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          keyboardType: !isString ? TextInputType.number : TextInputType.text,
          validator: (value) {
            if (isString) {
              if (value == null || value.trim().isEmpty) {
                return "Invalid value";
              }
            } else {
              if (value == null || value.trim().isEmpty) {
                return "Invalid value";
              }
              if (value.length != 10) {
                return "Invalid phone number";
              }
            }
            return null;
          },
          onChanged: (value) {
            switch (label) {
              case "Business name":
                b_name = value;
                break;

              case "Business phone number":
                b_phone_number = value;
                break;

              case "Contact name":
                contact_name = value;
                break;

              case "Contact mobile number":
                contact_number = value;
                break;
            }
          },
          decoration: InputDecoration(
            hintText: label,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 25)
      ],
    );
  }

  Widget _buildBusinessLocationButton(
      {required String label, required WidgetRef ref}) {
    return InkWell(
      onTap: () async {
        Prediction pred = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GooglePlacesSearchBar(),
          ),
        );

        storeLocationData(pred, ref);
      },
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: DottedBorder(
          color: AppColors.darkBlue,
          borderType: BorderType.RRect,
          radius: const Radius.circular(60),
          dashPattern: const [8, 4],
          strokeWidth: 2,
          child: Consumer(builder: (context, innerRef, _) {
            final placeProvider = innerRef.watch(locProvider);
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  placeProvider ?? '+ Add Business Location',
                  textAlign: TextAlign.justify,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.darkBlue),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> storeLocationData(Prediction prediction, WidgetRef ref) async {
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    b_location = prediction.description;
    ref.read(locProvider.notifier).state = b_location;
    b_location_id = prediction.placeId;
    if (b_location_id != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(b_location_id!);
      b_latitude = detail.result.geometry?.location.lat;
      b_longitude = detail.result.geometry?.location.lng;
    }
  }
}
