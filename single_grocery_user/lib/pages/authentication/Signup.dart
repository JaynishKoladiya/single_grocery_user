// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_const_constructors, must_be_immutable, file_names, use_key_in_widget_constructors, avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/pages/authentication/Otp.dart';
import 'package:singlegrocery/pages/authentication/tearms_condition.dart';
import 'package:singlegrocery/model/authentication/signupmodel.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:singlegrocery/utils/validator.dart/validator.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:dio/dio.dart';
import '../../config/api/API.dart';

class Signup extends StatefulWidget {
  String? emailid;
  String? name;
  String? type;
  String? id;

  @override
  State<Signup> createState() => _SignupState();
  Signup([
    this.emailid,
    this.name,
    this.type,
    this.id,
  ]);
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final Email = TextEditingController();
  final Name = TextEditingController();
  final Mobile = TextEditingController();
  final Refcode = TextEditingController();
  final Password = TextEditingController();
  bool _obscureText = true;
  String? countrycode = "91";

  bool isChecked = false;
  Signupmodel? Signupdata;
  String? Googletoken;
  String? registertype;

  SignupAPI(type) async {
    try {
      loader.showLoading();
      var map = registertype == "mobile"
          ? {
              "name": Name.text.toString(),
              "email": Email.text.toString(),
              "mobile": "+${countrycode! + Mobile.text.toString()}",
              "referral_code": Refcode.text.toString(),
              "login_type": type,
              "google_id": "",
              "facebook_id": "",
              "register_type": "email",
              "token": Googletoken
            }
          : {
              "name": Name.text.toString(),
              "email": Email.text.toString(),
              "password": Password.text.toString(),
              "mobile": "+${countrycode! + Mobile.text.toString()}",
              "referral_code": Refcode.text.toString(),
              "login_type": type,
              "google_id": type == "google" ? widget.id : "",
              "facebook_id": type == "facebook" ? widget.id : "",
              "register_type": "email",
              "token": Googletoken
            };
      print(map);
      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.register, data: map);

      var finallist = await response.data;
      Signupdata = Signupmodel.fromJson(finallist);
      print(response);
      loader.hideLoading();

      if (Signupdata!.status == 1) {
        print(Signupdata);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Otp(
              registertype == "mobile"
                  ? "+${countrycode! + Mobile.text.toString()}"
                  : Email.value.text,
              Signupdata!.otp.toString(),
            ),
          ),
        );
      } else if (Signupdata!.status == 0) {
        loader.showErroDialog(description: Signupdata!.message);
        print(Signupdata!.message);
      } else if (Signupdata!.status == 3) {
        Get.to(
          () => Otp(
            registertype == "mobile"
                ? "+${countrycode! + Mobile.text.toString()}"
                : Email.value.text,
            Signupdata!.otp.toString(),
          ),
        );
      } else {
        loader.showErroDialog(description: Signupdata!.message);
      }
    } catch (e) {
      print(e);
    }
  }

  token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        registertype = prefs.getString(App_check_addons);
        print(registertype);
      },
    );
    await FirebaseMessaging.instance.getToken().then(
      (token) {
        print(token);
        print("token");
        Googletoken = token!;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    token();
    if (widget.emailid != null) {
      setState(
        () {
          Email.value = TextEditingValue(text: widget.emailid!);
          Name.value = TextEditingValue(text: widget.name!);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.purple;
      }
      return Colors.black;
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Form(
          key: _formkey,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: color.primarycolor,
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.all(5.w),
                color: color.white,
                elevation: 3,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 4.w, top: 2.h),
                      child: Text(
                        LocaleKeys.Signup.tr(),
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins_Bold',color: color.primarycolor),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(
                        left: 4.w,
                        right: 4.w,
                        top: 0.8.h,
                      ),
                      child: Text(
                        LocaleKeys
                                .Create_an_account_so_you_can_order_your_favourite_product_faster
                            .tr(),
                        style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4.w, top: 2.h, right: 4.w),
                      child: Center(
                        child: TextFormField(
                          validator: (value) => Validators.validateName(
                              value!, LocaleKeys.First_name.tr()),
                          cursorColor: color.grey,
                          textInputAction: TextInputAction.next,
                          controller: Name,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color.primarycolor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: color.primarycolor),
                            ),
                            border: OutlineInputBorder(),
                            hintText: (LocaleKeys.Full_name.tr()),
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 4.w,
                        top: 2.h,
                        right: 4.w,
                      ),
                      child: Center(
                        child: TextFormField(
                          validator: (value) => Validators.validateEmail(
                            value!,
                          ),
                          readOnly: widget.emailid != null ? true : false,
                          cursorColor: color.grey,
                          textInputAction: TextInputAction.next,
                          controller: Email,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color.primarycolor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color.primarycolor,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: LocaleKeys.Email.tr(),
                            hintStyle:
                                TextStyle(fontFamily: 'Poppins', fontSize: 10.sp),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4.w, top: 2.h, right: 4.w),
                      child: Center(
                        child: IntlPhoneField(
                          cursorColor: color.grey,
                          controller: Mobile,
                          showCountryFlag: false,
                          disableLengthCheck: true,
                          pickerDialogStyle: PickerDialogStyle(
                            searchFieldCursorColor: color.primarycolor,
                            searchFieldInputDecoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color.primarycolor))
                            )
                          ),
                          dropdownIcon: Icon(Icons.arrow_drop_down,color: color.primarycolor,),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.Mobile.tr(),
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.sp,
                            ),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: color.primarycolor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color.primarycolor,
                              ),
                            ),
                          ),
                          initialCountryCode: 'IN',
                          onCountryChanged: (value) {
                            countrycode = value.dialCode;
                            print(countrycode);
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4.w, top: 2.h, right: 4.w),
                      child: Center(
                        child: TextField(
                          cursorColor: color.grey,
                          controller: Refcode,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color.primarycolor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color.primarycolor,
                              ),
                            ),
                            hintText: LocaleKeys.Referral_code_Optional.tr(),
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (registertype == "email" && widget.emailid == null) ...[
                      Container(
                        margin: EdgeInsets.only(left: 4.w, top: 2.h, right: 4.w),
                        child: Center(
                          child: TextFormField(
                            cursorColor: color.grey,
                            validator: (value) =>
                                Validators.validatePassword(value!),
                            controller: Password,
                            textInputAction: TextInputAction.done,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: color.primarycolor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: color.primarycolor,
                                ),
                              ),
                              border: OutlineInputBorder(),
                              hintText: LocaleKeys.Password.tr(),
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 1.w,
                        ),
                        Checkbox(
                          checkColor: color.primarycolor,
                          side: BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                          fillColor: MaterialStateProperty.all(color.white),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(
                              () {
                                isChecked = value!;
                              },
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => teamscondition());
                          },
                          child: Text(
                            LocaleKeys.I_accept_the_terms_conditions.tr(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4.w, right: 4.w),
                      height: 6.5.h,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            if (isChecked == false) {
                              loader.showErroDialog(
                                  description: LocaleKeys
                                      .Please_select_terms_conditions.tr());
                            } else {
                              if (widget.type == null && registertype == "email") {
                                SignupAPI("email");
                                print(1);
                              } else if (widget.type == "google") {
                                SignupAPI("google");
                                print(2);
                              } else if (widget.type == "facebook") {
                                SignupAPI("facebook");
                                print(3);
                              } else if (registertype == "mobile") {
                                // print(4);
                                SignupAPI("email");
                              }
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: color.primarycolor,
                        ),
                        child: Text(
                          LocaleKeys.Signup.tr(),
                          style: TextStyle(
                              fontFamily: 'Poppins_Bold',
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13.sp),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 3.h,bottom: 3.h),
                          child: Text(
                            '${LocaleKeys.Already_have_an_account.tr()}?  ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.5.sp,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 3.h,bottom: 4.h),
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              LocaleKeys.Login.tr(),
                              style: TextStyle(
                                  fontFamily: 'Poppins_semiBold',
                                  fontSize: 12.sp,
                                  color: color.primarycolor
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
