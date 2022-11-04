import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/models/custom_response/custom_response.dart';
import 'package:autospares_user/services/api_service.dart';
import 'package:autospares_user/shared/providers.dart';
import 'package:autospares_user/shared/widgets/custom_button.dart';
import 'package:autospares_user/shared/widgets/full_screen_loading.dart';
import 'package:autospares_user/views/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRegistrationTab extends StatefulWidget {
  const UserRegistrationTab({Key? key}) : super(key: key);

  @override
  State<UserRegistrationTab> createState() => _UserRegistrationTabState();
}

class _UserRegistrationTabState extends State<UserRegistrationTab> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? mobile;
  String? email;
  String? pincode;
  String? city;

  @override
  Widget build(BuildContext context) {
    final double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: FullScreenLoading(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: screenheight - 150,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildTextField(label: "Name", isString: true),
                  _buildTextField(label: "Mobile number", isString: false),
                  _buildTextField(label: "Email", isString: true),
                  _buildTextField(label: "Pincode", isString: false),
                  _buildTextField(label: "City", isString: true),
                  Consumer(builder: (context, ref, _) {
                    return CustomButton(
                      buttonText: "Create account",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          Map userDataMap = {
                            "name": name!,
                            "mobile": "+91" + mobile!,
                            "email": email!,
                            "pincode": pincode!,
                            "city": city!,
                          };
                          ref.read(isLoadingStateProvider.notifier).state =
                              true;
                          CustomResponse res = await ApiBaseHelper().post(
                            endpoint: "/register.php/?type=user",
                            body: userDataMap,
                          );
                          logger.i(
                              "register user api response: ${res.toString()}");
                          ref.read(isLoadingStateProvider.notifier).state =
                              false;

                          if (res.result == true) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          } else {
                            toast(text: "Some fields are empty or invalid!");
                          }
                        }
                      },
                      width: double.infinity,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
              } else if (label == "Email") {
                bool isEmailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(email!);
                if (!isEmailValid) {
                  return "Invalid Email";
                }
              }
            } else {
              if (value == null || value.trim().isEmpty) {
                return "Invalid value";
              }
              if (label == "Pincode" && value.length != 6) {
                return "Invalid pincode";
              }
              if (label == "Mobile number" && value.length != 10) {
                return "Invalid phone number";
              }
            }
            return null;
          },
          onChanged: (value) {
            switch (label) {
              case "Name":
                name = value;
                break;

              case "Mobile number":
                mobile = value;
                break;

              case "Email":
                email = value;
                break;

              case "Pincode":
                pincode = value;
                break;

              case "City":
                city = value;
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
}
