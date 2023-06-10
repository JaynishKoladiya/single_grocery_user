// ignore_for_file: prefer_final_fields, file_names, non_constant_identifier_names, use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors,   unused_field, prefer_typing_uninitialized_variables
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:singlegrocery/model/authentication/loginmodel.dart';
import 'package:singlegrocery/model/authentication/otpsucessdata.dart';
import 'package:singlegrocery/model/favorite/addtocartmodel.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:singlegrocery/pages/Home/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:singlegrocery/utils/validator.dart/validator.dart';
import 'package:sizer/sizer.dart';

class Otp extends StatefulWidget {

  String? emailno;
  String? otp;

  @override
  State<Otp> createState() => _OtpState();
  Otp([
    this.emailno,
    this.otp,
  ]);
}

class _OtpState extends State<Otp> {
  final otp = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  otpsuccessdata? userdata;
  bool _obscureText = true;

  _Otpverify() async {
    print("Enter this function");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintype = prefs.getString(App_check_addons)!;
    try {
      loader.showLoading();
      var map = logintype == 'mobile'
          ? {
              "mobile": widget.emailno,
              "otp": otp.text.toString(),
              "token": Googletoken,
            }
          : {
              "email": widget.emailno,
              "otp": otp.text.toString(),
              "token": Googletoken,
            };
      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.otpverify, data: map);
      var finaluserdata = await response.data;
      userdata = otpsuccessdata.fromJson(finaluserdata);
      print("userdata :::: ${userdata}");
      loader.hideLoading();
      if (userdata!.status == 0) {
        loader.showErroDialog(description: userdata!.message);
      } else if (userdata!.status == 1) {
        prefs.setString(UD_user_id, userdata!.data!.id.toString());
        prefs.setString(UD_user_name, userdata!.data!.name.toString());
        prefs.setString(UD_user_email, userdata!.data!.email.toString());
        prefs.setString(UD_user_mobile, userdata!.data!.mobile.toString());
        prefs.setString(
            UD_user_logintype, userdata!.data!.loginType.toString());
        prefs.setString(
            UD_user_profileimage, userdata!.data!.profileImage.toString());
        prefs.setString(
            UD_user_refer_code, userdata!.data!.referralCode.toString());

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage(0)),
        );
      }
    } catch (e) {
      loader.showErroDialog(description: e.toString());
    }
  }

  addtocartmodel? data;

  resendOTP() async {
    loader.showLoading();
    var map = {
      "email": widget.emailno,
    };
    var response =
        await Dio().post(DefaultApi.appUrl + PostAPI.resendotp, data: map);

    Loginmodel data = Loginmodel.fromJson(response.data);
    print(data);
    loader.hideLoading();
    if (data.status == 1) {
      if (DefaultApi.environment == "sendbox") {
        setState(() {
          otp.value = TextEditingValue(text: data.otp.toString());
        });
      }
      loader.showErroDialog(description: data.message);
    } else {
      loader.showErroDialog(description: data.message);
    }
  }

  int _start = 120;
  bool isresend = false;
  Timer? _timer;
  String? Googletoken;
  @override
  void initState() {
    super.initState();

    startTimer();
    token();
  }

  token() async {

    if (DefaultApi.environment == "sendbox") {
      setState(() {
        otp.value = TextEditingValue(text: widget.otp!);
      });
    }
    await FirebaseMessaging.instance.getToken().then((token) {
      Googletoken = token!;
    });
  }

  Timer? countdownTimer;
  Duration myDuration = Duration(minutes: 2);
  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;

      if (seconds < 0) {
        isresend = true;

        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(2));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: color.primarycolor,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon:  Icon(
                  Icons.arrow_back_ios_outlined,
                  color: color.white,
                  size: 20,
                )),
            leadingWidth: 40,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: color.primarycolor,
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("Icons/logo-white.png",height: 20.h,width: 50.w,),
                  Card(
                    margin: EdgeInsets.all(5.w),
                    color: color.white,
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 1.5.h,
                          )),
                        Container(
                          // alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                              left: 4.w,
                              right: 4.w,
                              top: 3.h,
                              bottom: 1.h,
                            ),
                            child: Text(LocaleKeys.OTP_Verification,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Poppins_Bold',
                                    color: color.primarycolor
                                ))),
                        Container(
                          // alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                              left: 4.w,
                              right: 4.w,
                            ),
                            child: Text(
                              LocaleKeys.Enter_OTP_here,
                              style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                            )),
                        Container(
                          margin: EdgeInsets.only(
                            top: 3.h,
                            left: 4.w,
                            right: 4.w,
                          ),
                          child: Center(
                            child: TextFormField(
                              readOnly:
                              DefaultApi.environment == "sendbox" ? true : false,
                              validator: (value) => Validators.validateOtp(value!),
                              cursorColor: color.grey,
                              keyboardType: TextInputType.number,
                              controller: otp,
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
                                border: OutlineInputBorder(),
                                hintText: LocaleKeys.Enter_OTP_here,
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
                              ),
                            ),
                          ),
                        ),
                        if (isresend == false) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 1.h,
                                  left: 4.w,
                                  right: 4.w,
                                ),
                                // alignment: Alignment.centerRight,
                                child: Text(
                                  '$minutes:$seconds',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        Container(
                          margin: EdgeInsets.only(
                            top: 4.h,
                            left: 4.w,
                            right: 4.w,
                            bottom: 4.h
                          ),
                          height: 6.5.h,
                          width: MediaQuery.of(context).size.width / 1.09,
                          child: TextButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                _Otpverify();
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: color.primarycolor,
                            ),
                            child: Text(
                              LocaleKeys.Verify_Proceed,
                              style: TextStyle(
                                  fontFamily: 'Poppins_Bold',
                                  color: Colors.white,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                        if (isresend == true) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(top: 1.h ,bottom: 1.h),
                                  child: InkWell(
                                      child: Text(
                                        "${LocaleKeys.Dont_receive_an_OTP}? ",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                            fontSize: 14),
                                      ))),
                              Container(
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(top: 1.h,bottom: 1.h),
                                  child: InkWell(
                                      onTap: () {
                                        resendOTP();
                                      },
                                      child: Text(
                                        LocaleKeys.Resend_OTP,
                                        style: TextStyle(
                                            fontFamily: 'Poppins_semiBold',
                                            color: color.primarycolor,
                                            fontSize: 12.sp),
                                      ))),
                            ],
                          )
                        ],],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
