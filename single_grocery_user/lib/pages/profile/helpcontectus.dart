// ignore_for_file: file_names,   use_build_context_synchronously, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/Widgets/loader.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/common%20class/height.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:singlegrocery/model/settings/helpmodel.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:singlegrocery/utils/validator.dart/validator.dart';
import 'package:sizer/sizer.dart';

import '../../theme/ThemeModel.dart';

class Helpcontactus extends StatefulWidget {
  const Helpcontactus({Key? key}) : super(key: key);

  @override
  State<Helpcontactus> createState() => _HelpcontactusState();
}

class _HelpcontactusState extends State<Helpcontactus> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final message = TextEditingController();
  helpmodel? helpdata;
  helpAPI() async {
    try {
      loader.showLoading();
      var map = {
        "firstname": firstname.text.toString(),
        "lastname": lastname.text.toString(),
        "email": email.text.toString(),
        "message": message.text.toString()
      };

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.contact, data: map);
      var finalist = await response.data;
      helpdata = helpmodel.fromJson(finalist);
      loader.hideLoading();
      if (helpdata!.status == 1) {
        Navigator.of(context).pop();
        loader.showErroDialog(description: helpdata!.message);
      } else {
        loader.showErroDialog(description: helpdata!.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ThemeModel themenofier, child) {
          return SafeArea(
            child: SafeArea(
              child: Scaffold(
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
                      LocaleKeys.Help_Contact_Us.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Poppins_semibold', fontSize: 12.sp,
                          color: themenofier.isdark ? Colors.white : color.primarycolor,
                      ),
                    ),
                    centerTitle: true,
                    leadingWidth: 40,
                  ),
                  body: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 4.5.w,
                              right: 4.5.w,
                              top: 1.h,
                            ),
                            child: Text(
                              LocaleKeys.Contectus.tr(),
                              style: TextStyle(
                                  fontFamily: 'Poppins_semibold',
                                  fontSize: 12.sp,
                                color: themenofier.isdark ? Colors.white : color.primarycolor,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 4.5.w,
                              top: 1.h,
                              right: 4.5.w,
                            ),
                            child: Row(children: [
                              const ImageIcon(
                                AssetImage('Icons/phone.png',
                                ),
                                size: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 2.w,
                                  right: 2.w,
                                ),
                                child: Text(
                                  "+91 9640833349",
                                  style: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 9.5.sp,
                                    color: themenofier.isdark ? Colors.white : color.black,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 4.2.w,
                                right: 4.2.w,
                                top: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 80),
                            child: Row(children: [
                              const ImageIcon(
                                AssetImage('Icons/mail.png'),
                                size: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 2.w,
                                  right: 2.w,
                                ),
                                child: Text(
                                  "gmdpl.atp@gmail.com",
                                  style: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 9.5.sp,
                                    color: themenofier.isdark ? Colors.white : color.black,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 4.2.w,
                              top: 1.6.h,
                              right: 4.w,
                            ),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ImageIcon(
                                    AssetImage('Icons/address.png'),
                                    size: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 2.w,
                                      right: 2.w,
                                    ),
                                    child: Text(
                                      maxLines: 4,
                                      "M/s Gayathri Milk Dairy Pvt Ltd. \n Sy No: 126/7, Alamur Road, Rudrampet,\n Ananthapuramu,\n Andhra Pradesh - 515001",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 9.5.sp,
                                        color: themenofier.isdark ? Colors.white : color.black,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3.h,
                                left: 4.w,
                                right: 4.w),
                            child: Text(
                              LocaleKeys.Inquiry_form.tr(),
                              style:  TextStyle(
                                fontFamily: 'Poppins_semibold',
                                fontSize: 14,
                                color: themenofier.isdark ? Colors.white : color.primarycolor,

                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 4.w, left: 4.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 2.h,
                                    bottom: 1.h,
                                    // left: 4.w,
                                  ),
                                  width: 45.w,
                                  child: TextFormField(
                                    validator: (value) =>
                                        Validators.validatefirstName(
                                          value!,
                                        ),
                                    controller: firstname,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                        hintText: LocaleKeys.First_name.tr(),
                                        hintStyle: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: themenofier.isdark ? Colors.white : color.black,
                                            fontSize: 11.sp),
                                        border: const OutlineInputBorder(),
                                        enabledBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: themenofier.isdark ? Colors.white : color.primarycolor,
                                          ),
                                        ),
                                        focusedBorder:  OutlineInputBorder(
                                          borderSide:  BorderSide(
                                            color: themenofier.isdark ? Colors.white : color.primarycolor,
                                          )
                                        )),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 2.h,
                                    bottom: 1.h,
                                  ),
                                  width: 45.w,
                                  child: TextFormField(
                                    validator: (value) =>
                                        Validators.validatelastName(
                                          value!,
                                        ),
                                    controller: lastname,
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                        hintText: LocaleKeys.Last_name.tr(),
                                        hintStyle: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: themenofier.isdark ? Colors.white : color.black,
                                            fontSize: 11.sp),
                                        border: const OutlineInputBorder(),
                                        enabledBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: themenofier.isdark ? Colors.white : color.primarycolor,
                                          ),
                                        ),
                                        focusedBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: themenofier.isdark ? Colors.white : color.primarycolor,
                                          )
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 1.h, bottom: 1.h, left: 4.w, right: 4.w),
                            child: TextFormField(
                              validator: (value) =>
                                  Validators.validateEmail(
                                    value!,
                                  ),
                              controller: email,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  hintText: LocaleKeys.Email.tr(),
                                  hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: themenofier.isdark ? Colors.white : color.black,
                                      fontSize: 11.sp),
                                  border: const OutlineInputBorder(),
                                  enabledBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: themenofier.isdark ? Colors.white : color.primarycolor,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  )),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 1.h, bottom: 1.h, left: 4.w, right: 4.w),
                            child: TextFormField(
                              validator: (value) =>
                                  Validators.validatemessage(
                                    value!,
                                  ),
                              controller: message,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  hintText: LocaleKeys.Message.tr(),
                                  hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: themenofier.isdark ? Colors.white : color.black,
                                      fontSize: 11.sp),
                                  border: const OutlineInputBorder(),
                                  enabledBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: themenofier.isdark ? Colors.white : color.primarycolor,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  )),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 1.6.h,
                              bottom: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 99,
                              left: 4.w,
                              right: 4.w,
                            ),
                            height: 6.h,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  helpAPI();
                                } else {
                                  loader.showErroDialog(
                                      description:
                                      LocaleKeys.Please_enter_all_details.tr());
                                }
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: themenofier.isdark ? Colors.white : color.primarycolor,),
                              child: Text(
                                LocaleKeys.Submit.tr(),
                                style: TextStyle(
                                    fontFamily: 'Poppins_semibold',
                                    color: themenofier.isdark ? Colors.black : color.white,
                                    fontSize: fontsize.Buttonfontsize),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: const AssetImage('Icons/facebook.png'),
                                height: 4.h,
                                width: 4.h,
                              ),
                              SizedBox(
                                width: 2.5.w,
                              ),
                              Image(
                                image: const AssetImage('Icons/instagram.png'),
                                height: 4.5.h,
                                width: 4.5.h,
                              ),
                              SizedBox(
                                width: 2.5.w,
                              ),
                              Image(
                                image: const AssetImage('Icons/twitter.png'),
                                height: 4.5.h,
                                width: 4.5.h,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          );
        });
  }
}
