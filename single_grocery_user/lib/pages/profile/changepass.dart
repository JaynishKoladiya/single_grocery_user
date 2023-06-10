// ignore_for_file: unused_field, non_constant_identifier_names, use_build_context_synchronously, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/Widgets/loader.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/common%20class/height.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/model/settings/changepasswordmodel.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/api/API.dart';
import '../../theme/ThemeModel.dart';

class Changepass extends StatefulWidget {
  const Changepass({Key? key}) : super(key: key);

  @override
  State<Changepass> createState() => _ChangepassState();
}

class _ChangepassState extends State<Changepass> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController oldpass = TextEditingController();
  TextEditingController newpass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;
  changepasswordmodel? changepassworddata;

  _Changepassword() async {
    try {
      loader.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.getString(UD_user_id);

      var map = {
        "user_id": prefs.getString(UD_user_id),
        "new_password": newpass.text.toString(),
        "old_password": oldpass.text.toString(),
      };

      var response = await Dio()
          .post(DefaultApi.appUrl + PostAPI.ChangePassword, data: map);

      // print(response.data);
      var finallist = await response.data;
      changepassworddata = changepasswordmodel.fromJson(finallist);
      loader.hideLoading();

      if (changepassworddata!.status == 0) {
        loader.showErroDialog(
            description: changepassworddata!.message.toString());
      } else if (changepassworddata!.status == 1) {
        oldpass.clear();
        newpass.clear();
        confirmpass.clear();
        Navigator.of(context).pop();
        loader.showErroDialog(description: "update password");
      }
    } catch (e) {
      loader.showErroDialog(description: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ThemeModel themenofier, child) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 20,
                    )),
                title: Text(
                  LocaleKeys.Change_Password.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins_semibold',
                      fontSize: 16,
                    color: themenofier.isdark
                        ? color.white
                        : color.primarycolor,
                  ),
                ),
                centerTitle: true,
                leadingWidth: 40,
              ),
              body: Form(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 4.5.w,
                        right: 4.5.w,
                        top: MediaQuery
                            .of(context)
                            .size
                            .height / 80,
                      ),
                      width: double.infinity,
                      child: Center(
                        child: TextField(
                          cursorColor: Colors.grey,
                          controller: oldpass,
                          obscureText: _obscureText1,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText1 = !_obscureText1;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText1
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: themenofier.isdark
                                        ? color.white
                                        : color.primarycolor,
                                  )),
                              hintText: LocaleKeys.Old_password.tr(),
                              hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: themenofier.isdark
                                      ? color.white
                                      : color.black,
                                  fontSize: 10.5.sp),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: themenofier.isdark
                                    ? color.white
                                    : color.primarycolor,),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: themenofier.isdark
                                    ? color.white
                                    : color.primarycolor,),
                              )),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 4.5.w,
                        right: 4.5.w,
                        top: MediaQuery
                            .of(context)
                            .size
                            .height / 80,
                      ),
                      width: double.infinity,
                      child: Center(
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: newpass,
                          obscureText: _obscureText2,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText2 = !_obscureText2;
                                  });
                                },
                                icon: Icon(
                                  _obscureText2
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: themenofier.isdark
                                      ? color.white
                                      : color.primarycolor,
                                )),
                            hintText: LocaleKeys.New_password.tr(),
                            hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                color: themenofier.isdark
                                    ? color.white
                                    : color.black,
                                fontSize: 10.5.sp),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themenofier.isdark
                                  ? color.white
                                  : color.primarycolor,),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themenofier.isdark
                                  ? color.white
                                  : color.primarycolor,),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 4.5.w,
                        right: 4.5.w,
                        top: MediaQuery
                            .of(context)
                            .size
                            .height / 80,
                      ),
                      width: double.infinity,
                      child: Center(
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.bottom,
                          validator: (val) {
                            if (val!.isEmpty) return 'Empty';
                            if (val != newpass.text) return 'Not Match';
                            return null;
                          },
                          cursorColor: Colors.black,
                          controller: confirmpass,
                          obscureText: _obscureText3,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText3 = !_obscureText3;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText3
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: themenofier.isdark
                                        ? color.white
                                        : color.primarycolor,
                                  )),
                              hintText: LocaleKeys.Confirm_password.tr(),
                              hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: themenofier.isdark
                                      ? color.white
                                      : color.black,
                                  fontSize: 10.5.sp),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide( color: themenofier.isdark
                                    ? color.white
                                    : color.primarycolor,),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide( color: themenofier.isdark
                                    ? color.white
                                    : color.primarycolor,),
                              )),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(
                        right: 4.w,
                        left: 4.w,
                        bottom: 0.8.h,
                      ),
                      height: 6.5.h,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          if (DefaultApi.environment == "sendbox") {
                            loader.showErroDialog(
                              description: LocaleKeys
                                  .This_operation_was_not_performed_due_to_demo_mode
                                  .tr(),
                            );
                          } else {
                            if (oldpass.text.isEmpty) {
                              loader.showErroDialog(
                                  description:
                                  LocaleKeys.Please_enter_all_details.tr());
                            } else if (newpass.text.isEmpty) {
                              loader.showErroDialog(
                                  description:
                                  LocaleKeys.Please_enter_all_details.tr());
                            } else if (confirmpass.text.isEmpty) {
                              loader.showErroDialog(
                                  description:
                                  LocaleKeys.Please_enter_all_details.tr());
                            } else if (newpass.text == confirmpass.text) {
                              _Changepassword();
                            } else {
                              loader.showErroDialog(
                                  description:
                                  "Newpassword and confirm password are not same");
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: themenofier.isdark
                        ? color.white
                            : color.primarycolor,),
                        child: Text(
                          LocaleKeys.Reset.tr(),
                          style: TextStyle(
                              fontFamily: 'Poppins_semibold',
                              color: themenofier.isdark
                                  ? color.black
                                  : color.white,
                              fontSize: fontsize.Buttonfontsize),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}
