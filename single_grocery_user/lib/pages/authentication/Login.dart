// ignore_for_file: file_names, use_build_context_synchronously, unused_field, prefer_final_fields, non_constant_identifier_names, unused_element,   prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/pages/authentication/Otp.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:singlegrocery/model/authentication/loginmodel.dart';
import 'package:singlegrocery/model/authentication/signupmodel.dart';
import 'package:singlegrocery/theme/ThemeModel.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:singlegrocery/utils/validator.dart/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../config/api/API.dart';
import '../../theme/ThemeModel.dart';
import '../Home/homepage.dart';
import 'Forgotpassword.dart';
import 'Signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    token();
  }

  String? Logintype = "";
  String? countrycode = "91";

  token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Logintype = prefs.getString(App_check_addons);

      if (DefaultApi.environment == "sendbox") {
        email.value = TextEditingValue(text: "user@gmail.com");
        password.value = TextEditingValue(text: "123456");
      }
    });
    await FirebaseMessaging.instance.getToken().then((token) {
      if (kDebugMode) {
        print(token);
      }

      Googletoken = token!;
    });
  }

  GoogleSignInAccount? user;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Map? userdata;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  final email = TextEditingController();
  final mobile = TextEditingController();
  final password = TextEditingController();
  Loginmodel? jsondata;
  Map<String, dynamic>? _userData;
  bool _loggedIn = true;
  String _name = "You're not logged in";
  AccessToken? _accessToken;
  String? Googletoken;

  _FBlogin() async {
    final LoginResult result = await FacebookAuth.instance.login(
        // permissions: [
        //   //   "id",
        //   //   "first_name",
        //   //   "last_name",
        //   "public_profile",
        //   "email",
        // ],
        );
    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      Map userdata = await FacebookAuth.instance.getUserData();
      if (kDebugMode) {
        print(userdata);
      }
      // _userData = userdata;

      _FBlogout();

      registerAPIforfb(userdata["email"], userdata["name"], userdata["id"]);
    } else {}
  }

  registerAPIforfb(email, name, id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loader.showLoading();
    var map = {
      "name": name,
      "email": email,
      "mobile": "",
      "token": Googletoken,
      "facebook_id": id,
      "login_type": "facebook",
    };
    var response =
        await Dio().post(DefaultApi.appUrl + PostAPI.register, data: map);
    Signupmodel data = Signupmodel.fromJson(response.data);
    loader.hideLoading();
    if (data.status == 1) {
      prefs.setString(UD_user_id, data.data!.id.toString());
      prefs.setString(UD_user_name, data.data!.name.toString());
      prefs.setString(UD_user_mobile, data.data!.mobile.toString());
      prefs.setString(UD_user_email, data.data!.email.toString());
      prefs.setString(UD_user_profileimage, data.data!.profileImage.toString());
      prefs.setString(UD_user_logintype, data.data!.loginType.toString());
      Get.to(() => Homepage(0));
    } else if (data.status == 2) {
      Get.to(() => Signup(email, name, "facebook", id.toString()));
    } else if (data.status == 3) {
      Get.to(() => Otp(email, data.otp.toString()));
    } else {
      loader.showErroDialog(description: data.message);
    }
  }

  _FBlogout() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
  }

  login() async {
    try {
      loader.showLoading();

      var map = Logintype == "mobile"
          ? {
              "mobile": "+${countrycode! + mobile.value.text}",
              "token": Googletoken,
            }
          : {
              "password": password.text.toString(),
              "email": email.text.toString(),
              "token": Googletoken
            };

      var response = await Dio().post(DefaultApi.appUrl + PostAPI.loginAPi, data: map,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode! > 300) {
        loader.showErroDialog(description: "serrr");
      }
      print("reeeee :: :: ${response.data}");
      var finallist = await response.data;

      jsondata = Loginmodel.fromJson(finallist);

      loader.hideLoading();

      if (jsondata!.status == 1) {
        password.clear();
        email.clear();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(UD_user_id, jsondata!.data!.id.toString());
        prefs.setString(UD_user_name, jsondata!.data!.name.toString());
        prefs.setString(UD_user_mobile, jsondata!.data!.mobile.toString());
        prefs.setString(UD_user_email, jsondata!.data!.email.toString());
        prefs.setString(
            UD_user_logintype, jsondata!.data!.loginType.toString());
        prefs.setString(UD_user_wallet, jsondata!.data!.wallet.toString());
        prefs.setString(
            UD_user_isnotification, jsondata!.data!.isNotification.toString());
        prefs.setString(UD_user_ismail, jsondata!.data!.isMail.toString());
        prefs.setString(
            UD_user_refer_code, jsondata!.data!.referralCode.toString());
        prefs.setString(
            UD_user_profileimage, jsondata!.data!.profileImage.toString());

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage(0)),
        );
      } else if (jsondata!.status == 2) {
        // password.clear();
        // email.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Otp(
              Logintype == "mobile"
                  ? "+${countrycode! + mobile.value.text}"
                  : email.text.toString(),
              jsondata!.otp.toString(),
            ),
          ),
        );
      } else {
        loader.showErroDialog(description: jsondata!.message);
      }

      return jsondata;
    } on DioError catch (e) {
      loader.showErroDialog(description: "server time  out");

      if (e.type == DioErrorType.connectTimeout) {
        loader.showErroDialog(description: "server time  out");
      }
      loader.hideLoading();

      // loader.showErroDialog(description: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ThemeModel themenofier, child) {
          return SafeArea(
            child: SafeArea(
              child: WillPopScope(
                onWillPop: () async {
                  final value = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Alert",
                          style: TextStyle(),
                        ),
                        content: Text(
                          "are you sure to exit",
                          style: TextStyle(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(LocaleKeys.No.tr()),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text(LocaleKeys.Yes.tr()),
                          ),
                        ],
                      );
                    },
                  );
                  if (value != null) {
                    return Future.value(value);
                  } else {
                    return Future.value(false);
                  }
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Container(
                    width: double.infinity,
                    height: double.infinity,
                    //color: themenofier.isdark ? Colors.black : color.primarycolor,
                    color: themenofier.isdark ? Colors.black : color.primarycolor,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.topRight,
                                // decoration: BoxDecoration(color: themenofier.isdark ? Colors.black : color.primarycolor),
                                height: 4.h,
                                margin: EdgeInsets.all(5.w),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Homepage(0)),
                                    );
                                  },
                                  child: Text(
                                    LocaleKeys.Skip_continue.tr(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: color.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp),
                                  ),
                                )),
                            Image.asset("Icons/logo-white.png", height: 20.h,
                              width: 50.w,),
                            Card(
                              margin: EdgeInsets.all(5.w),
                              color: color.white,
                              elevation: 3,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin:
                                    EdgeInsets.only(
                                        left: 4.5.w, top: 3.5.h, bottom: 1.h),
                                    child: Text(
                                      LocaleKeys.Login.tr(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 23.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins_Bold',
                                          color: themenofier.isdark ? Colors.black : color.primarycolor),
                                    ),
                                  ),
                                  // Container(
                                  //   alignment: Alignment.topLeft,
                                  //   margin:
                                  //   EdgeInsets.only(left: 4.5.w, top: 3.5.h, bottom: 1.h),
                                  //   child: Text(
                                  //     LocaleKeys.Loginst.tr(),
                                  //     overflow: TextOverflow.ellipsis,
                                  //     maxLines: 1,
                                  //     style: TextStyle(
                                  //         fontSize: 12.sp,
                                  //         fontFamily: 'Poppins_Bold'),
                                  //   ),
                                  // ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                      left: 4.5.w,
                                    ),
                                    child: Text(
                                      LocaleKeys.Loginst.tr(),
                                      // LocaleKeys.Signin_to_your_account,
                                      style: TextStyle(fontSize: 12.sp,
                                          fontFamily: 'Poppins',
                                          color:  Colors.black ),
                                    ),
                                  ),
                                  if (Logintype == "mobile") ...[
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 2.5.h,
                                        bottom: 2.5.h,
                                        left: 4.w,
                                        right: 4.w,
                                      ),
                                      child: Center(
                                        child: IntlPhoneField(
                                          cursorColor: themenofier.isdark ? Colors.black : color.primarycolor,
                                          disableLengthCheck: true,
                                          controller: mobile,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: LocaleKeys.Phoneno.tr(),
                                            border: const OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: themenofier.isdark ? Colors.black : color.primarycolor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: themenofier.isdark ? Colors.black : color.primarycolor),
                                            ),
                                          ),
                                          initialCountryCode: 'IN',
                                          onCountryChanged: (value) {
                                            countrycode = value.dialCode;
                                          },
                                        ),
                                      ),
                                    ),
                                  ] else
                                    ...[
                                      Container(
                                        margin:
                                        EdgeInsets.only(
                                            top: 2.5.h, left: 4.w, right: 4.w),
                                        child: Center(
                                          child: TextFormField(style: TextStyle(color:Colors.black),
                                            validator: (value) =>
                                            Logintype == "email"
                                                ? Validators.validateEmail(
                                                value!)
                                                : null,
                                            cursorColor: themenofier.isdark ? Colors.black : color.primarycolor,
                                            controller: email,
                                            textInputAction: TextInputAction
                                                .next,
                                            decoration: InputDecoration(
                                                hintText: LocaleKeys.Email.tr(),
                                                border: const OutlineInputBorder(),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: themenofier.isdark ? Colors.black : color.primarycolor,),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: themenofier.isdark ? Colors.black : color.primarycolor,),
                                                )),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                        EdgeInsets.only(
                                            top: 2.5.h, left: 4.w, right: 4.w),
                                        child: Center(
                                          child: TextFormField(style: TextStyle(color:Colors.black),
                                            validator: (value) =>
                                                Validators.validatePassword(
                                                    value!),
                                            cursorColor: themenofier.isdark ? Colors.black : color.primarycolor,
                                            controller: password,
                                            obscureText: _obscureText,
                                            textInputAction: TextInputAction.done,
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
                                                          : Icons
                                                          .visibility_off,
                                                      color: themenofier.isdark ? Colors.black : color.primarycolor,
                                                    )),
                                                hintText: LocaleKeys.Password.tr(),
                                                border: const OutlineInputBorder(),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: themenofier.isdark ? Colors.black : color.primarycolor,),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: themenofier.isdark ? Colors.black : color.primarycolor,),
                                                )),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(
                                            right: 4.w, top: 1.5.h),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (
                                                      context) => const Forgotpass()),
                                            );
                                          },
                                          child: Text(
                                            LocaleKeys.Forgot_Password.tr(),
                                            style: TextStyle(
                                                fontFamily: 'Poppins_semiBold',
                                                fontSize: 10.5.sp,
                                                color: themenofier.isdark ? Colors.black : color.primarycolor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 2.h,
                                      right: 4.w,
                                      left: 4.w,
                                    ),
                                    height: 6.5.h,
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: () async {
                                        // if (mobile.value.text.isEmpty) {
                                        //   loader.showErroDialog(description: "enter");
                                        // }

                                        if (_formkey.currentState!.validate()) {
                                          if (Logintype == "mobile") {
                                            if (mobile.value.text.isEmpty) {
                                              loader.showErroDialog(
                                                  description:
                                                  LocaleKeys
                                                      .Please_enter_all_details
                                                      .tr());
                                            } else {
                                              login();
                                            }
                                          } else {
                                            login();
                                          }
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: themenofier.isdark ? Colors.black : color.primarycolor,
                                      ),
                                      child: Text(
                                        LocaleKeys.Login.tr(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins_Bold',
                                            color: Colors.white,
                                            fontSize: 13.sp),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 2.5.h),
                                    child: Text(LocaleKeys.OR.tr(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins_semiBold',
                                          fontSize: 11.sp,
                                        )),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                        top: 1.h,
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black26,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                6)),
                                        child: Card(
                                          elevation: 0,
                                          child: InkWell(
                                              borderRadius: BorderRadius.zero,
                                              onTap: () async {
                                                googlelogin();
                                              },
                                              child: Image.asset(
                                                'Icons/google.png',
                                                height: 5.h,
                                                width: 11.w,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black26,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                6)),
                                        child: Card(
                                          elevation: 0,
                                          child: InkWell(
                                              onTap: () async {
                                                _FBlogin();
                                              },
                                              child: Image.asset(
                                                'Icons/facebook.png',
                                                height: 5.h,
                                                width: 11.w,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          alignment: Alignment.topCenter,
                                          margin: EdgeInsets.only(
                                              top: 2.h, bottom: 2.h),
                                          child: Text(
                                            '${LocaleKeys.Dont_have_an_account
                                                .tr()}?   ',
                                            style:
                                            TextStyle(fontFamily: 'Poppins',
                                                fontSize: 10.5.sp,
                                            color: Colors.black),
                                          )),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 2.h, bottom: 2.h),
                                        alignment: Alignment.topCenter,
                                        padding: EdgeInsets.only(),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Signup()),
                                            );
                                          },
                                          child: Text(
                                            LocaleKeys.Signup.tr(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Poppins_semiBold',
                                                fontSize: 12.sp,
                                                color: themenofier.isdark ? Colors.black : color.primarycolor),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // bottomSheet: Container(
                  //     // decoration: BoxDecoration(color: themenofier.isdark ? Colors.black : color.primarycolor),
                  //     height: 8.h,
                  //     width: MediaQuery.of(context).size.width,
                  //     child: InkWell(
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(builder: (context) => Homepage(0)),
                  //         );
                  //       },
                  //       child: Center(
                  //           child: Text(
                  //         LocaleKeys.Skip_continue.tr(),
                  //         style: TextStyle(
                  //             fontFamily: 'Poppins',
                  //             color: themenofier.isdark ? Colors.black : color.primarycolor,
                  //             fontSize: 13.sp),
                  //       )),
                  //     )),
                ),
              ),
            ),
          );
        });
  }

  googlelogin() async {
    loader.showLoading();
    await _googleSignIn.signIn().then((value) {
      print("===$value");
      loader.hideLoading();
      _googleSignIn.signOut();
      registerAPI(value!);
    }).catchError((e) {
      print("$e");
      loader.showErroDialog(description: "Oops Something Went Wrong !! Please Try Again");
    });
  }

  registerAPI(GoogleSignInAccount value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loader.showLoading();
    var map = {
      "name": value.displayName,
      "email": value.email,
      "mobile": "",
      "token": Googletoken,
      "google_id": value.id,
      "login_type": "google",
    };
    var response =
        await Dio().post(DefaultApi.appUrl + PostAPI.register, data: map);
    Signupmodel data = Signupmodel.fromJson(response.data);
    loader.hideLoading();
    if (data.status == 1) {
      prefs.setString(UD_user_id, data.data!.id.toString());
      prefs.setString(UD_user_name, data.data!.name.toString());
      prefs.setString(UD_user_mobile, data.data!.mobile.toString());
      prefs.setString(UD_user_email, data.data!.email.toString());
      prefs.setString(UD_user_profileimage, data.data!.profileImage.toString());
      prefs.setString(UD_user_logintype, data.data!.loginType.toString());
      Get.to(() => Homepage(0));
    } else if (data.status == 2) {
      Get.to(() => Signup(
          value.email, value.displayName, "google", value.id.toString()));
    } else if (data.status == 3) {
      Get.to(
        () => Otp(
          value.email,
          data.otp.toString(),
        ),
      );
    } else {
      loader.showErroDialog(description: data.message);
    }
  }
}
