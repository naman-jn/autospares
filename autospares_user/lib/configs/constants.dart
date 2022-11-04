import 'package:autospares_user/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class AppAssetsPaths {
  //Shared
  static const String backIcon3x = 'assets/icons/Back icon@3x.png';

  // login screen
  static const String autoStuffLogo3x = "assets/icons/Autostuff logo@3x.png";

  //Home Screen
  static const String searchIcon1x = 'assets/icons/Search icon.png';
  static const String autoSpa3x = 'assets/Auto spa icon@3x.png';
  static const String autoSpares3x = 'assets/Auto spares icon@3x.png';
  static const String bikeMechanic3x = 'assets/Bike mechanic icon@3x.png';
  static const String carMechanic3x = 'assets/Car mechanic icon@3x.png';
  static const String electricCharging3x =
      'assets/Electric charging icon@3x.png';
  static const String petrolBunk3x = 'assets/Petrol bunks icon@3x.png';

  //Search Screen
  static const String listViewIcon3x = 'assets/icons/list view icon@3x.png';
  static const String mapViewIcon3x = 'assets/icons/map view icon@3x.png';
  static const String callButton3x = 'assets/call@3x.png';
  static const String directionButton3x = 'assets/direction@3x.png';

  //* VENDOR
  //profile screen
  static const String yellowStarEmpty3x = 'assets/yellow star empty@3x.png';
  static const String yellowStarFilled3x = 'assets/yellow star filled@3x.png';
  static const String yellowStar3x = 'assets/yellow star@3x.png';
  static const String viewIcon3x = 'assets/icons/view icon@3x.png';
  static const String editIcon3x = 'assets/icons/edit icon@3x.png';
  static const String hamburgerIcon3x = 'assets/icons/Hamburger menu@3x.png';

  //comments screen
  static const String greywStar3x = 'assets/grey star@3x.png';
  static const String darkGreyStar3x = 'assets/dark grey star@3x.png';
  static const String greenStar3x = 'assets/green star@3x.png';
  static const String lightGreenStar3x = 'assets/light green star@3x.png';
  static const String redStar3x = 'assets/red star@3x.png';

  // view enquiry screen
  static const String mailIcon3x = 'assets/icons/mail icon@3x.png';
  static const String callIcon3x = 'assets/icons/call icon@3x.png';
}

class ApiConstants {
  static const String kApplicationJson = 'application/json; charset=UTF-8';
  static const String kApiContentType = 'Content-Type';
  static const String kErrorDuringCommunication =
      "Error During Communication: ";
  static const String kInvalidRequest = "Invalid Request: ";
  static const String kUnauthorised = "Unauthorised: ";
  static const String kInvalidInput = "Invalid Input: ";
  static const String kSocketException =
      "No Internet connection or invalid url";
}

class SharedPrefKeys {
  static const String kclientType = "clientType";
  static const String kMobile = "mobile";
  static const String kIsPermissionGranted = "isPermissionGranted";
  static const String hLatitude = "latitude";
  static const String hLongitude = "longitude";
}

var logger = Logger(
  filter: null,
  printer: PrettyPrinter(
    methodCount: 0, // number of method calls to be displayed
    errorMethodCount: 5, // number of method calls if stacktrace is provided
    lineLength: 20, // width of the output
    colors: false, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: false, // Should each log print contain a timestamp
    noBoxingByDefault: false, // show boxes for each log
    excludeBox: {Level.verbose: false}, //hide box for specific logs
  ),
);

void toast({required String text}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.darkBlue,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
