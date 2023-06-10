// ignore_for_file: must_be_immutable, prefer_const_constructors, unrelated_type_equality_checks, unused_import, prefer_final_fields, camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names
import 'dart:collection';
import 'dart:ffi';

// import 'package:singlegrocery/Model/favorite/itemmodel.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/model/favorite/itemmodel.dart';
import 'package:singlegrocery/pages/Subscription_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/model/favorite/addtocartmodel.dart';
import 'package:singlegrocery/pages/authentication/Login.dart';
import 'package:singlegrocery/model/cart/qtyupdatemodel.dart';
import 'package:singlegrocery/model/home/itemdetailsmodel.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:singlegrocery/common%20class/allformater.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/common%20class/icons.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:singlegrocery/pages/Favorite/showvariation.dart';
import 'package:singlegrocery/pages/Home/homepage.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import '../../model/home/SubscriptionTypeModel.dart' as sub;
import '../../theme/ThemeModel.dart';
import '../cart/cartpage.dart';
import 'custom.dart';

class buttoncontroller extends GetxController {
  RxInt variationselecationindex = 0.obs;
  RxInt status = 0.obs;
  RxInt sub_id = 0.obs;
  RxDouble total = 0.0.obs;
  RxInt nextdaysinmonth = 0.obs;
  RxDouble price = 0.0.obs;
  RxInt daysinmonth = 0.obs;
  RxInt remaindaysinmonth = 0.obs;
  RxString sub_str="Daily".obs;
  RxString selectday="".obs;
  RxString date="".obs;
  RxString enddate="".obs;
  RxBool sub_status = false.obs;
  Rx<DateTime> tom_date=DateTime.now().obs;
  RxList<sub.Data> listdata=<sub.Data>[].obs;
  RxList<PickerDateRange> daterange=<PickerDateRange>[].obs;
  RxList<DateTime> alter_dateTime=<DateTime>[].obs;
  RxList<String> temp_dateTime=<String>[].obs;
  RxList<String> temp_day=<String>[].obs;
  RxList<int> temp_qty=<int>[].obs;
  RxList<Map> day_qty=<Map>[].obs;
  RxList<int> monthlist=<int>[].obs;
  RxList<bool> selectdayvisible=<bool>[].obs;
  RxList<int> counts = [1,1,1,1,1,1,1].obs;
  RxList<String> daylist = [LocaleKeys.sunday,LocaleKeys.monday,LocaleKeys.tuesday,LocaleKeys.wednesday,LocaleKeys.thursday,LocaleKeys.friday,LocaleKeys.saturdat].obs;
  RxList<String> customdaylist = <String>[].obs;
}
class Product extends StatefulWidget {
  int? itemid;
  itemmodel? item;

  @override
  State<Product> createState() => _ProductState();
  Product([
    this.itemid,this.item
  ]);
}

class _ProductState extends State<Product> {
  DateRangePickerController _datePickerController = DateRangePickerController();
  String? userid = "";
  int? cart;
  itemdetailsmodel? itemdata;
  sub.SubscriptionType? SubscriptionTypemodel;
  buttoncontroller select = Get.put(buttoncontroller());
  cartcount count = Get.put(cartcount());
  bool? isproductdetail = true;
  bool? issubscriptiondetail = true;
  String? currency;
  String? currency_position;
  List<String> arr_addonsid = [];
  List<String> arr_addonsname = [];
  List<String> arr_addonsprice = [];

