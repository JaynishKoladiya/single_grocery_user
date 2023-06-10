// ignore_for_file: prefer_const_constructors, camel_case_types, non_constant_identifier_names,   unused_element

import 'dart:async';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:singlegrocery/model/favorite/addtocartmodel.dart';
import 'package:singlegrocery/pages/authentication/Login.dart';
import 'package:singlegrocery/model/cart/qtyupdatemodel.dart';
import 'package:singlegrocery/model/home/homescreenmodel.dart';
import 'package:singlegrocery/pages/cart/cartpage.dart';
import 'package:singlegrocery/theme/ThemeModel.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:singlegrocery/common%20class/allformater.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:singlegrocery/pages/Favorite/showvariation.dart';
import 'package:singlegrocery/pages/Home/categoriesinfo.dart';
import 'package:singlegrocery/pages/Home/product.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import '../../common class/icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'categories.dart';
import 'search.dart';
import 'trendingfood.dart';
import 'package:get/get.dart' hide Trans;

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
  }

  String username = "";
  String userid = "";
  String? currency;
  String? currency_position;
  String? profileimage;
  cartcount count = Get.put(cartcount());
  int? cart;

  homescreenmodel? homedata;
  addtocartmodel? addtocartdata;

  // Timer? _timer;

  Future homescreenAPI() async {
    // await Future.delayed(Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = (prefs.getString(UD_user_name) ?? "");
    userid = (prefs.getString(UD_user_id) ?? "");
    profileimage = (prefs.getString(UD_user_profileimage) ?? "");
    try {
      var map = {"user_id": userid};

      var response = await Dio().post(
        DefaultApi.appUrl + PostAPI.Home,
        data: map,
      );
      // log("response=$userid");
      var finalist = await response.data;
      // log("response=$finalist");
      homedata = homescreenmodel.fromJson(finalist);
      // print("response=${homescreenmodel.fromJson(finalist)}");

      prefs.setString(environment, homedata!.environment.toString());
      prefs.setString(UD_user_id, homedata!.getprofile!.id.toString());
      prefs.setString(UD_user_name, homedata!.getprofile!.name.toString());
      prefs.setString(UD_user_mobile, homedata!.getprofile!.mobile.toString());
      prefs.setString(UD_user_email, homedata!.getprofile!.email.toString());
      print(1);
      prefs.setString(
          UD_user_logintype, homedata!.getprofile!.loginType.toString());
      prefs.setString(UD_user_wallet, homedata!.getprofile!.wallet.toString());
      prefs.setString(UD_user_isnotification,
          homedata!.getprofile!.isNotification.toString());
      print(2);

      prefs.setString(UD_user_ismail, homedata!.getprofile!.isMail.toString());
      prefs.setString(
          UD_user_refer_code, homedata!.getprofile!.referralCode.toString());
      prefs.setString(
          UD_user_profileimage, homedata!.getprofile!.profileImage.toString());
      print(3);

      prefs.setString(APPcurrency, homedata!.appdata!.currency.toString());
      prefs.setString(
          APPcurrency_position, homedata!.appdata!.currencyPosition.toString());
      prefs.setString(APPcart_count, homedata!.cartdata!.totalCount.toString());
      prefs.setString(
          min_order_amount, homedata!.appdata!.minOrderAmount.toString());
      prefs.setString(
          max_order_amount, homedata!.appdata!.maxOrderAmount.toString());
      print(4);
      prefs.setString(restaurantlat, homedata!.appdata!.lat.toString());
      prefs.setString(restaurantlang, homedata!.appdata!.lang.toString());
      prefs.setString(
          referral_amount, homedata!.appdata!.referralAmount.toString());
      prefs.setString(
          deliverycharges, homedata!.appdata!.deliveryCharge.toString());
      prefs.setString(about_us, homedata!.appdata!.aboutContent.toString());
      prefs.setString(App_check_addons, homedata!.checkaddons.toString());
      print(1);
      prefs.setString(Androidlink, homedata!.appdata!.android.toString());
      prefs.setString(Ioslink, homedata!.appdata!.ios.toString());
      prefs.setString(
          UD_user_logintype, homedata!.getprofile!.loginType.toString());
      print(6);
      currency = (prefs.getString(APPcurrency) ?? "");
      currency_position = (prefs.getString(APPcurrency_position) ?? "");
      count.cartcountnumber(int.parse(prefs.getString(APPcart_count)!));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  addtocart(
    itemid,
    itemname,
    itemimage,
    itemtype,
    itemtax,
    itemprice,
  ) async {
    try {
      loader.showLoading();
      var map = {
        "user_id": userid,
        "item_id": itemid,
        "item_name": itemname,
        "item_image": itemimage,
        "item_type": itemtype,
        "tax": itemtax,
        "item_price": numberFormat.format(double.parse(itemprice)),
        "variation_id": "",
        "subscription_id": "",
        "start_date": "",
        "end_date": "",
        "custom_day":[],
        "variation": "",
        "addons_id": "",
        "addons_name": "",
        "addons_price": "",
        "addons_total_price": numberFormat.format(
          double.parse("0"),
        ),
      };

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Addtocart, data: map);
      addtocartdata = addtocartmodel.fromJson(response.data);
      if (addtocartdata!.status == 1) {
        loader.hideLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(APPcart_count, addtocartdata!.cartCount.toString());

        count.cartcountnumber(int.parse(prefs.getString(APPcart_count)!));
        setState(() {
          // FavoriteAPI();
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  managefavarite(var itemid, String isfavorite, index, String type) async {
    try {
      loader.showLoading();
      var map = {"user_id": userid, "item_id": itemid, "type": isfavorite};

      var favoriteresponse = await Dio()
          .post(DefaultApi.appUrl + PostAPI.Managefavorite, data: map);
      var finaldata = QTYupdatemodel.fromJson(favoriteresponse.data);

      if (finaldata.status == 1) {
        loader.hideLoading();
        if (type == "trending") {
          setState(() {
            isfavorite == "favorite"
                ? homedata!.trendingitems![index].isFavorite = "1"
                : homedata!.trendingitems![index].isFavorite = "0";
            homedata!.trendingitems.reactive;
          });
        } else if (type == "todayspecial") {
          setState(() {
            isfavorite == "favorite"
                ? homedata!.todayspecial![index].isFavorite = "1"
                : homedata!.todayspecial![index].isFavorite = "0";

            homedata!.todayspecial.reactive;
          });
        } else if (type == "recommendeditems") {
          setState(() {
            isfavorite == "favorite"
                ? homedata!.recommendeditems![index].isFavorite = "1"
                : homedata!.recommendeditems![index].isFavorite = "0";
          });
        }
      } else {
        loader.hideLoading();
        loader.showErroDialog(description: finaldata.message);
      }
    } catch (e) {
      rethrow;
    }
  }
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel themenofier, child) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: FutureBuilder(
              future: homescreenAPI(),
              builder: (context, snapshot) {
                // print("Hello=${snapshot}");
                if (snapshot.hasData) {
                  return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.Welcome_to.tr(),
                                style: TextStyle(
                                    fontFamily: "Poppins", fontSize: 11.sp),
                              ),
                              if (username == "") ...[
                                Text(
                                  LocaleKeys.Single_Grocery.tr(),
                                  style: TextStyle(
                                      fontFamily: "Poppins_bold",
                                      fontSize: 14.sp,
                                      color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor),
                                ),
                              ] else ...[
                                Text(
                                  capitalize("${username}"),
                                  style: TextStyle(
                                      fontFamily: "Poppins_bold",
                                      fontSize: 14.sp,
                                    color: themenofier.isdark
                                        ? Colors.white
                                        : color.primarycolor,
                                  ),
                                ),
                              ]
                            ],
                          ),
                          if (username != "") ...[
                            SizedBox(
                                height: 50,
                                width: 50,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: themenofier.isdark
                                            ? Colors.white
                                            : color.primarycolor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(profileimage.toString())
                                        )
                                    ),
                                ))
                          ]
                        ],
                      ),
                      // systemOverlayStyle: SystemUiOverlayStyle.light,
                    ),
                    body: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  top: 1.h, left: 4.w, right: 4.w, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                       width: 0.8.sp,
                                      color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor)),
                              height: 6.h,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Search()),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Icon(
                                        Icons.search,
                                        size: 18.sp,
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        LocaleKeys.Search_Here.tr(),
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: themenofier.isdark
                                                ? Colors.white
                                                : color.primarycolor,
                                            fontFamily: "Poppins"),
                                      )
                                    ],
                                  ))),
                          if (homedata!.categories!.isNotEmpty) ...[
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 4.w,
                                  ),
                                ),
                                Text(
                                  LocaleKeys.Categories.tr(),
                                  style: TextStyle(
                                      fontFamily: "Poppins_bold",
                                      fontSize: 15.sp,
                                      color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Categoriespage(
                                              homedata!.categories)),
                                    );
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_outlined,
                                      size: 2.5.h,color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 1.5.h,
                                // left: 2.w,
                                right: 2.w,
                              ),
                              height: 25.h,
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            homedata!.categories!.length ~/ 2,
                                        crossAxisSpacing: 2.w,
                                        mainAxisSpacing: 1.w,
                                        childAspectRatio: 1.4),
                                // scrollDirection: Axis.horizontal,
                                itemCount: homedata!.categories!.length,
                                itemBuilder: (context, index) => Container(
                                  // margin: EdgeInsets.only(left: 2.5.w),
                                  child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => categories_items(
                                              homedata!.categories![index].id
                                                  .toString(),
                                              homedata!.categories![index]
                                                  .categoryName
                                                  .toString(),
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: themenofier.isdark
                                                      ? Colors.white
                                                      : color.primarycolor
                                                      .withOpacity(0.2),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        homedata!
                                                            .categories![index]
                                                            .image
                                                            .toString()),
                                                    // fit: BoxFit.cover
                                                  )),
                                              // width: 20.h,
                                              // height: 20.h,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(1.h),
                                            child: Text(
                                                homedata!.categories![index]
                                                    .categoryName
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Poppins_medium",
                                                    fontSize: 9.5.sp,color: themenofier.isdark
                                                    ? Colors.white
                                                    : color.primarycolor)),
                                          )
                                        ],
                                      )
                                      // Column(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Container(
                                      //       decoration: BoxDecoration(
                                      //         shape: BoxShape.circle,
                                      //         image: DecorationImage(
                                      //           image: NetworkImage(homedata!
                                      //               .categories![index].image
                                      //               .toString()),
                                      //             fit: BoxFit.fill
                                      //         )
                                      //       ),
                                      //       width: 20.h,
                                      //       height: 20.h,
                                      //
                                      //     ),
                                      //     // Expanded(
                                      //     //   child: Text(
                                      //     //       homedata!.categories![index]
                                      //     //           .categoryName
                                      //     //           .toString(),
                                      //     //       overflow: TextOverflow.ellipsis,
                                      //     //       style: TextStyle(
                                      //     //           fontFamily:
                                      //     //               "Poppins_medium",
                                      //     //           fontSize: 9.5.sp)),
                                      //     // )
                                      //   ],
                                      // ),
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                          if (homedata!.banners!.topbanners!.isNotEmpty) ...[
                            SizedBox(
                              height: 2.h,
                            ),
                            SizedBox(
                                height: 23.h,
                                width: double.infinity,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      homedata!.banners!.topbanners!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                        left: 2.w,
                                        right: 2.w,
                                      ),
                                      // height: 20.h,
                                      width: 80.w,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (homedata!.banners!
                                                  .topbanners![index].type ==
                                              "2") {
                                            Get.to(() => Product(int.parse(
                                                homedata!
                                                    .banners!
                                                    .topbanners![index]
                                                    .itemId)));
                                          } else if (homedata!.banners!
                                                  .topbanners![index].type ==
                                              "1") {
                                            Get.to(() => categories_items(
                                                  "${homedata!.banners!
                                                      .topbanners![index].catId}",
                                                  homedata!
                                                      .banners!
                                                      .topbanners![index]
                                                      .categoryInfo!
                                                      .categoryName,
                                                ));
                                          }
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: Image.network(
                                            homedata!.banners!
                                                .topbanners![index].image
                                                .toString(),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                            SizedBox(
                              height: 2.5.h,
                            ),
                          ],
                          // Popular Around You
                          if (homedata!.trendingitems!.isNotEmpty) ...[
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 4.w,
                                    top: 2.h,
                                  ),
                                ),
                                Text(
                                  LocaleKeys.Trending.tr(),
                                  style: TextStyle(
                                      fontFamily: "Poppins_bold",
                                      fontSize: 15.sp,
                                      color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Trendingfood(
                                          "2",
                                          LocaleKeys.Trending.tr(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "View All",
                                        style: TextStyle(
                                             color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 2.5.h,
                                          color: themenofier.isdark
                                              ? Colors.white
                                              : color.primarycolor
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 28.h,
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                  right: 3.w,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: homedata!.trendingitems!.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Product(
                                              homedata!
                                                  .trendingitems![index].id,homedata!.trendingitems![index])),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    height: 28.h,
                                    width: 40.w,
                                    child: Card(
                                        elevation: 3,
                                        // decoration: BoxDecoration(
                                        //     borderRadius:
                                        //         BorderRadius.circular(7),
                                        //     border: Border.all(
                                        //         width: 0.8.sp,
                                        //         color: Colors.grey)),
                                        margin: EdgeInsets.only(
                                          top: 1.h,
                                          left: 3.5.w,
                                        ),
                                        child: ListView(children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: 10.h,
                                                width: 46.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5))),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5)),
                                                  child: Image.network(
                                                    homedata!
                                                        .trendingitems![index]
                                                        .imageUrl
                                                        .toString(),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              if (homedata!
                                                      .trendingitems![index]
                                                      .hasVariation ==
                                                  "0") ...[
                                                if (homedata!
                                                            .trendingitems![
                                                                index]
                                                            .availableQty ==
                                                        "" ||
                                                    int.parse(homedata!
                                                            .trendingitems![
                                                                index]
                                                            .availableQty
                                                            .toString()) <=
                                                        0) ...[
                                                  Positioned(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 20.h,
                                                      width: 46.w,
                                                      color: Colors.black38,
                                                      child: Text(
                                                        LocaleKeys.Out_of_Stock
                                                            .tr(),
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: themenofier.isdark
                                                              ? Colors.white
                                                              : color.primarycolor,
                                                          fontFamily:
                                                              'poppins_semibold',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              ],
                                              Positioned(
                                                top: 0.0,
                                                right: 0.0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (userid == "") {
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                              MaterialPageRoute(
                                                                  builder: (c) =>
                                                                      Login()),
                                                              (r) => false);
                                                    } else if (homedata!
                                                            .trendingitems![
                                                                index]
                                                            .isFavorite ==
                                                        "0") {
                                                      managefavarite(
                                                          homedata!
                                                              .trendingitems![
                                                                  index]
                                                              .id,
                                                          "favorite",
                                                          index,
                                                          "trending");
                                                    } else if (homedata!
                                                            .trendingitems![
                                                                index]
                                                            .isFavorite ==
                                                        "1") {
                                                      managefavarite(
                                                          homedata!
                                                              .trendingitems![
                                                                  index]
                                                              .id,
                                                          "unfavorite",
                                                          index,
                                                          "trending");
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 6.h,
                                                    width: 12.w,
                                                    // decoration: BoxDecoration(
                                                    //   // shape: BoxShape.values,
                                                    //   borderRadius:
                                                    //       BorderRadius.circular(
                                                    //           12),
                                                    //   color: Colors.black26,
                                                    // ),
                                                    child: Center(
                                                      child: homedata!
                                                                  .trendingitems![
                                                                      index]
                                                                  .isFavorite ==
                                                              "0"
                                                          ? SvgPicture.asset(
                                                              'Icons/Favorite.svg',
                                                          color: themenofier.isdark
                                                              ? Colors.white
                                                              : color.primarycolor
                                                            )
                                                          : SvgPicture.asset(
                                                              'Icons/Favoritedark.svg',
                                                               color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 2.w,
                                                  right: 2.w,
                                                  top: 0.9.h,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      homedata!
                                                          .trendingitems![index]
                                                          .categoryInfo!
                                                          .categoryName
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 8.sp,
                                                        fontFamily: 'Poppins',
                                                          color: themenofier.isdark
                                                              ? Colors.white
                                                              : color.primarycolor
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    if (homedata!
                                                            .trendingitems![
                                                                index]
                                                            .itemType ==
                                                        "1") ...[
                                                      SizedBox(
                                                          height: 2.h,
                                                          // width: 16,
                                                          child: Image.asset(
                                                              Defaulticon
                                                                  .vegicon))
                                                    ] else ...[
                                                      SizedBox(
                                                          height: 2.h,
                                                          // width: 16,
                                                          child: Image.asset(
                                                              Defaulticon
                                                                  .nonvegicon))
                                                    ]
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 2.w,
                                                  right: 2.w,
                                                  top: 0.5.h,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        homedata!
                                                            .trendingitems![
                                                                index]
                                                            .itemName
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontFamily:
                                                              'Poppins_semibold',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 2.w,
                                                    right: 2.w,
                                                    top: 1.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if (homedata!
                                                            .trendingitems![
                                                                index]
                                                            .hasVariation ==
                                                        "1") ...[
                                                      Text(
                                                        currency_position == "1"
                                                            ? "$currency${numberFormat.format(double.parse(homedata!.trendingitems![index].variation![0].productPrice.toString()))}"
                                                            : "${numberFormat.format(double.parse(homedata!.trendingitems![index].variation![0].productPrice.toString()))}$currency",
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: themenofier.isdark
                                                              ? Colors.white
                                                              : color.primarycolor,
                                                          fontFamily:
                                                              'Poppins_bold',
                                                        ),
                                                      ),
                                                    ] else ...[
                                                      Text(
                                                        currency_position == "1"
                                                            ? "$currency${numberFormat.format(double.parse(homedata!.trendingitems![index].price.toString()))}"
                                                            : "${numberFormat.format(double.parse(homedata!.trendingitems![index].price.toString()))}$currency",
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: themenofier.isdark
                                                              ? Colors.white
                                                              : color.primarycolor,
                                                          fontFamily:
                                                              'Poppins_bold',
                                                        ),
                                                      ),
                                                    ],
                                                    //////

                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 0.7.h,
                                              ),
                                              if (homedata!
                                                  .trendingitems![
                                              index]
                                                  .hasVariation ==
                                                  "0") ...[
                                                if (homedata!
                                                    .trendingitems![
                                                index]
                                                    .availableQty ==
                                                    "" ||
                                                    int.parse(homedata!
                                                        .trendingitems![
                                                    index]
                                                        .availableQty
                                                        .toString()) <=
                                                        0) ...[
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              4),
                                                          border: Border.all(
                                                              color: themenofier.isdark
                                                                  ? Colors.white
                                                                  : color.primarycolor)),
                                                      height: 3.5.h,
                                                      width: 32.w,
                                                      child: Center(
                                                        child: Text(
                                                          LocaleKeys.ADD
                                                              .tr(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'Poppins',
                                                              fontSize:
                                                              9.5.sp,
                                                              color: themenofier.isdark
                                                                  ? Colors.white
                                                                  : color.primarycolor),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              ]
                                              else if (homedata!
                                                  .trendingitems![
                                              index]
                                                  .isCart ==
                                                  "0") ...[
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (homedata!
                                                        .trendingitems![
                                                    index]
                                                        .hasVariation ==
                                                        "1" ||
                                                        homedata!
                                                            .trendingitems![
                                                        index]
                                                            .addons!
                                                            .isNotEmpty) {
                                                      cart = await Get.to(
                                                              () => showvariation(
                                                              homedata!
                                                                  .trendingitems![
                                                              index]));
                                                      if (cart == 1) {
                                                        setState(() {
                                                          homedata!
                                                              .trendingitems![
                                                          index]
                                                              .isCart = "1";
                                                          homedata!
                                                              .trendingitems![
                                                          index]
                                                              .itemQty = int.parse(homedata!
                                                              .trendingitems![
                                                          index]
                                                              .itemQty!
                                                              .toString()) +
                                                              1;
                                                        });
                                                      }
                                                    } else {
                                                      if (userid == "") {
                                                        Navigator.of(
                                                            context)
                                                            .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder: (c) =>
                                                                    Login()),
                                                                (r) =>
                                                            false);
                                                      } else {
                                                        addtocart(
                                                            homedata!
                                                                .trendingitems![
                                                            index]
                                                                .id,
                                                            homedata!
                                                                .trendingitems![
                                                            index]
                                                                .itemName,
                                                            homedata!
                                                                .trendingitems![
                                                            index]
                                                                .imageName,
                                                            homedata!
                                                                .trendingitems![
                                                            index]
                                                                .itemType,
                                                            homedata!
                                                                .trendingitems![
                                                            index]
                                                                .tax,
                                                            homedata!
                                                                .trendingitems![
                                                            index]
                                                                .price);
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              4),
                                                          border: Border.all(
                                                               color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor)),
                                                      height: 3.5.h,
                                                      width: 32.w,
                                                      child: Center(
                                                        child: Text(
                                                          LocaleKeys.ADD
                                                              .tr(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'Poppins',
                                                              fontSize:
                                                              9.5.sp,
                                                              color: themenofier.isdark
                                                                  ? Colors.white
                                                                  : color.primarycolor),
                                                        ),
                                                      )),
                                                ),
                                              ]
                                              else if (homedata!
                                                    .trendingitems![
                                                index]
                                                    .isCart ==
                                                    "1") ...[
                                                  Container(
                                                    height: 3.6.h,
                                                    width: 32.w,
                                                    decoration:
                                                    BoxDecoration(
                                                      border: Border.all(
                                                          color: themenofier.isdark
                                                              ? Colors.white
                                                              : color.primarycolor),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(5),
                                                      // color: Theme.of(context).accentColor
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              loader
                                                                  .showErroDialog(
                                                                description:
                                                                LocaleKeys.The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item
                                                                    .tr(),
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons.remove,
                                                              color: themenofier.isdark
                                                                  ? Colors.white
                                                                  : color.primarycolor,
                                                              size: 18,
                                                            )),
                                                        Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                3),
                                                          ),
                                                          child: Text(
                                                            homedata!
                                                                .trendingitems![
                                                            index]
                                                                .itemQty!
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                10.sp,color: themenofier.isdark
                                                                ? Colors.white
                                                                : color.primarycolor),
                                                          ),
                                                        ),
                                                        InkWell(
                                                            onTap:
                                                                () async {
                                                              if (homedata!
                                                                  .trendingitems![
                                                              index]
                                                                  .hasVariation ==
                                                                  "1" ||
                                                                  // ignore: prefer_is_empty
                                                                  homedata!
                                                                      .trendingitems![index]
                                                                      .addons!
                                                                      .length >
                                                                      0) {
                                                                cart = await Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          showvariation(
                                                                              homedata!.trendingitems![index]),
                                                                    ));

                                                                if (cart ==
                                                                    1) {
                                                                  setState(
                                                                          () {
                                                                        homedata!
                                                                            .trendingitems![
                                                                        index]
                                                                            .itemQty = int.parse(
                                                                            homedata!.trendingitems![index].itemQty) +
                                                                            1;
                                                                      });
                                                                }
                                                              } else {
                                                                addtocart(
                                                                    homedata!
                                                                        .trendingitems![
                                                                    index]
                                                                        .id,
                                                                    homedata!
                                                                        .trendingitems![
                                                                    index]
                                                                        .itemName,
                                                                    homedata!
                                                                        .trendingitems![
                                                                    index]
                                                                        .imageName,
                                                                    homedata!
                                                                        .trendingitems![
                                                                    index]
                                                                        .itemType,
                                                                    homedata!
                                                                        .trendingitems![
                                                                    index]
                                                                        .tax,
                                                                    homedata!
                                                                        .trendingitems![index]
                                                                        .price);
                                                              }
                                                            },
                                                            child: Icon(
                                                              Icons.add,
                                                              color: themenofier.isdark
                                                                  ? Colors.white
                                                                  : color.primarycolor,
                                                              size: 18,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              // Padding(
                                              //   padding: EdgeInsets.only(
                                              //       left: 2.w,
                                              //       right: 2.w,
                                              //       top: 1.h),
                                              //   child: Container(
                                              //     height: 3.6.h,
                                              //     width: 35.w,
                                              //     decoration: BoxDecoration(
                                              //       border: Border.all(
                                              //           color:
                                              //               color.primarycolor),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               5),
                                              //       // color: Theme.of(context).accentColor
                                              //     ),
                                              //     child: Row(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment
                                              //               .spaceAround,
                                              //       children: [
                                              //         InkWell(
                                              //             onTap: () async {
                                              //               if (homedata!
                                              //                           .trendingitems![
                                              //                               index]
                                              //                           .hasVariation ==
                                              //                       "1" ||
                                              //                   // ignore: prefer_is_empty
                                              //                   homedata!
                                              //                           .trendingitems![
                                              //                               index]
                                              //                           .addons!
                                              //                           .length >
                                              //                       0) {
                                              //                 cart = await Navigator
                                              //                         .of(
                                              //                             context)
                                              //                     .push(
                                              //                         MaterialPageRoute(
                                              //                   builder: (context) =>
                                              //                       showvariation(
                                              //                           homedata!
                                              //                               .trendingitems![index]),
                                              //                 ));
                                              //
                                              //                 // if (cart ==
                                              //                 //     1) {
                                              //                 //   setState(
                                              //                 //           () {
                                              //                 //         homedata!
                                              //                 //             .trendingitems![
                                              //                 //         index]
                                              //                 //             .itemQty = int.parse(homedata!
                                              //                 //             .trendingitems![index]
                                              //                 //             .itemQty) +
                                              //                 //             1;
                                              //                 //       });
                                              //                 // }
                                              //               }
                                              //               /*
                                              //             else {
                                              //               addtocart(
                                              //                   homedata!
                                              //                       .trendingitems![
                                              //                   index]
                                              //                       .id,
                                              //                   homedata!
                                              //                       .trendingitems![
                                              //                   index]
                                              //                       .itemName,
                                              //                   homedata!
                                              //                       .trendingitems![
                                              //                   index]
                                              //                       .imageName,
                                              //                   homedata!
                                              //                       .trendingitems![
                                              //                   index]
                                              //                       .itemType,
                                              //                   homedata!
                                              //                       .trendingitems![
                                              //                   index]
                                              //                       .tax,
                                              //                   homedata!
                                              //                       .trendingitems![
                                              //                   index]
                                              //                       .price);
                                              //             }
                                              //              */
                                              //             },
                                              //             child: Row(
                                              //               children: [
                                              //                 Icon(
                                              //                   Icons.add,
                                              //                   color: color
                                              //                       .primarycolor,
                                              //                   size: 18,
                                              //                 ),
                                              //                 Text(
                                              //                   "Add",
                                              //                   style: TextStyle(
                                              //                       color: color
                                              //                           .primarycolor),
                                              //                 )
                                              //               ],
                                              //             )),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),

                                            ],
                                          )
                                        ])),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (homedata!.banners!.bannersection1!.isNotEmpty) ...[
                            Container(
                              margin: EdgeInsets.only(top: 2.h),
                              height: 13.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    homedata!.banners!.bannersection1!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (homedata!.banners!
                                              .bannersection1![index].type ==
                                          "2") {
                                        Get.to(() => Product(int.parse(homedata!
                                            .banners!
                                            .bannersection1![index]
                                            .itemId)));
                                      } else if (homedata!.banners!
                                              .bannersection1![index].type ==
                                          "1") {
                                        Get.to(() => categories_items(
                                              homedata!.banners!
                                                  .bannersection1![index].catId,
                                              homedata!
                                                  .banners!
                                                  .bannersection1![index]
                                                  .categoryInfo!
                                                  .categoryName,
                                            ));
                                      }
                                    },
                                    child: Container(
                                        padding: EdgeInsets.only(
                                          left: 2.w,
                                          right: 2.w,
                                        ),
                                        width: 100.w,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: Image.network(
                                            homedata!.banners!
                                                .bannersection1![index].image
                                                .toString(),
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ),
                          ],
                          if (homedata!.todayspecial!.isNotEmpty) ...[
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 4.w,
                                    top: 2.h,
                                  ),
                                ),
                                Text(
                                  LocaleKeys.Todays_special.tr(),
                                  style: TextStyle(
                                      fontFamily: "Poppins_bold",
                                      fontSize: 15.sp,
                                      color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Trendingfood(
                                          "1",
                                          LocaleKeys.Todays_special.tr(),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 2.5.h,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              // padding: EdgeInsets.only(left: 1.w, right: 4.w),
                              height: 33.h,
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                  right: 3.w,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: homedata!.todayspecial!.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Product(
                                              homedata!
                                                  .todayspecial![index].id,homedata!
                                              .todayspecial![index])),
                                    );
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          border: Border.all(
                                              width: 0.8.sp,
                                              color:color.primarycolor)),
                                      margin: EdgeInsets.only(
                                        top: 1.h,
                                        left: 3.5.w,
                                      ),
                                      height: 32.h,
                                      width: 45.w,
                                      child: Column(children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 20.h,
                                              width: 46.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5))),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(5),
                                                        topRight:
                                                            Radius.circular(5)),
                                                child: Image.network(
                                                  homedata!.todayspecial![index]
                                                      .imageUrl
                                                      .toString(),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            if (homedata!.todayspecial![index]
                                                    .hasVariation ==
                                                "0") ...[
                                              if (homedata!.todayspecial![index]
                                                          .availableQty ==
                                                      "" ||
                                                  int.parse(homedata!
                                                          .todayspecial![index]
                                                          .availableQty
                                                          .toString()) <=
                                                      0) ...[
                                                Positioned(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 20.h,
                                                    width: 46.w,
                                                    color: Colors.black38,
                                                    child: Text(
                                                      LocaleKeys.Out_of_Stock
                                                          .tr(),
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'poppins_semibold',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                            Positioned(
                                                top: 5.0,
                                                right: 5.0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (userid == "") {
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                              MaterialPageRoute(
                                                                  builder: (c) =>
                                                                      Login()),
                                                              (r) => false);
                                                    } else if (homedata!
                                                            .todayspecial![
                                                                index]
                                                            .isFavorite ==
                                                        "0") {
                                                      managefavarite(
                                                          homedata!
                                                              .todayspecial![
                                                                  index]
                                                              .id,
                                                          "favorite",
                                                          index,
                                                          "todayspecial");
                                                    } else if (homedata!
                                                            .todayspecial![
                                                                index]
                                                            .isFavorite ==
                                                        "1") {
                                                      managefavarite(
                                                          homedata!
                                                              .todayspecial![
                                                                  index]
                                                              .id,
                                                          "unfavorite",
                                                          index,
                                                          "todayspecial");
                                                    }
                                                  },
                                                  child: Container(
                                                      height: 6.h,
                                                      width: 12.w,
                                                      decoration: BoxDecoration(
                                                          // shape: BoxShape.values,

                                                          ),
                                                      child: Center(
                                                        child: homedata!
                                                                    .todayspecial![
                                                                        index]
                                                                    .isFavorite ==
                                                                "0"
                                                            ? SvgPicture.asset(
                                                                'Icons/Favorite.svg',
                                                                // color: Colors
                                                                //     .white,
                                                              )
                                                            : SvgPicture.asset(
                                                                'Icons/Favoritedark.svg',
                                                                // color: Colors
                                                                //     .white,
                                                              ),
                                                      )),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 2.w,
                                                right: 2.w,
                                                top: 0.9.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    homedata!
                                                        .todayspecial![index]
                                                        .categoryInfo!
                                                        .categoryName
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 8.sp,
                                                      fontFamily: 'Poppins',
                                                       color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  if (homedata!
                                                          .todayspecial![index]
                                                          .itemType ==
                                                      "1") ...[
                                                    SizedBox(
                                                        height: 2.h,
                                                        // width: 16,
                                                        child: Image.asset(
                                                            Defaulticon
                                                                .vegicon))
                                                  ] else ...[
                                                    SizedBox(
                                                        height: 2.h,
                                                        // width: 16,
                                                        child: Image.asset(
                                                            Defaulticon
                                                                .nonvegicon))
                                                  ]
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 2.w,
                                                right: 2.w,
                                                top: 0.5.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      homedata!
                                                          .todayspecial![index]
                                                          .itemName
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily:
                                                            'Poppins_semibold',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 2.w,
                                                  right: 2.w,
                                                  top: 1.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (homedata!
                                                          .todayspecial![index]
                                                          .hasVariation ==
                                                      "1") ...[
                                                    Text(
                                                      currency_position == "1"
                                                          ? "$currency${numberFormat.format(double.parse(homedata!.todayspecial![index].variation![0].productPrice.toString()))}"
                                                          : "${numberFormat.format(double.parse(homedata!.todayspecial![index].variation![0].productPrice.toString()))}$currency",
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily:
                                                            'Poppins_bold',
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    Text(
                                                      currency_position == "1"
                                                          ? "$currency${numberFormat.format(double.parse(homedata!.todayspecial![index].price.toString()))}"
                                                          : "${numberFormat.format(double.parse(homedata!.todayspecial![index].price.toString()))}$currency",
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily:
                                                            'Poppins_bold',
                                                      ),
                                                    ),
                                                  ],
                                                  if (homedata!
                                                          .todayspecial![index]
                                                          .hasVariation ==
                                                      "0") ...[
                                                    if (homedata!
                                                                .todayspecial![
                                                                    index]
                                                                .availableQty ==
                                                            "" ||
                                                        int.parse(homedata!
                                                                .todayspecial![
                                                                    index]
                                                                .availableQty
                                                                .toString()) <=
                                                            0) ...[
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              border: Border.all(
                                                                   color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor)),
                                                          height: 3.5.h,
                                                          width: 17.w,
                                                          child: Center(
                                                            child: Text(
                                                              LocaleKeys.ADD
                                                                  .tr(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize:
                                                                      9.5.sp,
                                                                   color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ] else if (homedata!
                                                          .todayspecial![index]
                                                          .isCart ==
                                                      "0") ...[
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (homedata!
                                                                    .todayspecial![
                                                                        index]
                                                                    .hasVariation ==
                                                                "1" ||
                                                            homedata!
                                                                .todayspecial![
                                                                    index]
                                                                .addons!
                                                                .isNotEmpty) {
                                                          cart = await Get.to(
                                                              () => showvariation(
                                                                  homedata!
                                                                          .todayspecial![
                                                                      index]));
                                                          if (cart == 1) {
                                                            setState(() {
                                                              homedata!
                                                                  .todayspecial![
                                                                      index]
                                                                  .isCart = "1";
                                                              homedata!
                                                                  .todayspecial![
                                                                      index]
                                                                  .itemQty = int.parse(homedata!
                                                                      .todayspecial![
                                                                          index]
                                                                      .itemQty!
                                                                      .toString()) +
                                                                  1;
                                                            });
                                                          }
                                                        } else {
                                                          if (userid == "") {
                                                            Navigator.of(
                                                                    context)
                                                                .pushAndRemoveUntil(
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (c) =>
                                                                                Login()),
                                                                    (r) =>
                                                                        false);
                                                          } else {
                                                            addtocart(
                                                                homedata!
                                                                    .todayspecial![
                                                                        index]
                                                                    .id,
                                                                homedata!
                                                                    .todayspecial![
                                                                        index]
                                                                    .itemName,
                                                                homedata!
                                                                    .todayspecial![
                                                                        index]
                                                                    .imageName,
                                                                homedata!
                                                                    .todayspecial![
                                                                        index]
                                                                    .itemType,
                                                                homedata!
                                                                    .todayspecial![
                                                                        index]
                                                                    .tax,
                                                                homedata!
                                                                    .todayspecial![
                                                                        index]
                                                                    .price);
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              border: Border.all(
                                                                   color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor)),
                                                          height: 3.5.h,
                                                          width: 17.w,
                                                          child: Center(
                                                            child: Text(
                                                              LocaleKeys.ADD
                                                                  .tr(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize:
                                                                      9.5.sp,
                                                                  color: color
                                                                      .primarycolor),
                                                            ),
                                                          )),
                                                    ),
                                                  ] else if (homedata!
                                                          .todayspecial![index]
                                                          .isCart ==
                                                      "1") ...[
                                                    Container(
                                                      height: 3.6.h,
                                                      width: 22.w,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                             color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        // color: Theme.of(context).accentColor
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                loader
                                                                    .showErroDialog(
                                                                  description:
                                                                      LocaleKeys
                                                                              .The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item
                                                                          .tr(),
                                                                );
                                                              },
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: color
                                                                    .primarycolor,
                                                                size: 18,
                                                              )),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                            ),
                                                            child: Text(
                                                              homedata!
                                                                  .todayspecial![
                                                                      index]
                                                                  .itemQty!
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp),
                                                            ),
                                                          ),
                                                          InkWell(
                                                              onTap: () async {
                                                                if (homedata!
                                                                            .todayspecial![
                                                                                index]
                                                                            .hasVariation ==
                                                                        "1" ||
                                                                    // ignore: prefer_is_empty
                                                                    homedata!
                                                                            .todayspecial![index]
                                                                            .addons!
                                                                            .length >
                                                                        0) {
                                                                  cart = await Get.to(() =>
                                                                      showvariation(
                                                                          homedata!
                                                                              .todayspecial![index]));
                                                                  if (cart ==
                                                                      1) {
                                                                    setState(
                                                                        () {
                                                                      homedata!
                                                                          .todayspecial![
                                                                              index]
                                                                          .itemQty = int.parse(homedata!
                                                                              .todayspecial![index]
                                                                              .itemQty!
                                                                              .toString()) +
                                                                          1;
                                                                    });
                                                                  }
                                                                } else {
                                                                  addtocart(
                                                                      homedata!
                                                                          .todayspecial![
                                                                              index]
                                                                          .id,
                                                                      homedata!
                                                                          .todayspecial![
                                                                              index]
                                                                          .itemName,
                                                                      homedata!
                                                                          .todayspecial![
                                                                              index]
                                                                          .imageName,
                                                                      homedata!
                                                                          .todayspecial![
                                                                              index]
                                                                          .itemType,
                                                                      homedata!
                                                                          .todayspecial![
                                                                              index]
                                                                          .tax,
                                                                      homedata!
                                                                          .todayspecial![
                                                                              index]
                                                                          .price);
                                                                  // addtocart(
                                                                  //     index,
                                                                  //     "trending");
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons.add,
                                                                color: color
                                                                    .primarycolor,
                                                                size: 18,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 0.2.h,
                                            )
                                          ],
                                        )
                                      ])),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.5.h,
                            ),
                          ],
                          if (homedata!.banners!.bannersection2!.isNotEmpty) ...[
                            SizedBox(
                              height: 25.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    homedata!.banners!.bannersection2!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (homedata!.banners!
                                              .bannersection2![index].type ==
                                          "2") {
                                        Get.to(() => Product(int.parse(homedata!
                                            .banners!
                                            .bannersection2![index]
                                            .itemId)));
                                      } else if (homedata!.banners!
                                              .bannersection2![index].type ==
                                          "1") {
                                        Get.to(() => categories_items(
                                              homedata!.banners!
                                                  .bannersection2![index].catId,
                                              homedata!
                                                  .banners!
                                                  .bannersection2![index]
                                                  .categoryInfo!
                                                  .categoryName,
                                            ));
                                      }
                                    },
                                    child: Container(
                                        padding: EdgeInsets.only(
                                          left: 2.w,
                                          right: 2.w,
                                        ),
                                        width: 60.w,
                                        height: 60.w,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: Image.network(
                                            homedata!.banners!
                                                .bannersection2![index].image
                                                .toString(),
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ),
                          ],
                          // recommended
                          if (homedata!.recommendeditems!.isNotEmpty) ...[
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 4.w,
                                    top: 2.h,
                                  ),
                                ),
                                Text(
                                  LocaleKeys.Recommended.tr(),
                                  style: TextStyle(
                                      fontFamily: "Poppins_bold",
                                      fontSize: 15.sp,
                                       color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Trendingfood(
                                          "3",
                                          LocaleKeys.Recommended.tr(),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_outlined,
                                      size: 2.5.h,  color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 28.h,
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                  right: 3.w,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: homedata!.recommendeditems!.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Product(
                                              homedata!.recommendeditems![index]
                                                  .id,homedata!.recommendeditems![index])),
                                    );
                                  },
                                  child: Container(
                                    height: 28.h,
                                    width: 40.w,
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    child: Card(
                                      elevation: 3,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                            top: 1.h,
                                            left: 3.5.w,
                                          ),
                                          height: 32.h,
                                          width: 45.w,
                                          child: ListView(children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 10.h,
                                                  width: 46.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topLeft: Radius
                                                                  .circular(5),
                                                              topRight: Radius
                                                                  .circular(
                                                                      5))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5)),
                                                    child: Image.network(
                                                      homedata!
                                                          .recommendeditems![
                                                              index]
                                                          .imageUrl
                                                          .toString(),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                if (homedata!
                                                        .recommendeditems![
                                                            index]
                                                        .hasVariation ==
                                                    "0") ...[
                                                  if (homedata!
                                                              .recommendeditems![
                                                                  index]
                                                              .availableQty ==
                                                          "" ||
                                                      int.parse(homedata!
                                                              .recommendeditems![
                                                                  index]
                                                              .availableQty
                                                              .toString()) <=
                                                          0) ...[
                                                    Positioned(
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 20.h,
                                                        width: 46.w,
                                                        color: Colors.black38,
                                                        child: Text(
                                                          LocaleKeys
                                                                  .Out_of_Stock
                                                              .tr(),
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            color: themenofier.isdark
                                                                ? Colors.white
                                                                : color.primarycolor,
                                                            fontFamily:
                                                                'poppins_semibold',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]
                                                ],
                                                Positioned(
                                                    top: 0.0,
                                                    right: 0.0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (userid == "") {
                                                          Navigator.of(context)
                                                              .pushAndRemoveUntil(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (c) =>
                                                                              Login()),
                                                                  (r) => false);
                                                        } else if (homedata!
                                                                .recommendeditems![
                                                                    index]
                                                                .isFavorite ==
                                                            "0") {
                                                          managefavarite(
                                                              homedata!
                                                                  .recommendeditems![
                                                                      index]
                                                                  .id,
                                                              "favorite",
                                                              index,
                                                              "todayspecial");
                                                        } else if (homedata!
                                                                .recommendeditems![
                                                                    index]
                                                                .isFavorite ==
                                                            "1") {
                                                          managefavarite(
                                                              homedata!
                                                                  .recommendeditems![
                                                                      index]
                                                                  .id,
                                                              "unfavorite",
                                                              index,
                                                              "recommendeditems");
                                                        }
                                                      },
                                                      child: Container(
                                                          height: 6.h,
                                                          width: 12.w,
                                                          // decoration: BoxDecoration(
                                                          //   borderRadius:
                                                          //       BorderRadius
                                                          //           .circular(12),
                                                          //   color: Colors.black26,
                                                          // ),
                                                          child: Center(
                                                            child: homedata!
                                                                        .recommendeditems![
                                                                            index]
                                                                        .isFavorite ==
                                                                    "0"
                                                                ? SvgPicture
                                                                    .asset(
                                                                    'Icons/Favorite.svg',
                                                                color: themenofier.isdark
                                                                    ? Colors.white
                                                                    : color.primarycolor
                                                                  )
                                                                : SvgPicture
                                                                    .asset(
                                                                    'Icons/Favoritedark.svg',
                                                                color: themenofier.isdark
                                                                    ? Colors.white
                                                                    : color.primarycolor
                                                                  ),
                                                          )),
                                                    )),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 2.w,
                                                    right: 2.w,
                                                    top: 0.9.h,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          homedata!
                                                              .recommendeditems![
                                                                  index]
                                                              .categoryInfo!
                                                              .categoryName
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 8.sp,
                                                            fontFamily:
                                                                'Poppins',
                                                              color: themenofier.isdark
                                                                  ? Colors.white
                                                                  : color.primarycolor
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      if (homedata!
                                                              .trendingitems![
                                                                  index]
                                                              .itemType ==
                                                          "1") ...[
                                                        SizedBox(
                                                            height: 2.h,
                                                            // width: 16,
                                                            child: Image.asset(
                                                                Defaulticon
                                                                    .vegicon))
                                                      ] else ...[
                                                        SizedBox(
                                                            height: 2.h,
                                                            // width: 16,
                                                            child: Image.asset(
                                                                Defaulticon
                                                                    .nonvegicon))
                                                      ]
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 2.w,
                                                    right: 2.w,
                                                    top: 0.5.h,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          homedata!
                                                              .recommendeditems![
                                                                  index]
                                                              .itemName
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: themenofier.isdark
                                                                ? Colors.white
                                                                : color.black,
                                                            fontFamily:
                                                                'Poppins_semibold',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2.w,
                                                      right: 2.w,
                                                      top: 1.h),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      if (homedata!
                                                              .recommendeditems![
                                                                  index]
                                                              .hasVariation ==
                                                          "1") ...[
                                                        Text(
                                                          currency_position ==
                                                                  "1"
                                                              ? "$currency${numberFormat.format(double.parse(homedata!.recommendeditems![index].variation![0].productPrice.toString()))}"
                                                              : "${numberFormat.format(double.parse(homedata!.recommendeditems![index].variation![0].productPrice.toString()))}$currency",
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: themenofier.isdark
                                                                ? Colors.white
                                                                : color.primarycolor,
                                                            fontFamily:
                                                                'Poppins_bold',
                                                          ),
                                                        ),
                                                      ] else ...[
                                                        Text(
                                                          currency_position ==
                                                                  "1"
                                                              ? "$currency${numberFormat.format(double.parse(homedata!.recommendeditems![index].price.toString()))}"
                                                              : "${numberFormat.format(double.parse(homedata!.recommendeditems![index].price.toString()))}$currency",
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: themenofier.isdark
                                                                ? Colors.white
                                                                : color.primarycolor,
                                                            fontFamily:
                                                                'Poppins_bold',
                                                          ),
                                                        ),
                                                      ],

                                                    ],
                                                  ),

                                                ),
                                                SizedBox(
                                                  height: 0.2.h,
                                                ),
                                                if (homedata!
                                                    .recommendeditems![
                                                index]
                                                    .hasVariation ==
                                                    "0") ...[
                                                  if (homedata!
                                                      .recommendeditems![
                                                  index]
                                                      .availableQty ==
                                                      "" ||
                                                      int.parse(homedata!
                                                          .recommendeditems![
                                                      index]
                                                          .availableQty
                                                          .toString()) <=
                                                          0) ...[
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                4),
                                                            border: Border.all(
                                                                 color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor)),
                                                        height: 3.5.h,
                                                        width: 32.w,
                                                        child: Center(
                                                          child: Text(
                                                            LocaleKeys.ADD
                                                                .tr(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'Poppins',
                                                                fontSize:
                                                                9.5
                                                                    .sp,
                                                                color: themenofier.isdark
                                                                    ? Colors.white
                                                                    : color.primarycolor),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ] else if (homedata!
                                                    .recommendeditems![
                                                index]
                                                    .isCart ==
                                                    "0") ...[
                                                  GestureDetector(
                                                    onTap: () async {
                                                      if (homedata!
                                                          .recommendeditems![
                                                      index]
                                                          .hasVariation ==
                                                          "1" ||
                                                          homedata!
                                                              .recommendeditems![
                                                          index]
                                                              .addons!
                                                              .isNotEmpty) {
                                                        cart = await Get.to(() =>
                                                            showvariation(
                                                                homedata!
                                                                    .recommendeditems![
                                                                index]));
                                                        if (cart == 1) {
                                                          setState(() {
                                                            homedata!
                                                                .recommendeditems![
                                                            index]
                                                                .isCart = "1";
                                                            homedata!
                                                                .recommendeditems![
                                                            index]
                                                                .itemQty = int.parse(homedata!
                                                                .recommendeditems![
                                                            index]
                                                                .itemQty!
                                                                .toString()) +
                                                                1;
                                                          });
                                                        }
                                                      } else {
                                                        if (userid ==
                                                            "") {
                                                          Navigator.of(
                                                              context)
                                                              .pushAndRemoveUntil(
                                                              MaterialPageRoute(
                                                                  builder: (c) =>
                                                                      Login()),
                                                                  (r) =>
                                                              false);
                                                        } else {
                                                          addtocart(
                                                              homedata!
                                                                  .recommendeditems![
                                                              index]
                                                                  .id,
                                                              homedata!
                                                                  .recommendeditems![
                                                              index]
                                                                  .itemName,
                                                              homedata!
                                                                  .recommendeditems![
                                                              index]
                                                                  .imageName,
                                                              homedata!
                                                                  .recommendeditems![
                                                              index]
                                                                  .itemType,
                                                              homedata!
                                                                  .recommendeditems![
                                                              index]
                                                                  .tax,
                                                              homedata!
                                                                  .recommendeditems![
                                                              index]
                                                                  .price);
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                4),
                                                            border: Border.all(
                                                                 color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor)),
                                                        height: 3.5.h,
                                                        width: 32.w,
                                                        child: Center(
                                                          child: Text(
                                                            LocaleKeys.ADD
                                                                .tr(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'Poppins',
                                                                fontSize:
                                                                9.5
                                                                    .sp,
                                                                color: themenofier.isdark
                                                                    ? Colors.white
                                                                    : color.primarycolor),
                                                          ),
                                                        )),
                                                  ),
                                                ] else if (homedata!
                                                    .recommendeditems![
                                                index]
                                                    .isCart ==
                                                    "1") ...[
                                                  Container(
                                                    height: 3.6.h,
                                                    width: 32.w,
                                                    decoration:
                                                    BoxDecoration(
                                                      border: Border.all(
                                                           color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          5),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              loader
                                                                  .showErroDialog(
                                                                description:
                                                                LocaleKeys.The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item
                                                                    .tr(),
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .remove,
                                                              color: themenofier.isdark
                                                                  ? Colors.white
                                                                  : color.primarycolor,
                                                              size: 18,
                                                            )),
                                                        Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                3),
                                                          ),
                                                          child: Text(
                                                            homedata!
                                                                .recommendeditems![
                                                            index]
                                                                .itemQty!
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                10.sp,color: themenofier.isdark
                                                                ? Colors.white
                                                                : color.primarycolor),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                            onTap:
                                                                () async {
                                                              if (homedata!.recommendeditems![index].hasVariation ==
                                                                  "1" ||
                                                                  // ignore: prefer_is_empty
                                                                  homedata!.recommendeditems![index].addons!.length >
                                                                      0) {
                                                                cart = await Get.to(() =>
                                                                    showvariation(
                                                                        homedata!.recommendeditems![index]));
                                                                if (cart ==
                                                                    1) {
                                                                  setState(
                                                                          () {
                                                                        homedata!
                                                                            .recommendeditems![index]
                                                                            .itemQty = int.parse(homedata!.recommendeditems![index].itemQty!.toString()) + 1;
                                                                      });
                                                                }
                                                              } else {
                                                                addtocart(
                                                                    homedata!
                                                                        .recommendeditems![
                                                                    index]
                                                                        .id,
                                                                    homedata!
                                                                        .recommendeditems![
                                                                    index]
                                                                        .itemName,
                                                                    homedata!
                                                                        .recommendeditems![
                                                                    index]
                                                                        .imageName,
                                                                    homedata!
                                                                        .recommendeditems![
                                                                    index]
                                                                        .itemType,
                                                                    homedata!
                                                                        .recommendeditems![
                                                                    index]
                                                                        .tax,
                                                                    homedata!
                                                                        .recommendeditems![index]
                                                                        .price);
                                                              }
                                                            },
                                                            child: Icon(
                                                              Icons.add,
                                                              color: themenofier.isdark
                                                                  ? Colors.white
                                                                  : color.primarycolor,
                                                              size: 18,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            )
                                          ])),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.5.h,
                            ),
                          ],
                          if (homedata!.banners!.bannersection3!.isNotEmpty) ...[
                            Container(
                              margin: EdgeInsets.only(bottom: 2.h),
                              height: 13.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    homedata!.banners!.bannersection3!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (homedata!.banners!
                                              .bannersection3![index].type ==
                                          "2") {
                                        Get.to(() => Product(int.parse(homedata!
                                            .banners!
                                            .bannersection3![index]
                                            .itemId)));
                                      } else if (homedata!.banners!
                                              .bannersection3![index].type ==
                                          "1") {
                                        Get.to(() => categories_items(
                                              homedata!.banners!
                                                  .bannersection3![index].catId,
                                              homedata!
                                                  .banners!
                                                  .bannersection3![index]
                                                  .categoryInfo!
                                                  .categoryName,
                                            ));
                                      }
                                    },
                                    child: Container(
                                        padding: EdgeInsets.only(
                                          left: 2.w,
                                          right: 2.w,
                                        ),
                                        width: 100.w,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: Image.network(
                                            homedata!.banners!
                                                .bannersection3![index].image
                                                .toString(),
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ),
                          ],
                          if (homedata!.testimonials!.isNotEmpty) ...[
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 2.5.h, left: 4.w),
                                ),
                                Text(
                                  LocaleKeys.Testimonials,
                                  style: TextStyle(
                                      fontFamily: "Poppins_bold",
                                      fontSize: 15.sp),
                                ),
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                  top: 2.h,
                                  // bottom: 20,
                                  left: 4.w,
                                  right: 4.w,
                                ),
                                padding: EdgeInsets.only(
                                  top: 3.h,
                                  bottom: 1.5.h,
                                  left: 2.5.w,
                                  right: 2.5.w,
                                ),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: color.black,
                                ),
                                child: CarouselSlider.builder(
                                    itemCount: homedata!.testimonials!.length,
                                    itemBuilder: (context, index, realIndex) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                                homedata!.testimonials![index]
                                                    .profileImage
                                                    .toString()),
                                          ),
                                          SizedBox(
                                            height: 0.8.h,
                                          ),
                                          Text(
                                              homedata!
                                                  .testimonials![index].name
                                                  .toString(),
                                              style: TextStyle(
                                                  color: themenofier.isdark
                                                      ? Colors.white
                                                      : color.primarycolor,
                                                  fontSize: 12,
                                                  fontFamily: "Poppins")),
                                          SizedBox(
                                            height: 1.5.h,
                                          ),
                                          if (homedata!.testimonials![index]
                                                  .ratting ==
                                              "1") ...[
                                            SizedBox(
                                              child: Image.asset(
                                                "Image/ratting1.png",
                                                color: Colors.white,
                                                width: 25.w,
                                              ),
                                            )
                                          ] else if (homedata!
                                                  .testimonials![index]
                                                  .ratting ==
                                              "2") ...[
                                            Image.asset(
                                              "Image/ratting2.png",
                                              color: themenofier.isdark
                                                  ? Colors.white
                                                  : color.primarycolor,
                                              width: 25.w,
                                            )
                                          ] else if (homedata!
                                                  .testimonials![index]
                                                  .ratting ==
                                              "3") ...[
                                            Image.asset(
                                              "Image/ratting3.png",
                                              color: themenofier.isdark
                                                  ? Colors.white
                                                  : color.primarycolor,
                                              width: 25.w,
                                            )
                                          ] else if (homedata!
                                                  .testimonials![index]
                                                  .ratting ==
                                              "4") ...[
                                            Image.asset(
                                              "Image/ratting4.png",
                                              color: themenofier.isdark
                                                  ? Colors.white
                                                  : color.primarycolor,
                                              width: 25.w,
                                            )
                                          ] else if (homedata!
                                                  .testimonials![index]
                                                  .ratting ==
                                              "5") ...[
                                            Image.asset(
                                              "Image/ratting5.png",
                                              color: themenofier.isdark
                                                  ? Colors.white
                                                  : color.primarycolor,
                                              width: 25.w,
                                            )
                                          ],
                                          SizedBox(
                                            height: 1.5.h,
                                          ),
                                          Text(
                                            "${homedata!.testimonials![index].ratting.toString()} / 5.0 Reviews",
                                            style: TextStyle(
                                                color: themenofier.isdark
                                                    ? Colors.white
                                                    : color.primarycolor,
                                                fontSize: 9.sp,
                                                fontFamily: "Poppins"),
                                          ),
                                          SizedBox(
                                            height: 1.5.h,
                                          ),
                                          Text(
                                            homedata!
                                                .testimonials![index].comment
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: themenofier.isdark
                                                    ? Colors.white
                                                    : color.primarycolor,
                                                fontSize: 12,
                                                fontFamily: "Poppins"),
                                          ),
                                        ],
                                      );
                                    },
                                    options: CarouselOptions(
                                      enableInfiniteScroll: true,
                                      disableCenter: true,
                                      viewportFraction: 1,
                                    ))),
                            SizedBox(height: 3.h),
                          ],
                          // if (homedata!.appdata!.isAppBottomImage.toString() ==
                          //     "1") ...[
                          //   SizedBox(
                          //     width: double.infinity,
                          //     child: Image.network(
                          //       homedata!.appdata!.appBottomImageUrl.toString(),
                          //       height: MediaQuery.of(context).size.height / 2,
                          //       fit: BoxFit.fill,
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                     color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor,
                    // color: Colors.red,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// final http.Response httpresponse = await http.post(
//   Uri.parse(
//     DefaultApi.appUrl + PostAPI.Home,
//   ),
//   body: map,
//
// homedata = homescreenmodel.fromJson(jsonDecode(httpresponse.body));
// print("object");
