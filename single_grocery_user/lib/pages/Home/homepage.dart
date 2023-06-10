// ignore_for_file: camel_case_types, must_be_immutable, prefer_const_constructors, prefer_collection_literals, use_key_in_widget_constructors

import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart' as badges;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/theme/ThemeModel.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/common%20class/height.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/main.dart';
import 'package:singlegrocery/pages/authentication/Login.dart';
import 'package:singlegrocery/pages/cart/cartpage.dart';
import 'package:singlegrocery/pages/Favorite/favoritepage.dart';
import 'package:singlegrocery/pages/Home/homescreen.dart';
import 'package:singlegrocery/pages/orders/orderdetails.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';

import '../orders/orders.dart';
import '../profile/profilepage.dart';

class payloads {
  dynamic categoryName;
  dynamic categoryId;
  dynamic subType;
  dynamic itemId;
  dynamic type;
  dynamic orderId;

  payloads(
      {this.categoryName,
      this.categoryId,
      this.subType,
      this.itemId,
      this.type,
      this.orderId});

  payloads.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    subType = json['sub_type'];
    itemId = json['item_id'];
    type = json['type'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['category_name'] = categoryName;
    data['category_id'] = categoryId;
    data['sub_type'] = subType;
    data['item_id'] = itemId;
    data['type'] = type;
    data['order_id'] = orderId;
    return data;
  }
}

class Homepage extends StatefulWidget {
  int? count;
  Homepage(this.count);
  // const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedindex = 0;

  Future<dynamic> onSelectNotification(payload) async {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Homepage(3),
        ),
      );
    }
  }

  @override
  void initState() {
    _selectedindex = widget.count!;
    // getConnectivity();
    super.initState();
    getdata();
    FirebaseMessaging.instance;
    var initializationsettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationsettingsAndroid);
    FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        String action = jsonEncode(message.data);

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                icon: '@drawable/ic_notification',
                channel.id,
                channel.name,
                // channel.description
              ),
              // iOS: IOSNotificationDetails()
      ),
          payload: action,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          Get.to(() => Orderdetails("171"));
          loader.showErroDialog(description: "sfggfgdfdsd");
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body!),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  String? userid;
  PageController pageController = PageController();
  int cardcount = 0;
  cartcount count = Get.put(cartcount());

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedindex = widget.count!;
      userid = (prefs.getString(UD_user_id) ?? "");
      if (widget.count == 2 || widget.count == 3 || widget.count == 0) {
        pageController.animateToPage(
          widget.count!,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      }
    });
  }

  void onTapped(int index) {
    if (userid != "") {
      setState(() {
        _selectedindex = index;
        widget.count = index;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      });
    } else if (index == 1) {
      if (userid == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Login()), (r) => false);
      }
    } else if (index == 2) {
      if (userid == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Login()), (r) => false);
      }
    } else if (index == 3) {
      if (userid == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Login()), (r) => false);
      }
    } else {
      setState(() {
        _selectedindex = index;
        widget.count = index;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // connections().conect();
    return Consumer(builder: (context, ThemeModel themenofier, child) {
      return WillPopScope(
        onWillPop: () async {
          final value = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert",style: TextStyle(fontFamily: 'Poppins_semibold',fontWeight: FontWeight.bold ,fontSize: 15.sp,color: themenofier.isdark
                    ? Colors.white : color.primarycolor)),
                content: Text("Do you Want to exit?",style: TextStyle(fontFamily: 'Poppins_semibold', fontSize: 15.sp)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(LocaleKeys.No.tr(),style: TextStyle(fontFamily: 'Poppins_semibold', fontSize: 15.sp,
                        color: themenofier.isdark
                        ? Colors.white
                        : color.primarycolor)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(LocaleKeys.Yes.tr(),style: TextStyle(fontFamily: 'Poppins_semibold', fontSize: 15.sp,
                        color: themenofier.isdark
                            ? Colors.white
                            : color.primarycolor)),
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
          body: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: const [
              Homescreen(),
              Favorite(),
              Viewcart(),
              Orderhistory(),
              Profilepage()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'Icons/Home.svg',
                  height: height.bottombaricon,
                  color: themenofier.isdark ? Colors.white : Colors.black,
                ),
                label: "Home",
                activeIcon: SvgPicture.asset(
                  'Icons/Homedark.svg',
                  height: height.bottombaricon,
                  // color: themenofier.isdark ? Colors.white : color.primarycolor,
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'Icons/Favorite.svg',
                  height: height.bottombaricon,
                  color: themenofier.isdark ? Colors.white : Colors.black,
                ),
                label: "Favorite",
                activeIcon: SvgPicture.asset(
                  'Icons/Favoritedark.svg',
                  height: height.bottombaricon,
                  // color: themenofier.isdark ? Colors.white : Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                  icon: Obx(
                    () => count.cartcountnumber.value == 0
                        ? SvgPicture.asset(
                            'Icons/Cart.svg',
                            height: height.bottombaricon,
                            color: themenofier.isdark
                                ? Colors.white
                                : Colors.black,
                          )
                        : badges.Badge(
                            // alignment: Alignment.topCenter,
                          badgeStyle: badges.BadgeStyle(
                            padding: const EdgeInsets.all(5),
                            elevation: 0,
                            badgeColor: color.red,
                          ),
                            badgeContent: Text(
                              count.cartcountnumber.value.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                            child: SvgPicture.asset(
                              'Icons/Cart.svg',
                              height: height.bottombaricon,
                              color: themenofier.isdark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                  ),
                  label: "Cart",
                  activeIcon: Obx(
                    () => count.cartcountnumber.value == 0
                        ? SvgPicture.asset(
                            'Icons/Cartdark.svg',
                            height: height.bottombaricon,
                            // color: themenofier.isdark
                            //     ? Colors.white
                            //     : Colors.black,
                          )
                        : badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                            padding: const EdgeInsets.all(5),
                            elevation: 0,
                            badgeColor: color.red,
                          ),

                            badgeContent: Text(
                              count.cartcountnumber.value.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            child: SvgPicture.asset(
                              'Icons/Cartdark.svg',
                              height: height.bottombaricon,
                              // color: themenofier.isdark
                              //     ? Colors.white
                              //     : Colors.black,
                            ),
                          ),
                  )),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'Icons/Order.svg',
                  height: height.bottombaricon,
                  color: themenofier.isdark ? Colors.white : Colors.black,
                ),
                label: "Order",
                activeIcon: SvgPicture.asset(
                  'Icons/Orderdark.svg',
                  height: height.bottombaricon,
                  // color: themenofier.isdark ? Colors.white : Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'Icons/Profile.svg',
                  height: height.bottombaricon,
                  color: themenofier.isdark ? Colors.white : Colors.black,
                ),
                label: "Profile",
                activeIcon: SvgPicture.asset(
                  'Icons/Profiledark.svg',
                  height: height.bottombaricon,
                  // color: themenofier.isdark ? Colors.white : Colors.black,
                ),
              ),
            ],
            currentIndex: _selectedindex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: themenofier.isdark ? Colors.black : Colors.white,
            onTap: onTapped,
            // selectedFontSize: 1,
            // unselectedFontSize: 1,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(color: color.primarycolor,fontWeight: FontWeight.bold),
            selectedItemColor: color.primarycolor,
            unselectedItemColor: color.black,
          ),
        ),
      );
    });
  }
}