  @override
  void initState() {
    super.initState();
    subscriptionAPI();
    date();
    print("model=${widget.item}");
    select.variationselecationindex.value=0;
  }
  date()
  {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day+1);
    select.tom_date.value=date;
    select.date.value="${date.day}-${date.month}-${date.year}";
    _datePickerController.selectedDate =date;
    select.daysinmonth.value = DateUtils.getDaysInMonth(date.year, date.month);
    select.nextdaysinmonth.value = DateUtils.getDaysInMonth(date.year, date.month+1);
    select.remaindaysinmonth.value=select.daysinmonth.value-date.day;
    select.daterange.value=[];
    select.monthlist.value=[];
    select.alter_dateTime.value=[];


  }

  addtocartmodel? addtocartdata;
  addtocart(itemid, itemname, itemimage, itemtype, itemtax, itemprice) async {
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
        "variation": "",
        "addons_id": "",
        "addons_name": "",
        "addons_price": "",
        "addons_total_price": numberFormat.format(double.parse("0")),
        "subscription_id": "",
        "start_date": "",
        "end_date": "",
        "custom_day":[],
      };

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Addtocart, data: map);

      addtocartdata = addtocartmodel.fromJson(response.data);
      if (addtocartdata!.status == 1) {
        isproductdetail = true;
        loader.hideLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(APPcart_count, addtocartdata!.cartCount.toString());

        count.cartcountnumber(int.parse(prefs.getString(APPcart_count)!));
        // setState(() {});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future itemdetailsAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = (prefs.getString(UD_user_id) ?? "");
    currency = (prefs.getString(APPcurrency) ?? "");
    currency_position = (prefs.getString(APPcurrency_position) ?? "");
    loader.showLoading();
    try {
      var map = {
        "user_id": userid ?? "",
        "item_id": widget.itemid,
      };

      var response = await Dio().post(DefaultApi.appUrl + PostAPI.Itemdetails, data: map);


      isproductdetail = false;

      // log("Hiiii${jsonEncode(response.data)}");
      // var finalist = await response.data;
      print(response.data);
      itemdata = itemdetailsmodel.fromJson(response.data);
      // log("Hiiii${itemdata}");
      loader.hideLoading();
      return itemdata;
    } catch (e) {
      rethrow;
    }
  }
  Future subscriptionAPI() async {
    print("hello");
    try {
      var response = await Dio().get(DefaultApi.appUrl + PostAPI.subscriptionDetails);
      issubscriptiondetail = false;
      SubscriptionTypemodel = sub.SubscriptionType.fromJson(response.data);
      select.listdata.value=SubscriptionTypemodel!.data!;
      select.status.value=SubscriptionTypemodel!.status!;
      // log("Hiiii${itemdata}");
      loader.hideLoading();
       // return response.data;
    } catch (e) {
      print("$e");
      rethrow;
    }
  }
  removefavarite(String isfavorite, String itemid) async {
    try {
      loader.showLoading();
      var map = {"user_id": userid, "item_id": itemid, "type": isfavorite};
      var response = await Dio()
          .post(DefaultApi.appUrl + PostAPI.Managefavorite, data: map);
      var finaldata = QTYupdatemodel.fromJson(response.data);
      if (finaldata.status == 1) {
        setState(() {
          isproductdetail = true;
        });

        loader.hideLoading();
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
              child: FutureBuilder(
                future: isproductdetail == true ? itemdetailsAPI() : null,
                builder: (context, snapshot) {
                  // print("====${snapshot}");
                  if (!snapshot.hasData) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(
                          color: color.primarycolor,
                        ),
                      ),
                    );
                  }
                  else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("${snapshot.error}");
                  }
                  else {
                    print("snap=${itemdata!.data!.variation}==${select
                        .variationselecationindex.value}");
                    if (itemdata!.data!.hasVariation == "1") {
                      select.price.value = double.parse(
                          itemdata!.data!.variation![select
                              .variationselecationindex.value].productPrice!);
                    }
                    else {
                      select.price.value =
                          double.parse(itemdata!.data!.price.toString());
                    }

                    return Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          leadingWidth: 40,
                          leading: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_outlined,
                                size: 20,
                              )),
                          actions: [
                            Container(
                              height: 5.5.h,
                              width: 5.5.h,
                              padding:
                              EdgeInsets.all(MediaQuery
                                  .of(context)
                                  .size
                                  .height / 80),
                              // margin: EdgeInsets.only(left: 86.w, top: 1.5.h),
                              // decoration: BoxDecoration(
                              //   // shape: BoxShape.values,
                              //   borderRadius: BorderRadius.circular(6),
                              //   color: color.black,
                              // ),
                              child: InkWell(
                                onTap: () {
                                  if (userid == "") {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (c) => Login()),
                                            (r) => false);
                                  } else
                                  if (itemdata!.data!.isFavorite == "0") {
                                    removefavarite(
                                        "favorite", widget.itemid.toString());
                                  } else {
                                    removefavarite(
                                        "unfavorite",
                                        widget.itemid.toString());
                                  }
                                },
                                child: itemdata!.data!.isFavorite == "0"
                                    ? SvgPicture.asset(
                                  'Icons/Favorite.svg',color: themenofier.isdark
                                    ? Colors.white
                                    : color.primarycolor
                                  // color: Colors.white,
                                )
                                    : SvgPicture.asset(
                                  'Icons/Favoritedark.svg',
                                  // color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        body: Stack(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 30.h,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      // color: color.primarycolor,
                                      child: ClipRRect(
                                        child: Image.network(
                                          itemdata!.data!.itemImages![0]
                                              .imageUrl
                                              .toString(),
                                          fit: BoxFit.contain,
                                        ),
                                      )),
                                  Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 4.w, top: 7.3.h)),
                                      if (itemdata!.data!.itemType == "1") ...[
                                        SizedBox(
                                          height: 3.h,
                                          child: Image.asset(
                                            Defaulticon.vegicon,
                                          ),
                                        ),
                                      ] else
                                        ...[
                                          SizedBox(
                                            height: 3.h,
                                            child: Image.asset(
                                              Defaulticon.nonvegicon,
                                            ),
                                          ),
                                        ],
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Expanded(
                                        child: Text(
                                          itemdata!.data!.itemName.toString(),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontFamily: 'Poppins_semibold',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 4.w, right: 4.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          itemdata!.data!.categoryInfo!
                                              .categoryName!,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontFamily: 'Poppins',
                                            color: themenofier.isdark
                                                ? Colors.white
                                                : color.primarycolor,
                                          ),
                                        ),
                                        Text(
                                          itemdata!.data!.preparationTime!,
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              fontFamily: 'Poppins',
                                              color: color.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                          left: 4.w,
                                        )),
                                    if (itemdata!.data!.hasVariation ==
                                        "1") ...[
                                      Text(
                                        currency_position == "1"
                                            ? "$currency${numberFormat.format(
                                            double.parse(itemdata!.data!
                                                .variation![select
                                                .variationselecationindex.value]
                                                .productPrice.toString()))}"
                                            : "${numberFormat.format(
                                            double.parse(itemdata!.data!
                                                .variation![select
                                                .variationselecationindex.value]
                                                .productPrice
                                                .toString()))}$currency",
                                        style: TextStyle(
                                          fontSize: 21.sp,
                                          fontFamily: 'Poppins_bold',
                                        ),
                                      ),
                                      if (itemdata!.data!.tax == "" ||
                                          itemdata!.data!.tax == "0") ...[
                                        Text(
                                          LocaleKeys.Inclusive_of_all_taxes
                                              .tr(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 8.sp,
                                            color: themenofier.isdark
                                                ? Colors.white
                                                : color.primarycolor,
                                          ),
                                        ),
                                      ]
                                      else
                                        ...[
                                          Text(
                                            "${itemdata!.data!
                                                .tax}% ${LocaleKeys
                                                .additional_tax.tr()}",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 8.sp,
                                              color: themenofier.isdark
                                                  ? Colors.white
                                                  : color.primarycolor,
                                            ),
                                          ),
                                        ]
                                    ] else
                                      ...[
                                        Text(
                                          currency_position == "1"
                                              ? "$currency${numberFormat.format(
                                              double.parse(itemdata!.data!.price
                                                  .toString()))}"
                                              : "${numberFormat.format(
                                              int.parse(itemdata!.data!.price
                                                  .toString()))}$currency",
                                          style: TextStyle(
                                            fontSize: 21.sp,
                                            fontFamily: 'Poppins_bold',
                                          ),
                                        ),
                                        if (itemdata!.data!.tax == "" ||
                                            itemdata!.data!.tax == "0") ...[
                                          Text(
                                            LocaleKeys.Inclusive_of_all_taxes
                                                .tr(),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 8.sp,
                                              color: themenofier.isdark
                                                  ? Colors.white
                                                  : color.primarycolor,
                                            ),
                                          ),
                                        ]
                                        else
                                          ...[
                                            Text(
                                              "${itemdata!.data!
                                                  .tax}% ${LocaleKeys
                                                  .additional_tax.tr()}",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 8.sp,
                                                color: themenofier.isdark
                                                    ? Colors.white
                                                    : color.primarycolor,
                                              ),
                                            ),
                                          ]
                                      ],
                                    Spacer(),
                                    // Container(
                                    //   margin: EdgeInsets.only(right: 4.w),
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(8),
                                    //   ),
                                    //   height: 3.5.h,
                                    //   width: 25.w,
                                    //   child: InkWell(
                                    //     onTap: () {
                                    //       arr_addonsid.clear();
                                    //       arr_addonsname.clear();
                                    //       arr_addonsprice.clear();
                                    //       for (int i = 0;
                                    //       i < itemdata!.data!.addons!.length;
                                    //       i++) {
                                    //         if (itemdata!.data!.addons![i].isselected ==
                                    //             true) {
                                    //           arr_addonsid.add(
                                    //               itemdata!.data!.addons![i].id.toString());
                                    //           arr_addonsname.add(
                                    //               itemdata!.data!.addons![i].name.toString());
                                    //           arr_addonsprice.add(numberFormat.format(
                                    //               double.parse(itemdata!
                                    //                   .data!.addons![i].price
                                    //                   .toString())));
                                    //         }
                                    //       }
                                    //
                                    //       add_to_cartAPI();
                                    //     },
                                    //     child: Container(
                                    //       decoration: BoxDecoration(
                                    //           borderRadius:
                                    //           BorderRadius
                                    //               .circular(
                                    //               4),
                                    //           border: Border.all(
                                    //               color: color.primarycolor)),
                                    //       height: 3.5.h,
                                    //       width: 32.w,
                                    //       child: Center(
                                    //         child: Text(
                                    //           LocaleKeys.ADD
                                    //               .tr(),
                                    //           style: TextStyle(
                                    //               fontFamily:
                                    //               'Poppins',
                                    //               fontSize:
                                    //               9.5
                                    //                   .sp,
                                    //               color: color
                                    //                   .primarycolor),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(
                                        left: 4.w,
                                        right: 4.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          /*if (itemdata!.data!.hasVariation == "1") ...[
                                            Text(
                                              textAlign: TextAlign.center,
                                              "${itemdata!.data!
                                                  .variation![select
                                                  .variationselecationindex
                                                  .value].availableQty}",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 10.sp,
                                                // color: color.grey,
                                              ),
                                            ),

                                          ]
                                          else
                                            ...[
                                              Text(
                                                LocaleKeys.Out_of_Stock.tr(),
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 8.sp,
                                                  color: color.grey,
                                                ),
                                              ),
                                            ],*/
                                          // Text("${itemdata!.data!.itemQty}"),
                                          // if (itemdata!.data!.itemQty == "" ||
                                          //     double.parse(itemdata!.data!.itemQty
                                          //         .toString()) <=
                                          //         0) ...[
                                          //   Text(
                                          //     LocaleKeys.Out_of_Stock.tr(),
                                          //     style: TextStyle(
                                          //       fontFamily: 'Poppins',
                                          //       fontSize: 8.sp,
                                          //       color: color.grey,
                                          //     ),
                                          //   ),
                                          // ]
                                          // else if (itemdata!.data!.tax == "" ||
                                          //     itemdata!.data!.tax == "0") ...[
                                          //   Text(
                                          //     LocaleKeys.Inclusive_of_all_taxes.tr(),
                                          //     style: TextStyle(
                                          //       fontFamily: 'Poppins',
                                          //       fontSize: 8.sp,
                                          //       color: color.primarycolor,
                                          //     ),
                                          //   ),
                                          // ]
                                          // else ...[
                                          //   Text(
                                          //     "${itemdata!.data!.tax}% ${LocaleKeys.additional_tax.tr()}",
                                          //     style: TextStyle(
                                          //       fontFamily: 'Poppins',
                                          //       fontSize: 8.sp,
                                          //       color: color.primarycolor,
                                          //     ),
                                          //   ),
                                          // ]
                                        ],
                                      )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 4.w,
                                      right: 4.w,
                                      top: 1.h,
                                    ),
                                    child: Text(
                                      LocaleKeys.Description,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: 'Poppins_semibold'),
                                    ),
                                  ),
                                  if (itemdata!.data!.itemDescription == "" ||
                                      itemdata!.data!.itemDescription ==
                                          null) ...[
                                    Container(
                                      margin:
                                      EdgeInsets.only(
                                          left: 4.w, top: 1.h, right: 4.w),
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        " - ",
                                        style: TextStyle(
                                            fontSize: 10.5.sp,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                  ] else
                                    ...[
                                      Container(
                                        margin:
                                        EdgeInsets.only(
                                            left: 4.w, top: 1.h, right: 4.w),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          itemdata!.data!.itemDescription!,
                                          style: TextStyle(
                                              fontSize: 10.5.sp,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                    ],
                                  if (itemdata!.data!.hasVariation == "1") ...[
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 4.w,
                                          top: 2.h,
                                          bottom: 1.h,
                                          right: 4.w),
                                      child: Text(
                                        itemdata!.data!.attribute!,
                                        style: TextStyle(
                                            fontFamily: 'Poppins_bold',
                                            fontSize: 15.sp),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(0),
                                      height: itemdata!.data!.variation!
                                          .length * 6.5.h,
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: itemdata!.data!.variation!
                                            .length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: 5.w,
                                                bottom: 1.h,
                                                right: 5.w),
                                            child: InkWell(
                                              onTap: () {
                                                select.variationselecationindex(
                                                    index);
                                                select.price.value =
                                                    double.parse(itemdata!.data!
                                                        .variation![select
                                                        .variationselecationindex
                                                        .value].productPrice!);
                                              },
                                              child: Row(
                                                children: [
                                                  Obx(
                                                        () =>
                                                        Container(
                                                          height: 3.3.h,
                                                          width: 3.3.h,
                                                          decoration: BoxDecoration(
                                                              color:
                                                              select
                                                                  .variationselecationindex ==
                                                                  index
                                                                  ? color
                                                                  .primarycolor
                                                                  : Colors
                                                                  .transparent,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                              border: Border
                                                                  .all(
                                                                  color: color
                                                                      .primarycolor)),
                                                          child: Icon(
                                                              Icons.done,
                                                              color:
                                                              select
                                                                  .variationselecationindex ==
                                                                  index
                                                                  ? Colors.white
                                                                  : Colors
                                                                  .transparent,
                                                              size: 13.sp),
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      if (itemdata!.data!
                                                          .variation![index]
                                                          .availableQty == "" ||
                                                          int.parse(itemdata!
                                                              .data!
                                                              .variation![index]
                                                              .availableQty
                                                              .toString()) <=
                                                              0) ...
                                                      [
                                                        Text(
                                                          itemdata!.data!
                                                              .variation![index]
                                                              .variation!,
                                                          style: TextStyle(
                                                            fontSize: 11.sp,
                                                            fontFamily: 'Poppins_semibold',
                                                            color: color.grey,
                                                          ),
                                                        ),
                                                        Text(
                                                          currency_position ==
                                                              "1"
                                                              ? "$currency${numberFormat
                                                              .format(
                                                              double.parse(
                                                                  itemdata!
                                                                      .data!
                                                                      .variation![index]
                                                                      .productPrice!))} ${LocaleKeys
                                                              .Out_of_Stock
                                                              .tr()}"
                                                              : "${numberFormat
                                                              .format(
                                                              double.parse(
                                                                  itemdata!
                                                                      .data!
                                                                      .variation![index]
                                                                      .productPrice!))}$currency ${LocaleKeys
                                                              .Out_of_Stock
                                                              .tr()}",
                                                          style: TextStyle(
                                                            fontSize: 8.sp,
                                                            fontFamily: 'Poppins',
                                                            color: color.grey,
                                                          ),
                                                        )
                                                      ] else
                                                        ...[
                                                          Text(
                                                            itemdata!.data!
                                                                .variation![index]
                                                                .variation!,
                                                            style: TextStyle(
                                                              fontSize: 11.sp,
                                                              fontFamily: 'Poppins_semibold',
                                                            ),
                                                          ),
                                                          Text(
                                                            currency_position ==
                                                                "1"
                                                                ? "$currency${numberFormat
                                                                .format(
                                                                double.parse(
                                                                    itemdata!
                                                                        .data!
                                                                        .variation![index]
                                                                        .productPrice!))}"
                                                                : "${numberFormat
                                                                .format(
                                                                double.parse(
                                                                    itemdata!
                                                                        .data!
                                                                        .variation![index]
                                                                        .productPrice!))}$currency",
                                                            style: TextStyle(
                                                                fontSize: 8.sp,
                                                                fontFamily: 'Poppins'),
                                                          )
                                                        ]
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                  if (itemdata!.data!.addons!.isNotEmpty) ...[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(
                                          left: 4.w, bottom: 1.h, right: 4.w),
                                      child: Text(
                                        LocaleKeys.Add_ons.tr(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins_bold',
                                            fontSize: 15.sp),
                                      ),
                                    ),
                                    SizedBox(
                                      height: itemdata!.data!.addons!.length *
                                          6.5.h,
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: itemdata!.data!.addons!
                                            .length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: 5.w,
                                                bottom: 1.h,
                                                right: 5.w),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  var addonobject =
                                                  itemdata!.data!
                                                      .addons![index];

                                                  addonobject.isselected == true
                                                      ?
                                                  addonobject.isselected = false
                                                      : addonobject.isselected =
                                                  true;

                                                  itemdata!.data!.addons!
                                                      .removeAt(index);

                                                  itemdata!.data!.addons!
                                                      .insert(
                                                      index, addonobject);
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 3.3.h,
                                                    width: 3.3.h,
                                                    decoration: BoxDecoration(
                                                        color: itemdata!
                                                            .data!
                                                            .addons![index]
                                                            .isselected ==
                                                            false
                                                            ? Colors.transparent
                                                            : color
                                                            .primarycolor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                        border:
                                                        Border.all(color: color
                                                            .primarycolor)),
                                                    child: Icon(Icons.done,
                                                        color: itemdata!
                                                            .data!
                                                            .addons![index]
                                                            .isselected ==
                                                            false
                                                            ? Colors.transparent
                                                            : Colors.white,
                                                        size: 13.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        itemdata!
                                                            .data!
                                                            .addons![index]
                                                            .name!,
                                                        style: TextStyle(
                                                          fontSize: 11.sp,
                                                          fontFamily: 'Poppins_semibold',
                                                        ),
                                                      ),
                                                      Text(
                                                        currency_position == "1"
                                                            ? "$currency${numberFormat
                                                            .format(double
                                                            .parse(
                                                            itemdata!.data!
                                                                .addons![index]
                                                                .price
                                                                .toString()))}"
                                                            : "${numberFormat
                                                            .format(double
                                                            .parse(
                                                            itemdata!.data!
                                                                .addons![index]
                                                                .price
                                                                .toString()))}$currency",
                                                        style: TextStyle(
                                                            fontSize: 8.sp,
                                                            fontFamily: 'Poppins'),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                  if (itemdata!.relateditems!.isNotEmpty) ...[
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 4.w,
                                        right: 4.w,
                                        bottom: 1.h,
                                        top: 1.h,
                                      ),
                                      child: Text(
                                        LocaleKeys.Related_roducts.tr(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins_semibold',
                                            fontSize: 14.5.sp,),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 2.w, right: 2.w),
                                      height: 28.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: itemdata!.relateditems!
                                            .length,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Product(
                                                              itemdata!
                                                                  .relateditems![index]
                                                                  .id,
                                                              itemdata!
                                                                  .relateditems![index])),
                                                );
                                              },
                                              child: Container(
                                                // decoration: BoxDecoration(
                                                //     borderRadius: BorderRadius.circular(7),
                                                // border: Border.all(
                                                //     width: 0.8.sp, color: Colors.grey)
                                                // ),

                                                // margin: EdgeInsets.only(bottom: 2.h),
                                                  height: 28.h,
                                                  width: 40.w,
                                                  child: Card(
                                                    elevation: 3,
                                                    child: Column(children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            height: 10.h,
                                                            width: 46.w,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        5),
                                                                    topRight:
                                                                    Radius
                                                                        .circular(
                                                                        5))),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                      5),
                                                                  topRight: Radius
                                                                      .circular(
                                                                      5)),
                                                              child: Image
                                                                  .network(
                                                                itemdata!
                                                                    .relateditems![index]
                                                                    .imageUrl!,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ),
                                                          if (itemdata!
                                                              .relateditems![index]
                                                              .hasVariation ==
                                                              "0") ...[
                                                            if (itemdata!
                                                                .relateditems![index]
                                                                .availableQty ==
                                                                "" ||
                                                                int.parse(
                                                                    itemdata!
                                                                        .relateditems![index]
                                                                        .availableQty
                                                                        .toString()) <=
                                                                    0) ...[
                                                              Positioned(
                                                                child: Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  height: 20.h,
                                                                  width: 46.w,
                                                                  color: Colors
                                                                      .black38,
                                                                  child: Text(
                                                                    LocaleKeys
                                                                        .Out_of_Stock
                                                                        .tr(),
                                                                    style: TextStyle(
                                                                      fontSize: 15
                                                                          .sp,
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                      'poppins_semibold',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                          ],
                                                          Positioned(
                                                              right: 0.0,
                                                              top: 0.0,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  if (userid ==
                                                                      "") {
                                                                    Navigator
                                                                        .of(
                                                                        context)
                                                                        .pushAndRemoveUntil(
                                                                        MaterialPageRoute(
                                                                            builder: (
                                                                                c) =>
                                                                                Login()),
                                                                            (
                                                                            r) => false);
                                                                  } else
                                                                  if (itemdata!
                                                                      .relateditems![index]
                                                                      .isFavorite ==
                                                                      "0") {
                                                                    removefavarite(
                                                                        "favorite",
                                                                        itemdata!
                                                                            .relateditems![index]
                                                                            .id
                                                                            .toString());
                                                                  } else {
                                                                    removefavarite(
                                                                        "unfavorite",
                                                                        itemdata!
                                                                            .relateditems![index]
                                                                            .id
                                                                            .toString());
                                                                  }
                                                                },
                                                                child: Container(
                                                                    height: 6.h,
                                                                    width: 12.w,
                                                                    padding: EdgeInsets
                                                                        .all(
                                                                        9.sp),
                                                                    // margin: EdgeInsets.only(
                                                                    //     left: 30.5.w,
                                                                    //     top: MediaQuery.of(context)
                                                                    //             .size
                                                                    //             .height /
                                                                    //         99),
                                                                    // decoration: BoxDecoration(
                                                                    //   // shape: BoxShape.values,
                                                                    //   borderRadius:
                                                                    //   BorderRadius.circular(
                                                                    //       12),
                                                                    //   color: Colors.black26,
                                                                    // ),
                                                                    child: itemdata!
                                                                        .relateditems![
                                                                    index]
                                                                        .isFavorite ==
                                                                        "0"
                                                                        ? SvgPicture
                                                                        .asset(
                                                                      'Icons/Favorite.svg',
                                                                      color: themenofier.isdark
                                                                          ? Colors.white
                                                                          : color.primarycolor,
                                                                    )
                                                                        : SvgPicture
                                                                        .asset(
                                                                      'Icons/Favoritedark.svg',
                                                                      color: themenofier.isdark
                                                                          ? Colors.white
                                                                          : color.primarycolor,
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
                                                            padding: EdgeInsets
                                                                .only(
                                                                left: 2.w,
                                                                right: 2.w,
                                                                top: 1.h),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  itemdata!
                                                                      .relateditems![index]
                                                                      .categoryInfo!
                                                                      .categoryName!,
                                                                  style: TextStyle(
                                                                      fontSize: 8.5
                                                                          .sp,
                                                                      fontFamily: 'Poppins',
                                                                      color: color
                                                                          .primarycolor,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                                Spacer(),
                                                                if (itemdata!
                                                                    .relateditems![index]
                                                                    .itemType ==
                                                                    "1") ...[
                                                                  SizedBox(
                                                                    height: 2.4
                                                                        .h,
                                                                    child: Image
                                                                        .asset(
                                                                      Defaulticon
                                                                          .vegicon,
                                                                    ),
                                                                  ),
                                                                ] else
                                                                  ...[
                                                                    SizedBox(
                                                                      height: 2.4
                                                                          .h,
                                                                      child: Image
                                                                          .asset(
                                                                        Defaulticon
                                                                            .nonvegicon,
                                                                      ),
                                                                    ),
                                                                  ],
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .only(
                                                              left: 2.w,
                                                              right: 2.w,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    itemdata!
                                                                        .relateditems![index]
                                                                        .itemName!,
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontFamily: 'Poppins',
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .only(
                                                                left: 2.w,
                                                                right: 2.w,
                                                                top: 1.3.h),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                if (itemdata!
                                                                    .relateditems![index]
                                                                    .hasVariation ==
                                                                    "1") ...[
                                                                  Text(
                                                                    currency_position ==
                                                                        "1"
                                                                        ? "$currency${numberFormat
                                                                        .format(
                                                                        double
                                                                            .parse(
                                                                            itemdata!
                                                                                .relateditems![index]
                                                                                .variation![0]
                                                                                .productPrice
                                                                                .toString()))}"
                                                                        : "${numberFormat
                                                                        .format(
                                                                        double
                                                                            .parse(
                                                                            itemdata!
                                                                                .relateditems![index]
                                                                                .variation![0]
                                                                                .productPrice
                                                                                .toString()))}$currency",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontFamily:
                                                                        'Poppins_bold',
                                                                        color: themenofier.isdark ? Colors.white : color.primarycolor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                  ),
                                                                ] else
                                                                  ...[
                                                                    Text(
                                                                      currency_position ==
                                                                          "1"
                                                                          ? "$currency${numberFormat
                                                                          .format(
                                                                          double
                                                                              .parse(
                                                                              itemdata!
                                                                                  .relateditems![index]
                                                                                  .price
                                                                                  .toString()))}"
                                                                          : "${numberFormat
                                                                          .format(
                                                                          double
                                                                              .parse(
                                                                              itemdata!
                                                                                  .relateditems![index]
                                                                                  .price
                                                                                  .toString()))}$currency",
                                                                      style: TextStyle(
                                                                          fontSize: 13,
                                                                          fontFamily: 'Poppins_bold',
                                                                          fontWeight: FontWeight.w600),
                                                                    ),
                                                                  ],
                                                              ],
                                                            ),

                                                          ),
                                                          SizedBox(
                                                            height: 0.7.h,
                                                          ),
                                                          if (itemdata!
                                                              .relateditems![index]
                                                              .hasVariation ==
                                                              "1") ...[
                                                            if (itemdata!
                                                                .relateditems![
                                                            index]
                                                                .availableQty ==
                                                                "" ||
                                                                int.parse(
                                                                    itemdata!
                                                                        .relateditems![
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
                                                                      border: Border
                                                                          .all(
                                                                          color: themenofier.isdark ? Colors.white : color.primarycolor)),
                                                                  height: 3.5.h,
                                                                  width: 32.w,
                                                                  child: Center(
                                                                    child: Text(
                                                                      LocaleKeys
                                                                          .ADD
                                                                          .tr(),
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                          'Poppins',
                                                                          fontSize: 9.5
                                                                              .sp,
                                                                          color: themenofier.isdark ? Colors.white : color.primarycolor),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ]
                                                          ] else
                                                            if (itemdata!
                                                                .relateditems![index]
                                                                .isCart ==
                                                                "0") ...[
                                                              InkWell(
                                                                onTap: () async {
                                                                  if (itemdata!
                                                                      .relateditems![
                                                                  index]
                                                                      .hasVariation ==
                                                                      "1" ||
                                                                      itemdata!
                                                                          .relateditems![
                                                                      index]
                                                                          .addons!
                                                                          .isNotEmpty) {
                                                                    cart =
                                                                    await Get
                                                                        .to(() =>
                                                                        showvariation(
                                                                            itemdata!
                                                                                .relateditems![
                                                                            index]));
                                                                    if (cart ==
                                                                        1) {
                                                                      setState(() {
                                                                        itemdata!
                                                                            .relateditems![
                                                                        index]
                                                                            .isCart =
                                                                        "1";
                                                                        itemdata!
                                                                            .relateditems![
                                                                        index]
                                                                            .itemQty =
                                                                            int
                                                                                .parse(
                                                                              itemdata!
                                                                                  .relateditems![
                                                                              index]
                                                                                  .itemQty!
                                                                                  .toString(),
                                                                            ) +
                                                                                1;
                                                                      });
                                                                    }
                                                                  } else {
                                                                    if (userid ==
                                                                        "") {
                                                                      Navigator
                                                                          .of(
                                                                          context)
                                                                          .pushAndRemoveUntil(
                                                                          MaterialPageRoute(
                                                                              builder: (
                                                                                  c) =>
                                                                                  Login()),
                                                                              (
                                                                              r) => false);
                                                                    } else {
                                                                      addtocart(
                                                                          itemdata!
                                                                              .relateditems![
                                                                          index]
                                                                              .id,
                                                                          itemdata!
                                                                              .relateditems![
                                                                          index]
                                                                              .itemName,
                                                                          itemdata!
                                                                              .relateditems![
                                                                          index]
                                                                              .imageName,
                                                                          itemdata!
                                                                              .relateditems![
                                                                          index]
                                                                              .itemType,
                                                                          itemdata!
                                                                              .relateditems![
                                                                          index]
                                                                              .tax,
                                                                          itemdata!
                                                                              .relateditems![
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
                                                                      border: Border
                                                                          .all(
                                                                          color: color.primarycolor)),
                                                                  height: 3.5.h,
                                                                  width: 32.w,
                                                                  child: Center(
                                                                    child: Text(
                                                                      LocaleKeys
                                                                          .ADD
                                                                          .tr(),
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                          'Poppins',
                                                                          fontSize: 9.5
                                                                              .sp,
                                                                          color: color
                                                                              .primarycolor),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ] else
                                                              if (itemdata!
                                                                  .relateditems![index]
                                                                  .isCart ==
                                                                  "1") ...[
                                                                Container(
                                                                  height: 3.6.h,
                                                                  width: 22.w,
                                                                  decoration: BoxDecoration(
                                                                    border: Border
                                                                        .all(
                                                                        color: Colors
                                                                            .grey),
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        5),
                                                                    // color: Theme.of(context).accentColor
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                    children: [
                                                                      InkWell(
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
                                                                            Icons
                                                                                .remove,
                                                                            color: color
                                                                                .primarycolor,
                                                                            size: 16,
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
                                                                          itemdata!
                                                                              .relateditems![
                                                                          index]
                                                                              .itemQty!
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 10.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                          onTap: () async {
                                                                            if (itemdata!
                                                                                .relateditems![
                                                                            index]
                                                                                .hasVariation ==
                                                                                "1" ||
                                                                                // ignore: prefer_is_empty
                                                                                itemdata!
                                                                                    .relateditems![
                                                                                index]
                                                                                    .addons!
                                                                                    .length >
                                                                                    0) {
                                                                              cart =
                                                                              await Get
                                                                                  .to(() =>
                                                                                  showvariation(
                                                                                      itemdata!
                                                                                          .relateditems![
                                                                                      index]));
                                                                              if (cart ==
                                                                                  1) {
                                                                                setState(() {
                                                                                  itemdata!
                                                                                      .relateditems![
                                                                                  index]
                                                                                      .itemQty =
                                                                                      int
                                                                                          .parse(
                                                                                        itemdata!
                                                                                            .relateditems![index]
                                                                                            .itemQty!
                                                                                            .toString(),
                                                                                      ) +
                                                                                          1;
                                                                                });
                                                                              }
                                                                            } else {
                                                                              addtocart(
                                                                                  itemdata!
                                                                                      .relateditems![
                                                                                  index]
                                                                                      .id,
                                                                                  itemdata!
                                                                                      .relateditems![
                                                                                  index]
                                                                                      .itemName,
                                                                                  itemdata!
                                                                                      .relateditems![
                                                                                  index]
                                                                                      .imageName,
                                                                                  itemdata!
                                                                                      .relateditems![
                                                                                  index]
                                                                                      .itemType,
                                                                                  itemdata!
                                                                                      .relateditems![
                                                                                  index]
                                                                                      .tax,
                                                                                  itemdata!
                                                                                      .relateditems![
                                                                                  index]
                                                                                      .price);

                                                                              // addtocart(
                                                                              //     index,
                                                                              //     "trending");
                                                                            }
                                                                          },
                                                                          child: Icon(
                                                                            Icons.add,
                                                                            color: color.primarycolor,
                                                                            size: 16,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                        ],
                                                      )
                                                    ]),
                                                  )),
                                            ),
                                      ),
                                    ),
                                  ],
                                  SizedBox(
                                    height: 9.h,
                                  ),
                                ],
                              ),
                            ),


                          ],
                        ),

                        bottomSheet: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Subscription_page(
                                    itemdata!.data!.id,
                                    itemdata!.data!.itemName,
                                    itemdata!.data!.itemImages![0].imageUrl
                                        .toString(),
                                    itemdata!.data!.categoryInfo!.categoryName!,
                                    itemdata!.data!.tax,
                                    select.price.value,
                                    itemdata!.data!.variation![select
                                        .variationselecationindex.value]
                                        .availableQty,
                                    itemdata!.data!.variation![select
                                        .variationselecationindex.value]
                                        .variation,
                                    widget.item
                                );
                              },));
                          },
                          child: Container(
                              color: themenofier.isdark
                                  ? Colors.white
                                  : color.primarycolor,
                              height: 7.h,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.ac_unit, color: themenofier.isdark
                                      ? Colors.black
                                      : color.white),
                                  Text("Subscribe Now", style: TextStyle(
                                      color: themenofier.isdark
                                          ? Colors.black
                                          : color.white, fontSize: 16),)
                                ],
                              )),
                        )
                    );
                  }
                },
              ));
        });
  }
}
/*
        bottomSheet: Container(
                  color: Colors.white,
                  height: 8.h,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          height: 6.5.h,
                          width: 47.w,
                          child: TextButton(
                            child: Obx(() => count.cartcountnumber == 0
                                ? Text(
                              LocaleKeys.Viewcart.tr(),
                              style: TextStyle(
                                fontFamily: 'Poppins_medium',
                                color: Colors.black,
                                fontSize: 13.sp,
                              ),
                            )
                                : Text(
                              "${LocaleKeys.Viewcart.tr()}(${count.cartcountnumber.value.toString()})",
                              style: TextStyle(
                                  fontFamily: 'Poppins_medium',
                                  color: Colors.black,
                                  fontSize: 13.sp),
                            )),
                            onPressed: () {
                              if (userid == "") {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (c) => Login()),
                                        (r) => false);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Homepage(2),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 6.5.h,
                          width: 47.w,
                          child: TextButton(
                            onPressed: () {
                              arr_addonsid.clear();
                              arr_addonsname.clear();
                              arr_addonsprice.clear();
                              for (int i = 0;
                              i < itemdata!.data!.addons!.length;
                              i++) {
                                if (itemdata!.data!.addons![i].isselected ==
                                    true) {
                                  arr_addonsid.add(
                                      itemdata!.data!.addons![i].id.toString());
                                  arr_addonsname.add(
                                      itemdata!.data!.addons![i].name.toString());
                                  arr_addonsprice.add(numberFormat.format(
                                      double.parse(itemdata!
                                          .data!.addons![i].price
                                          .toString())));
                                }
                              }

                              add_to_cartAPI();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: color.primarycolor,
                            ),
                            child: Text(
                              LocaleKeys.Add_to_cart.tr(),
                              style: TextStyle(
                                fontFamily: 'Poppins_medium',
                                color: Colors.white,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                      ]))
 */


