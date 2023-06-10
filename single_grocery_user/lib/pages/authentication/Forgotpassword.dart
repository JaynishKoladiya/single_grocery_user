// ignore_for_file: non_constant_identifier_names, file_names, duplicate_ignore,   prefer_const_constructors, prefer_final_fields, empty_catches

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/model/authentication/forgotpasswordmodel.dart';
import 'package:singlegrocery/theme/ThemeModel.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:singlegrocery/utils/validator.dart/validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

import 'Signup.dart';

class Forgotpass extends StatefulWidget {
  const Forgotpass({Key? key}) : super(key: key);

  @override
  State<Forgotpass> createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _Email = TextEditingController();
  Forgotpasswordmodel? Forgotpassdata;

  _Forgotpassword() async {
    try {
      loader.showLoading();
      var map = {
        "email": _Email.text.toString(),
      };
      var response = await Dio()
          .post(DefaultApi.appUrl + PostAPI.forgotPassword, data: map);
      var finallist = await response.data;
      Forgotpassdata = Forgotpasswordmodel.fromJson(finallist);
      loader.hideLoading();
      if (Forgotpassdata!.status == 0) {
        loader.showErroDialog(description: Forgotpassdata!.message);
      } else if (Forgotpassdata!.status == 1) {
        _Email.clear();
        loader.showErroDialog(description: Forgotpassdata!.message);
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer(
        builder: (context, ThemeModel themenofier, child) => SafeArea(
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
                  children: [
                    Image.asset("Icons/logo-white.png",height: 20.h,width: 50.w,),
                    Card(
                      margin: EdgeInsets.all(5.w),
                      color: color.white,
                      elevation: 3,
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                top: 1.5.h,
                              )),
                          Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 4.w, top: 3.h, bottom: 1.h),
                              child: Text(LocaleKeys.Forgot_Password.tr(),
                                  style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins_Bold',color: color.primarycolor))),
                          Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                left: 4.w,
                                right: 4.w,
                              ),
                              child: Text(
                                LocaleKeys
                                    .Enter_your_registered_email_address_below_We_will_send_new_password_in_your_email
                                    .tr(),
                                style:
                                const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 5.h, left: 4.w, right: 4.w),
                            child: Center(
                              child: TextFormField(
                                validator: (value) => Validators.validateEmail(value!),
                                cursorColor: Colors.black38,
                                controller: _Email,
                                decoration: InputDecoration(
                                    hintText: LocaleKeys.Email.tr(),
                                    border: const OutlineInputBorder(),
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(color:themenofier.isdark
                                          ? color.white
                                          : color.primarycolor),
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(color:themenofier.isdark
                                          ? color.white
                                          : color.primarycolor),
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3.h, left: 4.w, right: 4.w),
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
                                } else if (_formkey.currentState!.validate()) {
                                  _Forgotpassword();
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: color.primarycolor,
                              ),
                              child: Text(
                                LocaleKeys.Submit.tr(),
                                style: const TextStyle(
                                    fontFamily: 'Poppins_Bold',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(bottom: 2.h,top: 1.h),
                                  child: Text(
                                    "${LocaleKeys.Dont_have_an_account.tr()}?  ",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                        fontSize: 14),
                                  )),
                              Container(
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(bottom: 2.h,top: 1.h),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Signup()),
                                        );
                                      },
                                      child: Text(
                                        LocaleKeys.Signup.tr(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins_semiBold',
                                            fontWeight: FontWeight.w600,
                                            color:color.primarycolor,
                                            fontSize: 16),
                                      ))),],
                          )
                        ],
                      ),
                    )
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
