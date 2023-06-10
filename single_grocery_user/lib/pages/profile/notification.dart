// ignore_for_file: file_names,   prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/model/settings/isnotificationmodel.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import '../../theme/ThemeModel.dart';

class Notificationpage extends StatefulWidget {
  const Notificationpage({Key? key}) : super(key: key);

  @override
  State<Notificationpage> createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {
  bool status1 = false;
  String? userid;
  String? isnotification;
  String? ismail;
  isnotificationModel? notificationdata;

  isisnotificationAPI(notification, mail) async {
    loader.showLoading();
    var map = {
      "user_id": userid,
      "notification_status": notification,
      "mail_status": mail,
    };

    var response =
        await Dio().post(DefaultApi.appUrl + PostAPI.Isnotification, data: map);
    var finallist = await response.data;
    notificationdata = isnotificationModel.fromJson(finallist);
    if (notificationdata!.status == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(UD_user_isnotification,
          notificationdata!.notificationStatus.toString());
      prefs.setString(UD_user_ismail, notificationdata!.mailStatus.toString());
    }
    loader.hideLoading();
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString(UD_user_id);
      isnotification = prefs.getString(UD_user_isnotification);
      ismail = prefs.getString(UD_user_ismail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themenofier, child) {
      return SafeArea(
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
            LocaleKeys.Notification_Settings.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins_semibold', fontSize: 12.sp,
              color: themenofier.isdark
                  ? Colors.white
                  : color.primarycolor,),
          ),
          leadingWidth: 40,
          centerTitle: true,
        ),
             body: Container(
          margin: EdgeInsets.only(top: 1.7.h, left: 4.w, right: 4.w),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    LocaleKeys.Push_Notifications.tr(),
                    style: TextStyle(
                        fontFamily: 'Poppins_semibold', fontSize: 12.sp,
                      color: themenofier.isdark
                    ? Colors.white
                        : color.primarycolor,),
                  ),
                  Spacer(),
                  CupertinoSwitch(
                    activeColor:  themenofier.isdark
                  ? Colors.white60
                      : color.primarycolor,
                    value: isnotification == "1" ? true : false,
                    onChanged: (val) {
                      if (isnotification == "1") {
                        setState(() {
                          isnotification = "2";
                        });

                        isisnotificationAPI(isnotification, ismail);
                      } else {
                        setState(() {
                          isnotification = "1";
                        });
                        isisnotificationAPI(isnotification, ismail);
                      }
                    },
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 1.h, bottom: 1.1.h),
                height: 0.8.sp,
                color: color.grey,
              ),
              Row(
                children: [
                  Text(
                    LocaleKeys.keepthisonnoti.tr(),
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 10.sp,
                      color: themenofier.isdark
                      ? Colors.white
                          : color.primarycolor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                children: [
                  Text(
                    LocaleKeys.Emails,
                    style: TextStyle(
                        fontFamily: 'Poppins_semibold', fontSize: 12.sp,color: themenofier.isdark
                        ? Colors.white
                        : color.primarycolor,

                    ),
                  ),
                  Spacer(),
                  CupertinoSwitch(
                    activeColor: themenofier.isdark
                        ? Colors.white60
                        : color.primarycolor,
                    value: ismail == "1" ? true : false,
                    onChanged: (val1) {
                      if (ismail == "1") {
                        setState(() {
                          ismail = "2";
                        });
                        isisnotificationAPI(isnotification, ismail);
                      } else {
                        setState(() {
                          ismail = "1";
                        });
                        isisnotificationAPI(isnotification, ismail);
                      }
                    },
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 1.h, bottom: 1.1.h),
                height: 0.8.sp,
                color: Colors.black26,
              ),
              Row(
                children: [
                  Text(
                    LocaleKeys.Keep_this_on_to_receive_emails_from_system.tr(),
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 10.sp,
                      color: themenofier.isdark
                          ? Colors.white
                          : color.primarycolor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    });
  }
}
