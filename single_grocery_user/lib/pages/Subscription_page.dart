import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/model/favorite/itemmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getmethod;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/pages/Home/product.dart';
import 'package:sizer/sizer.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import '../Model/favorite/itemmodel.dart';
import '../common class/allformater.dart';
import '../common class/prefs_name.dart';
import '../config/API/API.dart';
import '../model/cart/ordersummaryModel.dart';
import '../model/favorite/addtocartmodel.dart';
import '../theme/ThemeModel.dart';
import '../translation/locale_keys.g.dart';
import 'package:singlegrocery/widgets/loader.dart';
import '../../model/home/SubscriptionTypeModel.dart' as sub;
// import 'Cart/cartpage.dart';
import 'Favorite/showvariation.dart';
import 'Home/custom.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'Home/homepage.dart';
import 'authentication/Login.dart';
import 'package:singlegrocery/model/favorite/itemmodel.dart';

import 'cart/cartpage.dart';
class Subscription_page extends StatefulWidget {
  int? itemid;
  dynamic itemName,imgurl,itemType,tax,price,itemQty,variation;
  itemmodel? item;

  Subscription_page(this.itemid, this.itemName, this.imgurl, this.itemType, this.tax,
      this.price,this.itemQty,this.variation,this.item);

  @override
  State<Subscription_page> createState() => _Subscription_pageState();
}

class _Subscription_pageState extends State<Subscription_page> {


  buttoncontroller select = getmethod.Get.put(buttoncontroller());
  bool? issubscriptiondetail = true;
  sub.SubscriptionType? SubscriptionTypemodel;
  int t=0;
  int? cart;
  cartcount count = Get.put(cartcount());
  List<String> arr_addonsid = [];
  List<String> arr_addonsname = [];
  List<String> arr_addonsprice = [];

  List<int> selectedDays=[];
  DateTime? selectDate;
  DateTime? _selectedDate;
  DateTime? _selectedEndDate;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscriptionAPI();
    date();
    print("helloitem=${widget.item}");
    select.sub_str.value="One Time";
    select.sub_id.value=1;
    select.enddate.value="";
    select.customdaylist.value=[];
    select.temp_day.value=[];
    select.temp_qty.value=[];
    select.day_qty.value=[];
    select.total.value=0;
    select.counts = [1,1,1,1,1,1,1].obs;

  }
  Future subscriptionAPI() async {
    print("hello");
    try {
      var response = await Dio().get(DefaultApi.appUrl + PostAPI.subscriptionDetails);
      issubscriptiondetail = false;
      SubscriptionTypemodel = sub.SubscriptionType.fromJson(response.data);
      print("subscriptionAPI===${response.data}");
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

  addtocartmodel? addtocartdata;
  addtocart(itemid, itemname, itemimage, itemtype, itemtax, itemprice,) async {
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
        "subscription_id": select.sub_id.value,
        "start_date": select.date.value,
        "end_date": select.enddate.value,
        "custom_day":select.temp_day.value,
        "custom_qty":select.temp_qty.value,
        "addons_total_price": numberFormat.format(
          double.parse("0"),
        ),
      };

      var response = await Dio().post(DefaultApi.appUrl + PostAPI.Addtocart, data: map);
      print(response.data);
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


  add_to_cartAPI() async {


    print("quantity ${widget.item!.itemQty!}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double addonstotalprice = 0;
    for (int i = 0; i < arr_addonsprice.length; i++) {
      addonstotalprice = addonstotalprice + double.parse(arr_addonsprice[i]);
    }
    try {
      loader.showLoading();
      var map = {
        "user_id": userid,
        "item_id": widget.itemid,
        "item_name":widget.itemName,
        "item_image": widget.item!.imageName,
        "item_type": widget.item!
            .itemType,
        "tax": numberFormat.format(double.parse(
          widget.item!.tax!,
        )),
        "item_price": widget.item!.hasVariation == "1"
            ? numberFormat.format(double.parse(widget.item!.variation![
        int.parse(select.variationselecationindex.toString())]
            .productPrice!))
            : numberFormat.format(double.parse(widget.item!.price!)),
        "variation_id": widget.item!.hasVariation == "1"
            ? widget.item!
            .variation![
        int.parse(select.variationselecationindex.toString())]
            .id
            : "",
        "variation": widget.item!.hasVariation == "1"
            ? widget.item!
            .variation![
        int.parse(select.variationselecationindex.toString())]
            .variation
            : "",
        "addons_id": arr_addonsid.join(","),
        "subscription_id": select.sub_id.value,
        "start_date": select.date.value,
        "end_date": select.enddate.value,
        "custom_day":select.temp_day.value,
        "custom_qty":select.temp_qty.value,
        "order_type": "subscription",
        "addons_name": arr_addonsname.join(","),
        "addons_price": arr_addonsprice.join(","),
        "addons_total_price": numberFormat.format(addonstotalprice),
        "quantity":widget.item!.itemQty!
      };

       // print("map:::====>${map}");
      var response = await Dio().post(DefaultApi.appUrl + PostAPI.Addtocart, data: map);
      var finaldata = addtocartmodel.fromJson(response.data);
      print("sub====>${response.data}");
      loader.hideLoading();
      if (finaldata.status == 1) {
        prefs.setString(APPcart_count, finaldata.cartCount.toString());
        count.cartcountnumber.value = (int.parse(prefs.getString(APPcart_count)!));
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
        // print("cartcount   ${count.cartcountnumber.value}");
        setState(() {
          // isproductdetail = true;
          // select.variationselecationindex(2);
          // SharedPreferences prefs = await SharedPreferences.getInstance();
        });
        // Navigator.of(context).pop();
        // Navigator.pop(context, Favorite());

      } else {
        loader.showErroDialog(description: finaldata.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  List<String> days = ["SU","M","TU","W","T","F","S"];
  DateRangePickerController _datePickerController = DateRangePickerController();
  String firstD='';
  String lastD='';
  @override
  Widget build(BuildContext dialogContext) {
    return Consumer(
        builder: (context, ThemeModel themenofier, child) {
          return SafeArea(
            child: Scaffold(
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
                ),
                body: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20.h,
                          margin: EdgeInsets.only(
                              left: 4.w, top: 2.h, right: 4.w),
                          // color: color.primarycolor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                "${widget.imgurl}",
                                fit: BoxFit.contain,
                                height: 10.h,
                                width: 10.h,
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.itemName}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'Poppins_semibold',
                                      color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor,
                                    ),
                                  ),
                                  Text(
                                    "${widget.itemType}",
                                    // overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: color.grey,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  // if (widget.itemQty == "" ||
                                  //     double.parse(widget.itemQty
                                  //         .toString()) <=
                                  //         0) ...[
                                  //   Text(
                                  //     LocaleKeys.Out_of_Stock,
                                  //     style: TextStyle(
                                  //       fontFamily: 'Poppins',
                                  //       fontSize: 8.sp,
                                  //       color: color.grey,
                                  //     ),
                                  //   ),
                                  // ]
                                  // else if (widget.tax == "" ||
                                  //     widget.tax == "0")...[
                                  //   Text(
                                  //     LocaleKeys.Inclusive_of_all_taxes,
                                  //     style: TextStyle(
                                  //       fontFamily: 'Poppins',
                                  //       fontSize: 8.sp,
                                  //       color: color.primarycolor,
                                  //     ),
                                  //   ),
                                  // ]
                                  // else ...[
                                  //     Text(
                                  //       "${widget.tax}% ${LocaleKeys.additional_tax}",
                                  //       style: TextStyle(
                                  //         fontFamily: 'Poppins',
                                  //         fontSize: 8.sp,
                                  //         color: color.primarycolor,
                                  //       ),
                                  //     ),
                                  //
                                  //   ],
                                  Text(
                                    "Stock : ${widget.itemQty}",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'Poppins',color: themenofier.isdark
                                        ? Colors.white
                                        : color.primarycolor,

                                    ),
                                  ),
                                  Text(
                                    "${widget.variation}",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'Poppins',color: themenofier.isdark
                                        ? Colors.white
                                        : color.primarycolor,
                                    ),
                                  ),
                                  Text(
                                    "Rs.${widget.price}",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontFamily: 'Poppins_bold',color: themenofier.isdark
                                        ? Colors.white
                                        : color.primarycolor,
                                    ),
                                  ),
                                  Text(
                                    "(${LocaleKeys.Inclusive_of_all_taxes})",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 8.sp,
                                      color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor,
                                    ),
                                  ),
                                ],),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "*Price of products on subscription may chnage as per market charges",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 12.sp,
                              fontFamily: 'Poppins_semibold',
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 4.w, top: 4.h, bottom: 2.h),
                          child: Text(
                            "Select Your Plan",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                fontFamily: 'Poppins_semibold',
                              color: themenofier.isdark
                                  ? Colors.white
                                  : color.primarycolor,
                            ),
                          ),
                        ),

                        // row for onetime
                        Padding(
                          padding: EdgeInsets.only(left: 4.w, right: 4.w),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: select.listdata.value.map((e) {
                                print("subscription details ===${e.sId}==>${e
                                    .subsType}");
                                return e.isAvailable == 1 ?
                                Container(
                                  decoration: BoxDecoration(
                                    color: select.sub_str.value == e.subsType
                                        ? color.primarycolor
                                        : null,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor,
                                    ),
                                  ),
                                  height: 4.h,
                                  child: TextButton(
                                    child: Text(
                                      "${e.subsType}",
                                      style: TextStyle(
                                        fontFamily: 'Poppins_medium',
                                        color: select.sub_str.value ==
                                            e.subsType ? color.white : color
                                            .primarycolor,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    onPressed: () {
                                      select.sub_str.value = e.subsType!;
                                      select.sub_id.value = e.sId!;
                                      date();
                                      _datePickerController.selectedRanges = [];
                                      if (e.subsType == "Daily") {
                                        showDialog(context: context,
                                          builder: (context) =>
                                              Dialog(
                                                child: Container(
                                                    height: 50.h,
                                                    child: SfDateRangePicker(
                                                      confirmText: "Done",
                                                      onSubmit: (p0) {
                                                        print("ans=$p0");
                                                        List<
                                                            PickerDateRange> p = p0 as List<
                                                            PickerDateRange>;
                                                        if (p.length == 1) {
                                                          select.date.value =
                                                          "${p[0].startDate!
                                                              .day}-${p[0]
                                                              .startDate!
                                                              .month}-${p[0]
                                                              .startDate!
                                                              .year}";
                                                          select.enddate.value =
                                                          "${p[0].endDate!
                                                              .day}-${p[0]
                                                              .endDate!
                                                              .month}-${p[0]
                                                              .endDate!.year}";
                                                        }
                                                        else {
                                                          select.date.value =
                                                          "${p[0].startDate!
                                                              .day}-${p[0]
                                                              .startDate!
                                                              .month}-${p[0]
                                                              .startDate!
                                                              .year}";
                                                          select.enddate.value =
                                                          "${p[p.length - 1]
                                                              .endDate!
                                                              .day}-${p[p
                                                              .length - 1]
                                                              .endDate!
                                                              .month}-${p[p
                                                              .length - 1]
                                                              .endDate!.year}";
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      onCancel: () {
                                                        Navigator.pop(context);
                                                      },

                                                      showActionButtons: true,
                                                      initialSelectedDate: DateTime
                                                          .now().add(
                                                          Duration(days: 1)),
                                                      view: DateRangePickerView
                                                          .month,
                                                      selectionMode: DateRangePickerSelectionMode
                                                          .multiRange,
                                                      selectionTextStyle: TextStyle(
                                                          color: color
                                                              .primarycolor),
                                                      selectionColor: color
                                                          .primarycolor,
                                                      rangeSelectionColor: color
                                                          .primarycolor
                                                          .withOpacity(0.5),
                                                      startRangeSelectionColor: color
                                                          .primarycolor
                                                          .withOpacity(0.5),
                                                      endRangeSelectionColor: color
                                                          .primarycolor
                                                          .withOpacity(0.5),
                                                      todayHighlightColor: color
                                                          .primarycolor,
                                                      controller: _datePickerController,
                                                      enablePastDates: false,
                                                      minDate: select.tom_date
                                                          .value,
                                                      maxDate: select.tom_date
                                                          .value.add(Duration(
                                                          days: select
                                                              .remaindaysinmonth
                                                              .value + select
                                                              .nextdaysinmonth
                                                              .value)),
                                                      onSelectionChanged: (
                                                          dateRangePickerSelectionChangedArgs) {
                                                        List<
                                                            PickerDateRange> list = dateRangePickerSelectionChangedArgs
                                                            .value;
                                                        list.forEach((element) {
                                                          print("month=${element
                                                              .startDate!
                                                              .month}");
                                                          if (!select.monthlist
                                                              .value.contains(
                                                              element.startDate!
                                                                  .month)) {
                                                            select.monthlist
                                                                .value.add(
                                                                element
                                                                    .startDate!
                                                                    .month);
                                                            if (element
                                                                .startDate!
                                                                .month ==
                                                                select.tom_date
                                                                    .value
                                                                    .month) {
                                                              int days = DateUtils
                                                                  .getDaysInMonth(
                                                                  element
                                                                      .startDate!
                                                                      .year,
                                                                  element
                                                                      .startDate!
                                                                      .month);
                                                              PickerDateRange pick = PickerDateRange(
                                                                  DateTime(
                                                                      element
                                                                          .startDate!
                                                                          .year,
                                                                      element
                                                                          .startDate!
                                                                          .month,
                                                                      select
                                                                          .tom_date
                                                                          .value
                                                                          .day),
                                                                  DateTime(
                                                                      element
                                                                          .startDate!
                                                                          .year,
                                                                      element
                                                                          .startDate!
                                                                          .month,
                                                                      1).add(
                                                                      Duration(
                                                                          days: days -
                                                                              1)));
                                                              select.daterange
                                                                  .value.add(
                                                                  pick);
                                                            }
                                                            else {
                                                              int days = DateUtils
                                                                  .getDaysInMonth(
                                                                  element
                                                                      .startDate!
                                                                      .year,
                                                                  element
                                                                      .startDate!
                                                                      .month);
                                                              PickerDateRange pick = PickerDateRange(
                                                                  DateTime(
                                                                      element
                                                                          .startDate!
                                                                          .year,
                                                                      element
                                                                          .startDate!
                                                                          .month,
                                                                      1),
                                                                  DateTime(
                                                                      element
                                                                          .startDate!
                                                                          .year,
                                                                      element
                                                                          .startDate!
                                                                          .month,
                                                                      1).add(
                                                                      Duration(
                                                                          days: days -
                                                                              1)));
                                                              select.daterange
                                                                  .value.add(
                                                                  pick);
                                                            }
                                                            print(
                                                                "month=${select
                                                                    .daterange
                                                                    .value}");
                                                          }
                                                        });
                                                        _datePickerController
                                                            .selectedRanges =
                                                            select.daterange
                                                                .value;
                                                      },
                                                    )),
                                              ),);
                                      }
                                      if (e.subsType == "One Time") {

                                        _datePickerController =
                                            DateRangePickerController();
                                        showDialog(context: context,
                                          builder: (context) =>
                                              Dialog(
                                                child: Container(color: Colors.white,
                                                    height: 50.h,
                                                    child: SfDateRangePicker(
                                                      initialSelectedDate: DateTime
                                                          .now().add(
                                                          Duration(days: 1)),
                                                      view: DateRangePickerView
                                                          .month,
                                                      selectionMode: DateRangePickerSelectionMode
                                                          .single,
                                                      controller: _datePickerController,
                                                      enablePastDates: false,
                                                      selectionColor: color
                                                          .primarycolor,
                                                      todayHighlightColor: color
                                                          .primarycolor,
                                                      minDate: select.tom_date
                                                          .value,
                                                      maxDate: select.tom_date
                                                          .value.add(Duration(
                                                          days: select
                                                              .remaindaysinmonth
                                                              .value + select
                                                              .nextdaysinmonth
                                                              .value)),
                                                      onSelectionChanged: (
                                                          dateRangePickerSelectionChangedArgs) {
                                                        print(
                                                            "${dateRangePickerSelectionChangedArgs
                                                                .value}");
                                                        DateTime selectdate = dateRangePickerSelectionChangedArgs
                                                            .value;
                                                        select.date.value =
                                                        "${selectdate
                                                            .day}-${selectdate
                                                            .month}-${selectdate
                                                            .year}";
                                                        Navigator.pop(context);
                                                      },
                                                      showActionButtons: true,
                                                      onSubmit: (p0) {
                                                        print(p0);
                                                        DateTime selectdate = p0 as DateTime;
                                                        select.date.value =
                                                        "${selectdate
                                                            .day}-${selectdate
                                                            .month}-${selectdate
                                                            .year}";
                                                        Navigator.pop(context);
                                                      },
                                                      onCancel: () {
                                                        Navigator.pop(context);
                                                      },

                                                    )),
                                              ),);
                                      }
                                      if (e.subsType == "Weekly") {
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => custompage(
                                        //     widget.itemid,
                                        //     widget.itemName,
                                        //     widget.imgurl,
                                        //      widget.itemType,
                                        //     widget.tax,
                                        //     select.price.value,widget.itemQty),));

                                      }
                                      if (e.subsType == "Alternate") {
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 4.w, top: 4.h, bottom: 2.h),
                                          height: 3.6.h,
                                          width: 32.w,
                                          decoration:
                                          BoxDecoration(
                                            border: Border.all(
                                                color:
                                                color.primarycolor),
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
                                                    if (widget.item!.itemQty <= int.parse(
                                                        widget.item!.itemQty.toString())-1) {
                                                      loader
                                                          .showErroDialog(
                                                        description:
                                                        LocaleKeys
                                                            .The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item
                                                        ,
                                                      );
                                                    }
                                                    else {
                                                      setState(
                                                              () {
                                                            widget.item!
                                                                .itemQty = int.parse(
                                                                widget.item!.itemQty
                                                                    .toString()) -
                                                                1;
                                                          });
                                                    }
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
                                                  widget.item!
                                                      .itemQty!
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize:
                                                    10.sp, color: themenofier.isdark
                                                      ? Colors.white
                                                      : color.primarycolor,),
                                                ),
                                              ),
                                              InkWell(
                                                  onTap:
                                                      () async {
                                                    setState(
                                                            () {
                                                          widget.item!.itemQty = int.parse(
                                                              widget.item!.itemQty.toString()) +
                                                              1;
                                                        });
                                                  },
                                                  child: Icon(
                                                    Icons.add,
                                                    color: color
                                                        .primarycolor,
                                                    size: 18,
                                                  )),
                                            ],
                                          ),
                                        );
                                        _datePickerController = DateRangePickerController();
                                        t = 0;
                                        showDialog(context: context,
                                          builder: (context) =>
                                              Dialog(
                                                child: Container(color: Colors.white,
                                                    height: 50.h,
                                                    child: SfDateRangePicker(
                                                      confirmText: "Done",
                                                      // onSubmit: (p0) {
                                                      //   print("ans=$p0");
                                                      //   Navigator.pop(context);
                                                      // },
                                                      // onCancel: () {
                                                      //   Navigator.pop(context);
                                                      // },
                                                      // showActionButtons: true,
                                                      initialSelectedDate: DateTime
                                                          .now().add(
                                                          Duration(days: 1)),
                                                      view: DateRangePickerView
                                                          .month,
                                                      selectionMode: DateRangePickerSelectionMode
                                                          .multiple,
                                                      controller: _datePickerController,
                                                      enablePastDates: false,
                                                      todayHighlightColor: color
                                                          .primarycolor,
                                                      selectionColor: color
                                                          .primarycolor,
                                                      minDate: select.tom_date
                                                          .value,
                                                      maxDate: select.tom_date
                                                          .value.add(Duration(
                                                          days: select
                                                              .remaindaysinmonth
                                                              .value + select
                                                              .nextdaysinmonth
                                                              .value)),
                                                      // selectableDayPredicate: (date) {
                                                      //   print("predict ${t}");
                                                      //   print("predict= ${_datePickerController.selectedDates!.length}");
                                                      //   return true;
                                                      //x`
                                                      //   // return _datePickerController.selectedDates!.length != select.alter_dateTime.value.length;
                                                      // },
                                                      onSelectionChanged: (
                                                          dateRangePickerSelectionChangedArgs) {
                                                        print(
                                                            "month====${dateRangePickerSelectionChangedArgs
                                                                .value}");
                                                        List<
                                                            DateTime> list = dateRangePickerSelectionChangedArgs
                                                            .value;
                                                        print("month====${list
                                                            .length}");
                                                        list.forEach((element) {
                                                          DateTime d = element;
                                                          // DateTime d=list.last;
                                                          int days = DateUtils
                                                              .getDaysInMonth(
                                                              d.year, d.month);
                                                          print(
                                                              "totaldays=$days");
                                                          DateTime lastdate = DateTime
                                                              .utc(d.year,
                                                              d.month + 1)
                                                              .subtract(
                                                              Duration(
                                                                  days: 1));
                                                          print(lastdate);
                                                          int t = d.day;
                                                          print(
                                                              "current date=${d
                                                                  .day}");
                                                          print("odd=${t % 2 ==
                                                              0}");
                                                          for (int i = t; i <=
                                                              days; i = i + 2) {
                                                            if (!select
                                                                .alter_dateTime
                                                                .contains(
                                                                DateTime(d.year,
                                                                    d.month,
                                                                    i))) {
                                                              select
                                                                  .alter_dateTime
                                                                  .value.add(
                                                                  DateTime(
                                                                      d.year,
                                                                      d.month,
                                                                      i));
                                                              print(
                                                                  "i===${DateTime(
                                                                      d.year,
                                                                      d.month,
                                                                      i)}");
                                                            }
                                                            else {
                                                              break;
                                                            }
                                                          }
                                                        });
                                                        _datePickerController.selectedDates = select.alter_dateTime.value;
                                                        if (select.alter_dateTime.value.length != 0) {
                                                          select.alter_dateTime.value.forEach((element) {
                                                            if (!select.temp_dateTime.contains(
                                                                "${element.day}-${element.month}-${element.year}")) {
                                                              select.temp_dateTime.add(
                                                                  "${element.day}-${element.month}-${element.year}");
                                                            }
                                                          });
                                                          select.temp_dateTime.refresh();
                                                        }

                                                        print("temp=${select.temp_dateTime.value}");
                                                        select.alter_dateTime.refresh();
                                                        // select.date.value = select.temp_dateTime.value.first;
                                                        select.date.value = _datePickerController.selectedDates!.first.toString().substring(0,10);
                                                        print("frist : ${select.date.value}");
                                                        firstD = select.date.value;
                                                        // select.enddate.value = select.temp_dateTime.value.last;
                                                        select.enddate.value =  _datePickerController.selectedDates!.last.toString().substring(0,10);
                                                        print("last : ${select.enddate.value}");
                                                        lastD = select.enddate.value;
                                                        setState(() {});
                                                        // t=select.alter_dateTime.value.length;
                                                        print("t===${_datePickerController.selectedDates}");
                                                        Future.delayed(Duration(seconds: 1)).then((value) {
                                                          if (t == 0) {
                                                            t = 1;
                                                            Navigator.of(context).pop();
                                                          }
                                                        });
                                                      },
                                                    )),
                                              ),);
                                      }
                                      select.sub_str.value = e.subsType!;
                                      select.status.value = 0;
                                      select.sub_status.value = false;
                                    },
                                  ),
                                ) : SizedBox();
                              }).toList()
                          ),
                        ),
                        // if (widget.item!
                        //     .hasVariation ==
                        //     "0") ...[
                        //   if (widget.item!
                        //       .availableQty ==
                        //       "" ||
                        //       int.parse(widget.item!
                        //           .availableQty
                        //           .toString()) <=
                        //           0) ...[
                        //     InkWell(
                        //       onTap: () {},
                        //       child: Container(
                        //         margin: EdgeInsets.only(left: 4.w,top: 4.h,bottom: 2.h),
                        //         decoration: BoxDecoration(
                        //             borderRadius:
                        //             BorderRadius
                        //                 .circular(
                        //                 4),
                        //             border: Border.all(
                        //                 color: color.primarycolor)),
                        //         height: 3.5.h,
                        //         width: 32.w,
                        //         child: Center(
                        //           child: Text(
                        //             LocaleKeys.ADD,
                        //             style: TextStyle(
                        //                 fontFamily:
                        //                 'Poppins',
                        //                 fontSize:
                        //                 9.5.sp,
                        //                 color: color
                        //                     .primarycolor),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ]
                        // ]
                        // else if (widget.item!
                        //     .isCart ==
                        //     "0") ...[
                        //   GestureDetector(
                        //     onTap: () async {
                        //       if (widget.item!
                        //           .hasVariation ==
                        //           "1" ||
                        //           widget.item!
                        //               .addons!
                        //               .isNotEmpty) {
                        //         cart = await Get.to(
                        //                 () => showvariation(
                        //                 widget.item!));
                        //         if (cart == 1) {
                        //           setState(() {
                        //             widget.item!
                        //                 .isCart = "1";
                        //             widget.item!
                        //                 .itemQty = int.parse(widget.item!
                        //                 .itemQty!
                        //                 .toString()) +
                        //                 1;
                        //           });
                        //         }
                        //       } else {
                        //         if (userid == "") {
                        //           Navigator.of(
                        //               context)
                        //               .pushAndRemoveUntil(
                        //               MaterialPageRoute(
                        //                   builder: (c) =>
                        //                       Login()),
                        //                   (r) =>
                        //               false);
                        //         } else {
                        //           addtocart(
                        //               widget.item!
                        //                   .id,
                        //               widget.item!
                        //                   .itemName,
                        //               widget.item!
                        //                   .imageName,
                        //               widget.item!
                        //                   .itemType,
                        //               widget.item!
                        //                   .tax,
                        //               widget.item!
                        //                   .price);
                        //         }
                        //       }
                        //     },
                        //     child: Container(
                        //         margin: EdgeInsets.only(left: 4.w,top: 4.h,bottom: 2.h),
                        //         decoration: BoxDecoration(
                        //             borderRadius:
                        //             BorderRadius
                        //                 .circular(
                        //                 4),
                        //             border: Border.all(
                        //                 color: color.primarycolor)),
                        //         height: 3.5.h,
                        //         width: 32.w,
                        //         child: Center(
                        //           child: Text(
                        //             LocaleKeys.ADD
                        //             ,
                        //             style: TextStyle(
                        //                 fontFamily:
                        //                 'Poppins',
                        //                 fontSize:
                        //                 9.5.sp,
                        //                 color: color.primarycolor),
                        //           ),
                        //         )),
                        //   ),
                        // ]
                        // else if (widget.item!
                        //       .isCart ==
                        //       "1") ...[
                        //     Container(
                        //       margin: EdgeInsets.only(left: 4.w,top: 4.h,bottom: 2.h),
                        //       height: 3.6.h,
                        //       width: 32.w,
                        //       decoration:
                        //       BoxDecoration(
                        //         border: Border.all(
                        //             color:
                        //             color.primarycolor),
                        //         borderRadius:
                        //         BorderRadius
                        //             .circular(5),
                        //         // color: Theme.of(context).accentColor
                        //       ),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //         MainAxisAlignment
                        //             .spaceAround,
                        //         children: [
                        //           GestureDetector(
                        //               onTap: () {
                        //                 loader
                        //                     .showErroDialog(
                        //                   description:
                        //                   LocaleKeys.The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item
                        //                   ,
                        //                 );
                        //               },
                        //               child: Icon(
                        //                 Icons.remove,
                        //                 color: color
                        //                     .primarycolor,
                        //                 size: 18,
                        //               )),
                        //           Container(
                        //             decoration:
                        //             BoxDecoration(
                        //               borderRadius:
                        //               BorderRadius
                        //                   .circular(
                        //                   3),
                        //             ),
                        //             child: Text(
                        //               widget.item!
                        //                   .itemQty!
                        //                   .toString(),
                        //               style: TextStyle(
                        //                   fontSize:
                        //                   10.sp,color: color.primarycolor),
                        //             ),
                        //           ),
                        //           InkWell(
                        //               onTap:
                        //                   () async {
                        //                 if (widget.item!
                        //                     .hasVariation ==
                        //                     "1" ||
                        //                     // ignore: prefer_is_empty
                        //                     widget.item!
                        //                         .addons!
                        //                         .length >
                        //                         0) {
                        //                   cart = await Navigator.of(
                        //                       context)
                        //                       .push(
                        //                       MaterialPageRoute(
                        //                         builder: (context) =>
                        //                             showvariation(
                        //                                 widget.item!),
                        //                       ));
                        //
                        //                   if (cart ==
                        //                       1) {
                        //                     setState(
                        //                             () {
                        //                           widget.item!
                        //                               .itemQty = int.parse(
                        //                               widget.item!.itemQty.toString()) +
                        //                               1;
                        //                         });
                        //                   }
                        //                 } else {
                        //                   addtocart(
                        //                       widget.item!
                        //                           .id,
                        //                       widget.item!
                        //                           .itemName,
                        //                       widget.item!
                        //                           .imageName,
                        //                       widget.item!
                        //                           .itemType,
                        //                       widget.item!
                        //                           .tax,
                        //                       widget.item!
                        //                           .price);
                        //                 }
                        //               },
                        //               child: Icon(
                        //                 Icons.add,
                        //                 color: color
                        //                     .primarycolor,
                        //                 size: 18,
                        //               )),
                        //         ],
                        //       ),
                        //     ),
                        //   ],

                        // Padding(
                        //   padding: EdgeInsets.only(left: 4.w, right: 4.w),
                        //
                        //     child:Row(
                        //       children: select.listdata.value.map((e) {}).toList()
                        //     ),
                        // ),


                        // Add qun
                        if(select.sub_str.value == "One Time")...[
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h,),
                              Padding(
                                padding:  EdgeInsets.only(left: 4.w),
                                child: Text("Item Qty :"),
                              ),
                              Container(
                              margin: EdgeInsets.only(left: 4.w, top: 1.h, bottom: 2.h),
                              height: 3.6.h,
                              width: 32.w,
                              decoration:
                              BoxDecoration(
                                border: Border.all(
                                  color: themenofier.isdark
                                      ? Colors.white
                                      : color.primarycolor,),
                                borderRadius: BorderRadius.circular(5),
                                // color: Theme.of(context).accentColor
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        if (widget.item!.itemQty <= int.parse(widget.item!.itemQty.toString())-1) {
                                          loader.showErroDialog(description: LocaleKeys.The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item,
                                          );
                                        }
                                        else {
                                          setState(() {
                                                widget.item!.itemQty = int.parse(widget.item!.itemQty.toString()) - 1;
                                              });
                                        }
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
                                      "${int.parse(widget.item!.itemQty.toString()) + 1}",
                                      style: TextStyle(
                                        fontSize:
                                        12.sp, color: themenofier.isdark
                                          ? Colors.white
                                          : color.primarycolor,),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        setState(() {
                                              widget.item!.itemQty = int.parse(widget.item!.itemQty.toString()) + 1;
                                            });
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
                          ),
                        ],
                        if(select.sub_str.value == "Daily")...[
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h,),
                              Padding(
                                padding:  EdgeInsets.only(left: 4.w),
                                child: Text("Item Qty :"),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 4.w, top: 1.h, bottom: 2.h),
                                height: 3.6.h,
                                width: 32.w,
                                decoration:
                                BoxDecoration(
                                  border: Border.all(
                                    color: themenofier.isdark
                                        ? Colors.white
                                        : color.primarycolor,),
                                  borderRadius: BorderRadius.circular(5),
                                  // color: Theme.of(context).accentColor
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          if (widget.item!.itemQty <= int.parse(widget.item!.itemQty.toString())-1) {
                                            loader.showErroDialog(description: LocaleKeys.The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item,
                                            );
                                          }
                                          else {
                                            setState(() {
                                              widget.item!.itemQty = int.parse(widget.item!.itemQty.toString()) - 1;
                                            });
                                          }
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
                                        "${int.parse(widget.item!.itemQty.toString()) + 1}",
                                        style: TextStyle(
                                          fontSize:
                                          12.sp, color: themenofier.isdark
                                            ? Colors.white
                                            : color.primarycolor,),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          setState(() {
                                            widget.item!.itemQty = int.parse(widget.item!.itemQty.toString()) + 1;
                                          });
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
                          ),
                        ],
                        if(select.sub_str.value == "Alternate")...[
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h,),
                              Padding(
                                padding:  EdgeInsets.only(left: 4.w),
                                child: Text("Item Qty :"),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 4.w, top: 1.h, bottom: 2.h),
                                height: 3.6.h,
                                width: 32.w,
                                decoration:
                                BoxDecoration(
                                  border: Border.all(
                                    color: themenofier.isdark
                                        ? Colors.white
                                        : color.primarycolor,),
                                  borderRadius: BorderRadius.circular(5),
                                  // color: Theme.of(context).accentColor
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          if (widget.item!.itemQty <= int.parse(widget.item!.itemQty.toString())-1) {
                                            loader.showErroDialog(description: LocaleKeys.The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item,
                                            );
                                          }
                                          else {
                                            setState(() {
                                              widget.item!.itemQty = int.parse(widget.item!.itemQty.toString()) - 1;
                                            });
                                          }
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
                                        "${int.parse(widget.item!.itemQty.toString()) + 1}",
                                        style: TextStyle(
                                          fontSize:
                                          12.sp, color: themenofier.isdark
                                            ? Colors.white
                                            : color.primarycolor,),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          setState(() {
                                            widget.item!.itemQty = int.parse(widget.item!.itemQty.toString()) + 1;
                                          });
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
                          ),
                        ],


                        // Start Date
                        if(select.sub_str.value == "One Time")...[
                          Container(
                            margin: EdgeInsets.only(left: 4.w, top: 2.h, bottom: 2.h),
                            child: Obx(() =>
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text("Start Date : "),
                                    Container(
                                        height: 4.h,
                                        width: 32.w,alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(vertical: 3,),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: color.primarycolor)
                                        ),
                                        child:   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(" ${select.date.value}",style: TextStyle(fontWeight: FontWeight.w400),),
                                            Icon(Icons.calendar_month,color: color.primarycolor,size: 22,)
                                          ],
                                        )),
                                  ],
                                )),
                          ),
                        ],
                        if(select.sub_str.value == "Daily")...[
                          /*Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 50,
                                      width: double.infinity,alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text("Start Date: ${select.date.value}",style: TextStyle(fontWeight: FontWeight.w400),)
                                  ),
                                ),
                              ),
                              Text("To"),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 50,alignment: Alignment.center,
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(vertical: 5),padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text("End Date:  ${select.enddate.value}",style: TextStyle(fontWeight: FontWeight.w400),)

                                  ),
                                ),
                              ),
                            ],
                          ),*/
                          Container(
                            margin: EdgeInsets.only(left: 4.w, top: 3.h, bottom: 2.h,right: 4.w),
                            child: Obx(() =>
                              Padding(
                                padding:  EdgeInsets.only(),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Start Date:",),
                                        Container(
                                            height: 4.h,
                                            width: 32.w,alignment: Alignment.center,
                                            margin: EdgeInsets.symmetric(vertical: 3,),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(color: color.primarycolor)
                                            ),
                                            child:   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(" ${select.date.value}",style: TextStyle(fontWeight: FontWeight.w400),),
                                                Icon(Icons.calendar_month,color: color.primarycolor,size: 22,)
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal : 5.w,vertical: 1.h),
                                      child: Text("To"),
                                    ),
                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("End Date",),
                                        Container(
                                            height: 4.h,
                                            width: 32.w,alignment: Alignment.center,
                                            margin: EdgeInsets.symmetric(vertical: 3,),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(color: color.primarycolor)
                                            ),
                                            child:   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(" ${select.enddate.value}",style: TextStyle(fontWeight: FontWeight.w400),),
                                                Icon(Icons.calendar_month,color: color.primarycolor,size: 22,)
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                             ),
                          ),
                        ],
                        if(select.sub_str.value == "Alternate") ...[
                         /* Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 50,
                                      width: double.infinity,alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text("Start Date: ${select.date.value}",style: TextStyle(fontWeight: FontWeight.w400),)
                                  ),
                                ),
                              ),
                              Text("To"),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 50,alignment: Alignment.center,
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(vertical: 5),padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text("End Date:  ${select.enddate.value}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),)

                                  ),
                                ),
                              ),
                            ],
                          ),*/
                          Padding(
                            padding:  EdgeInsets.only(left: 4.w, top: 2.h, bottom: 2.h,right: 4.w),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Start Date:",),
                                    Container(
                                        height: 4.h,
                                        width: 34.w,alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(vertical: 3,),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: color.primarycolor)
                                        ),
                                      child:   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(" ${firstD}",style: TextStyle(fontWeight: FontWeight.w400),),
                                          // Text(" ${select.date.value}",style: TextStyle(fontWeight: FontWeight.w400),),
                                          Icon(Icons.calendar_month,color: color.primarycolor,size: 22,)
                                        ],
                                      )
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal : 5.w,vertical: 1.h),
                                  child: Text("To"),
                                ),
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("End Date:",),
                                    Container(
                                        height: 4.h,
                                        width: 34.w,alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(vertical: 3,),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: color.primarycolor)
                                        ),
                                        child:   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(" ${lastD}",style: TextStyle(fontWeight: FontWeight.w400),),
                                            // Text(" ${select.enddate.value}",style: TextStyle(fontWeight: FontWeight.w400),),
                                            Icon(Icons.calendar_month,color: color.primarycolor,size: 22,)
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ],
                        SizedBox(height: 2.h,),
                        getmethod.Obx(() =>
                            Visibility(
                              visible: select.sub_str.value == "Weekly" ? true : false,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: 4.w, top: 2.h, bottom: 2.h,right: 4.w),
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Start From:"),
                                            Container(
                                              height: 4.2.h,
                                              width: 34.w,alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(vertical: 3,),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(color: color.primarycolor)
                                              ),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Obx(() =>
                                                      Text(" ${select.startDate.value}",style: TextStyle(fontWeight: FontWeight.w400),)),
                                                  // IconButton(onPressed: () {
                                                  //   _selectDate(context);
                                                  // }, icon: Icon(Icons.calendar_month,color: color.primarycolor,))
                                                  InkWell(onTap: () {
                                                    _selectDate(context);
                                                  },child: Icon(Icons.calendar_month,color: color.primarycolor,))
                                                ],
                                              )
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.symmetric(horizontal : 5.w,vertical: 1.h),
                                          child: Text("To"),
                                        ),
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("End Date:"),
                                            Container(
                                                height: 4.2.h,
                                                width: 34.w,alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(vertical: 3,),
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(color: color.primarycolor)
                                                ),
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Obx(() =>
                                                        Text(" ${select.endDate.value}",style: TextStyle(fontWeight: FontWeight.w400),)),
                                                    // IconButton(onPressed: () {
                                                    //   _selectDate1(context);
                                                    // }, icon: Icon(Icons.calendar_month,color: color.primarycolor,))
                                                    InkWell(onTap: () {
                                                      _selectDate1(context);
                                                    },child: Icon(Icons.calendar_month,color: color.primarycolor,))
                                                  ],
                                                )
                                              /*TextField(
                                          controller: _endDateController,
                                          readOnly: true,
                                          onTap: () {
                                            _selectDate(context,1);
                                          },
                                          decoration: InputDecoration(
                                            // labelText: 'End To',
                                            border: InputBorder.none,
                                            hintText: 'End To',
                                            suffixIcon: Icon(Icons.calendar_today,color: color.primarycolor,),
                                          ),
                                        ),*/
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 4.w,
                                      right: 4.w,
                                      top: 1.h,
                                      bottom: 2.h,
                                    ),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      LocaleKeys.select_days,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Poppins_semibold',),
                                    ),
                                  ),

                                  GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: days.length
                                    ),
                                    itemCount: days.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {

                                          if(days[index]=="SU")
                                          {
                                            _toggleSelectedDay(7);
                                          }
                                          else
                                          {
                                            _toggleSelectedDay(index);
                                          }

                                          select.selectday.value = days[index];
                                          select.selectdayvisible.value[index] = !select.selectdayvisible.value[index];
                                          Map m = {select.daylist.value[index]: 1};
                                          print("mm: ${m}");
                                          if (select.selectdayvisible.value[index]) {
                                            select.total.value = select.total.value + double.parse(widget.price.toString());
                                            select.day_qty.value.add(m);
                                          }
                                          else {
                                            select.total.value = select.total.value -
                                                    (select.counts[index] * double.parse(widget.price.toString()));
                                            select.counts[index] = 1;
                                            print(select.daylist.value[index]);
                                            select.day_qty.value.removeWhere((element) => element.containsKey(select.daylist.value[index]));
                                            select.day_qty.refresh();
                                          }
                                          select.temp_qty.value = [];
                                          select.temp_day.value = [];
                                          select.day_qty.forEach((element) {
                                            element.forEach((key, value) {
                                              select.temp_day.value.add(key);
                                              select.temp_qty.value.add(value);
                                            });
                                          });
                                          select.temp_day.refresh();
                                          select.temp_qty.refresh();
                                          select.day_qty.refresh();
                                          print("daylist===>${select.day_qty.value}");
                                          print("daylist===>${select.temp_day.value}");
                                          print("daylist===>${select.temp_qty.value}");
                                          select.selectdayvisible.refresh();

                                       /*   _toggleSelectedDay(select.temp_day.value[index]);
                                          String ddd = select.temp_day.value.join(",");
                                          print(ddd);
                                          if(select.temp_day.value.contains("Sunday"))
                                            {
                                              print("Sunday.. ${DateTime.sunday}");
                                            }
                                           if(select.temp_day.value.contains("Monday"))
                                          {
                                            print("Monday.. ${DateTime.monday}");
                                          }*/
                                        },
                                        child: Obx(() =>
                                            Container(
                                              margin: EdgeInsets.all(2.w),
                                              decoration: BoxDecoration(
                                                color: select.selectdayvisible.value[index] ? color.primarycolor.withOpacity(0.5) : Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                  // color: select.selectdayvisible.value[index]?color.primarycolor:Colors.black,
                                                  color: color.primarycolor,
                                                  // color: Colors.black,
                                                ),
                                              ),
                                              // height: 4.h,
                                              child: TextButton(
                                                child: Text(
                                                  "${days[index]}",
                                                  // "${select.selectdayvisible.value[index]}",
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins_medium',
                                                    color: Colors.black,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                                onPressed: null,
                                              ),
                                            )),
                                      );
                                    },)
                                ],
                              ),
                            )),
                        getmethod.Obx(() =>
                            Visibility(visible: select.sub_str.value == "Weekly"
                                ? true
                                : false, child: Column(
                              children: [
                                Obx(() =>
                                    Column(
                                        children: List.generate(7, (index) =>
                                            Visibility(
                                              child: ListTile(
                                                contentPadding: EdgeInsets.only(
                                                    left: 3.w, right: 3.w),
                                                title: Text(
                                                  "${select.daylist[index]}",
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Poppins_semibold'),
                                                ),
                                                trailing: Container(
                                                  // margin: EdgeInsets.all(3.w),
                                                  decoration: BoxDecoration(
                                                    color: color.primarycolor
                                                        .withOpacity(0.5),
                                                    borderRadius: BorderRadius
                                                        .circular(8),
                                                    border: Border.all(
                                                      color: color.primarycolor,
                                                    ),
                                                  ),
                                                  height: 4.h,
                                                  width: 30.w,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [

                                                      TextButton(
                                                        onPressed: () {
                                                          if (select.counts[index] >0) {
                                                            select.total.value =
                                                                select.total.value -
                                                                    double.parse(widget.price.toString());
                                                            select.counts[index] = select.counts[index]-1;
                                                          }
                                                          print("day=${select
                                                              .daylist
                                                              .value[index]}");
                                                          select.day_qty.value
                                                              .forEach((
                                                              element) {
                                                            element.forEach((
                                                                key, value) {
                                                              if (key ==
                                                                  select.daylist
                                                                      .value[index]) {
                                                                element[key] =
                                                                select
                                                                    .counts[index];
                                                              }
                                                            });
                                                          });
                                                          select.temp_qty
                                                              .value = [];
                                                          select.temp_day
                                                              .value = [];
                                                          select.day_qty
                                                              .forEach((
                                                              element) {
                                                            element.forEach((
                                                                key, value) {
                                                              select.temp_day
                                                                  .value.add(
                                                                  key);
                                                              select.temp_qty
                                                                  .value.add(
                                                                  value);
                                                            });
                                                          });
                                                          select.temp_day
                                                              .refresh();
                                                          select.temp_qty
                                                              .refresh();
                                                          select.day_qty
                                                              .refresh();
                                                          print(select.day_qty
                                                              .value);
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          minimumSize: Size
                                                              .zero,
                                                          padding: EdgeInsets
                                                              .zero,
                                                          tapTargetSize: MaterialTapTargetSize
                                                              .shrinkWrap,
                                                        ),
                                                        child: Text(
                                                          "-",
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins_medium',
                                                            color: Colors.black,
                                                            fontSize: 25.sp,

                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${select
                                                            .counts[index]}",
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins_medium',
                                                          color: Colors.black,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          print("hello");
                                                          select.counts[index] =
                                                              select
                                                                  .counts[index] +
                                                                  1;
                                                          select.total.value =
                                                              select.total
                                                                  .value +
                                                                  double.parse(
                                                                      widget
                                                                          .price
                                                                          .toString());
                                                          select.day_qty.value
                                                              .forEach((
                                                              element) {
                                                            element.forEach((
                                                                key, value) {
                                                              if (key ==
                                                                  select.daylist
                                                                      .value[index]) {
                                                                element[key] =
                                                                select
                                                                    .counts[index];
                                                              }
                                                            });
                                                          });
                                                          select.temp_qty
                                                              .value = [];
                                                          select.temp_day
                                                              .value = [];
                                                          select.day_qty
                                                              .forEach((
                                                              element) {
                                                            element.forEach((
                                                                key, value) {
                                                              select.temp_day
                                                                  .value.add(
                                                                  key);
                                                              select.temp_qty
                                                                  .value.add(
                                                                  value);
                                                            });
                                                          });
                                                          select.temp_day
                                                              .refresh();
                                                          select.temp_qty
                                                              .refresh();
                                                          select.day_qty
                                                              .refresh();
                                                          print(select.day_qty
                                                              .value);
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          minimumSize: Size
                                                              .zero,
                                                          padding: EdgeInsets
                                                              .zero,
                                                          tapTargetSize: MaterialTapTargetSize
                                                              .shrinkWrap,
                                                        ),
                                                        child: Text(
                                                          "+",
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins_medium',
                                                            color: Colors.black,
                                                            fontSize: 20.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              visible: select.selectdayvisible.value[index],))
                                    ))
                              ],
                            ))),
                       // SizedBox(height: 10.h,),
                       //  Obx(() =>
                       //    select.selectdayvisible.value.contains(true) ?
                       //  /*  Dialog(
                       //      child: Container(color: Colors.white,
                       //        height: 38.h,margin: EdgeInsets.only(bottom: 5.h),
                       //        child: SfDateRangePicker(
                       //          confirmText: "Done",
                       //          // onSubmit: (p0) {
                       //          //   print("ans=$p0");
                       //          //   Navigator.pop(context);
                       //          // },
                       //          // onCancel: () {
                       //          //   Navigator.pop(context);
                       //          // },
                       //          // showActionButtons: true,
                       //          initialSelectedDate: DateTime.now().add(Duration(days: 1)),
                       //          view: DateRangePickerView.month,
                       //          selectionMode: DateRangePickerSelectionMode.multiple,
                       //          controller: _datePickerController,
                       //          enablePastDates: false,
                       //          todayHighlightColor: color.primarycolor,
                       //          selectionColor: color.primarycolor,
                       //          minDate: select.tom_date.value,
                       //          maxDate: select.tom_date.value.add(Duration(
                       //              days: select.remaindaysinmonth.value + select.nextdaysinmonth.value)),
                       //          selectableDayPredicate: (date) {
                       //           if(selectedDays.contains(date.weekday)){
                       //             return true;
                       //           }
                       //           return false;
                       //          },
                       //          onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                       //            print("month====${dateRangePickerSelectionChangedArgs.value}");
                       //            List<DateTime> list = dateRangePickerSelectionChangedArgs.value;
                       //            print("month====${list.length}");
                       //            list.forEach((element) {
                       //              DateTime d = element;
                       //              // DateTime d=list.last;
                       //              print("D: $d");
                       //              int days = DateUtils.getDaysInMonth(d.year, d.month);
                       //              print("totaldays=$days");
                       //              DateTime lastdate = DateTime.utc(d.year, d.month + 1).subtract(Duration(days: 1));
                       //              print(lastdate);
                       //              int t = d.day;
                       //              print("current date=${d.day}");
                       //              print("odd=${t % 2 == 0}");
                       //
                       //                for (int i = t; i <= days; i = i + 1) {
                       //                  if (!select.alter_dateTime.contains(DateTime(d.year, d.month, i))) {
                       //                    select.alter_dateTime.value.add(DateTime(d.year, d.month, i));
                       //                    print("i===${DateTime(d.year, d.month, i)}");
                       //                  }
                       //                  else {
                       //                    break;
                       //                  }
                       //              }
                       //            });
                       //            selectedDays = dateRangePickerSelectionChangedArgs.value;
                       //
                       //            _datePickerController.selectedDates = select.alter_dateTime.value;
                       //            if (select.alter_dateTime.value.length != 0) {
                       //              select.alter_dateTime.value.forEach((element) {
                       //                if (!select.temp_dateTime.contains("${element.day}-${element.month}-${element.year}")) {
                       //                  select.temp_dateTime.add("${element.day}-${element.month}-${element.year}");
                       //                }
                       //              });
                       //              select.temp_dateTime.refresh();
                       //            }
                       //
                       //            print("temp=${select.temp_dateTime.value}");
                       //            select.alter_dateTime.refresh();
                       //            select.date.value = select.temp_dateTime.value.first;
                       //            select.enddate.value = select.temp_dateTime.value.last;
                       //
                       //            // t=select.alter_dateTime.value.length;
                       //            print("t===${_datePickerController.selectedDates}");
                       //            Future.delayed(Duration(seconds: 1)).then((value) {
                       //              if (t == 0) {
                       //                t = 1;
                       //                Navigator.of(context).pop();
                       //              }
                       //            });
                       //          },
                       //        )
                       //    ),
                       //  ) */
                       //    Row(
                       //        children: [
                       //          Expanded(
                       //            child: Padding(
                       //              padding: const EdgeInsets.all(8.0),
                       //              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                       //                children: [
                       //                  Text("Start From",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                       //                  Container(
                       //                    height: 50,
                       //                    width: double.infinity,
                       //                    margin: EdgeInsets.symmetric(vertical: 5),
                       //                    padding: EdgeInsets.all(5),
                       //                    decoration: BoxDecoration(
                       //                      color: Colors.grey.shade300,
                       //                      borderRadius: BorderRadius.circular(10)
                       //                    ),
                       //                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       //                      children: [
                       //                        Obx(() =>
                       //                            Text(" ${select.startDate.value}",style: TextStyle(fontWeight: FontWeight.w400),)),
                       //                        IconButton(onPressed: () {
                       //                          _selectDate(context);
                       //                        }, icon: Icon(Icons.calendar_month,color: color.primarycolor,))
                       //                      ],
                       //                    )
                       //                    /*TextField(
                       //                      controller: _startDateController,
                       //                      readOnly: true,
                       //                      onTap: () {
                       //                        _selectDate(context,0);
                       //                      },
                       //                      decoration: InputDecoration(
                       //                        // labelText: 'Start From',
                       //                        border: InputBorder.none,
                       //                        hintText: "Start From",
                       //                        suffixIcon: Icon(Icons.calendar_today,color: color.primarycolor,),
                       //                      ),
                       //                    )*/,
                       //                  ),
                       //                ],
                       //              ),
                       //            ),
                       //          ),
                       //          Expanded(
                       //            child: Padding(
                       //              padding: const EdgeInsets.all(8.0),
                       //              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                       //                children: [
                       //                  Text("To Date",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                       //                  Container(
                       //                    height: 50,
                       //                    width: double.infinity,
                       //                    margin: EdgeInsets.symmetric(vertical: 5),padding: EdgeInsets.all(5),
                       //                    decoration: BoxDecoration(
                       //                        color: Colors.grey.shade300,
                       //                        borderRadius: BorderRadius.circular(10)
                       //                    ),
                       //                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       //                      children: [
                       //                        Obx(() =>
                       //                            Text(" ${select.endDate.value}",style: TextStyle(fontWeight: FontWeight.w400),)),
                       //                        IconButton(onPressed: () {
                       //                          _selectDate1(context);
                       //                        }, icon: Icon(Icons.calendar_month,color: color.primarycolor,))
                       //                      ],
                       //                    )
                       //                    /*TextField(
                       //                      controller: _endDateController,
                       //                      readOnly: true,
                       //                      onTap: () {
                       //                        _selectDate(context,1);
                       //                      },
                       //                      decoration: InputDecoration(
                       //                        // labelText: 'End To',
                       //                        border: InputBorder.none,
                       //                        hintText: 'End To',
                       //                        suffixIcon: Icon(Icons.calendar_today,color: color.primarycolor,),
                       //                      ),
                       //                    ),*/
                       //                  ),
                       //                ],
                       //              ),
                       //            ),
                       //          ),
                       //        ],
                       //      )
                       //    : SizedBox(),
                       //  )
                      ],
                    ),
                  ),
                ),
                bottomSheet: Obx(() =>
                (select.sub_str.value == "One Time" ||
                    select.sub_str.value == "Alternate" ||
                    select.sub_str.value == "Daily") ?
                InkWell(
                  onTap: () {
                    print("QTY=${widget.item!.itemQty}");
                    arr_addonsid.clear();
                    arr_addonsname.clear();
                    arr_addonsprice.clear();
                    for (int i = 0; i < widget.item!.addons!.length; i++) {
                      if (widget.item!.addons![i].isselected ==
                          true) {
                        arr_addonsid.add(
                            widget.item!.addons![i].id.toString());
                        arr_addonsname.add(
                            widget.item!.addons![i].name.toString());
                        arr_addonsprice.add(numberFormat.format(
                            double.parse(widget.item!.addons![i].price
                                .toString())));
                      }
                    }
                    // add_cart_qty();
                    add_to_cartAPI();
                  },
                  child: Container(
                    margin: EdgeInsets.all(3.w),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                        color: themenofier.isdark
                            ? Colors.white
                            : color.primarycolor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: themenofier.isdark
                            ? Colors.white
                            : color.primarycolor,
                      ),
                    ),
                    height: 6.h,
                    width: 100.w,
                    alignment: Alignment.center,
                    child: Text(
                      "Confirm",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Poppins_medium',color: themenofier.isdark
                          ? Colors.black
                          : color.white,

                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ) :
                Obx(() =>
                select.selectdayvisible.value.contains(true) ?
                InkWell(
                  onTap: () {
                    arr_addonsid.clear();
                    arr_addonsname.clear();
                    arr_addonsprice.clear();
                    for (int i = 0; i < widget.item!.addons!.length; i++) {
                      if (widget.item!.addons![i].isselected ==
                          true) {
                        arr_addonsid.add(
                            widget.item!.addons![i].id.toString());
                        arr_addonsname.add(
                            widget.item!.addons![i].name.toString());
                        arr_addonsprice.add(numberFormat.format(
                            double.parse(widget.item!.addons![i].price
                                .toString())));
                      }
                    }

                    add_to_cartAPI();
                  },
                  child: Container(
                      margin: EdgeInsets.all(3.w),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: color.primarycolor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: color.primarycolor,
                        ),
                      ),
                      height: 6.h,
                      width: 100.w,
                      child: Row(
                        children: [
                          Text(
                            "${select.total.value}",
                            style: TextStyle(
                                fontFamily: 'Poppins_medium',
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Confirm & Order",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Poppins_medium',
                                color: color.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      )
                  ),
                ) : SizedBox(),))

            ),
          );
        });
  }
  String? userid = "";
  String? currency;
  String? currency_position;
  date() async {
    // DateTime now = new DateTime.now();
    // DateTime date = new DateTime(now.year, now.month, now.day+1);
    // select.tom_date.value=date;
    // select.date.value="${date.day}-${date.month}-${date.year}";
    // _datePickerController.selectedDate =date;
    // select.daysinmonth.value = DateUtils.getDaysInMonth(date.year, date.month);
    // select.nextdaysinmonth.value = DateUtils.getDaysInMonth(date.year, date.month+1);
    // select.remaindaysinmonth.value=select.daysinmonth.value-date.day;
    // select.daterange.value=[];
    // select.monthlist.value=[];
    // select.alter_dateTime.value=[];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = (prefs.getString(UD_user_id) ?? "");
    currency = (prefs.getString(APPcurrency) ?? "");
    currency_position = (prefs.getString(APPcurrency_position) ?? "");
    print(currency_position);
    print(currency);
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
    select.selectdayvisible.value=List.filled(8, false);
    setState(() {

    });
  }

  Future<void> _selectDate(BuildContext context) async {
    /*final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );*/
    showDialog(context: context,
      builder: (context) =>
          Dialog(
            child: Container(color: Colors.white,
                height: 50.h,
                child: SfDateRangePicker(
                  initialSelectedDate: DateTime.now().add(Duration(days: 1)),
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.single,
                  controller: _datePickerController,
                  enablePastDates: false,
                  selectionColor: color.primarycolor,
                  todayHighlightColor: color.primarycolor,
                  minDate: select.tom_date.value,
                  maxDate: select.tom_date.value.add(Duration(
                      days: select.remaindaysinmonth.value + select.nextdaysinmonth.value)),
                  onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                    print("${dateRangePickerSelectionChangedArgs.value}");
                    DateTime selectdate = dateRangePickerSelectionChangedArgs.value;
                    select.startDate.value = "${selectdate.day}-${selectdate.month}-${selectdate.year}";

                    Navigator.pop(context);
                  },
                  showActionButtons: true,
                  onSubmit: (p0) {
                    print(p0);
                    DateTime selectdate = p0 as DateTime;
                    select.startDate.value = "${selectdate.day}-${selectdate.month}-${selectdate.year}";

                    Navigator.pop(context);
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  },

                )),
          ),);

    /*if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _startDateController.text = _selectedDate.toString().substring(0,10);
      });
    }*/

  }
  Future<void> _selectDate1(BuildContext context) async {
    /*final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );*/
    showDialog(context: context,
      builder: (context) =>
          Dialog(
            child: Container(color: Colors.white,
                height: 50.h,
                child: SfDateRangePicker(
                  initialSelectedDate: DateTime.now().add(Duration(days: 1)),
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.single,
                  controller: _datePickerController,
                  enablePastDates: false,
                  selectionColor: color.primarycolor,
                  todayHighlightColor: color.primarycolor,
                  minDate: select.tom_date.value,
                  maxDate: select.tom_date.value.add(Duration(
                      days: select.remaindaysinmonth.value + select.nextdaysinmonth.value)),
                  onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                    print("${dateRangePickerSelectionChangedArgs.value}");
                    DateTime selectdate = dateRangePickerSelectionChangedArgs.value;
                    select.endDate.value = "${selectdate.day}-${selectdate.month}-${selectdate.year}";

                    Navigator.pop(context);
                  },
                  showActionButtons: true,
                  onSubmit: (p0) {
                    print(p0);
                    DateTime selectdate = p0 as DateTime;
                    select.endDate.value= "${selectdate.day}-${selectdate.month}-${selectdate.year}";

                    Navigator.pop(context);
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  },
                )),
          ),);


  }

  void _toggleSelectedDay(int day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      } else {
        selectedDays.add(day);
      }
    });
  }
}
/*Dialog(
                                child: Container(
                                    height: 38.h,margin: EdgeInsets.only(bottom: 6.h),
                                    child: SfDateRangePicker(
                                      confirmText: "Done",
                                      onSubmit: (p0) {
                                        print("ans=$p0");
                                        List<PickerDateRange> p = p0 as List<PickerDateRange>;
                                        if (p.length == 1) {
                                          select.date.value =
                                          "${p[0].startDate!.day}-${p[0].startDate!.month}-${p[0].startDate!.year}";
                                          select.enddate.value =
                                          "${p[0].endDate!.day}-${p[0].endDate!.month}-${p[0].endDate!.year}";
                                        }
                                        else {
                                          select.date.value =
                                          "${p[0].startDate!.day}-${p[0].startDate!.month}-${p[0].startDate!.year}";
                                          select.enddate.value =
                                          "${p[p.length - 1].endDate!.day}-${p[p.length - 1].endDate!.month}-${p[p
                                              .length - 1].endDate!.year}";
                                        }
                                        Navigator.pop(context);
                                      },
                                      onCancel: () {Navigator.pop(context);},

                                      showActionButtons: true,
                                      initialSelectedDate: DateTime.now().add(Duration(days: 6)),
                                      view: DateRangePickerView.month,
                                      selectionMode: DateRangePickerSelectionMode.multiRange,
                                      selectionTextStyle: TextStyle(color: color.primarycolor),
                                      selectionColor: color.primarycolor,
                                      rangeSelectionColor: color.primarycolor.withOpacity(0.5),
                                      startRangeSelectionColor: color.primarycolor.withOpacity(0.5),
                                      endRangeSelectionColor: color.primarycolor.withOpacity(0.5),
                                      todayHighlightColor: color.primarycolor,
                                      controller: _datePickerController,
                                      enablePastDates: false,
                                      minDate: select.tom_date.value,
                                      maxDate: select.tom_date.value.add(Duration(
                                          days: select.remaindaysinmonth.value + select.nextdaysinmonth.value)),
                                      onSelectionChanged: (
                                          dateRangePickerSelectionChangedArgs) {
                                        List<PickerDateRange> list = dateRangePickerSelectionChangedArgs.value;
                                        list.forEach((element) {
                                          print("month=${element.startDate!.month}");
                                          if (!select.monthlist.value.contains(element.startDate!.month)) {
                                            select.monthlist.value.add(element.startDate!.month);
                                            if (element.startDate!.month == select.tom_date.value.month) {
                                              int days = DateUtils.getDaysInMonth(
                                                  element.startDate!.year,
                                                  element.startDate!.month);
                                              PickerDateRange pick = PickerDateRange(
                                                  DateTime(
                                                      element.startDate!.year,
                                                      element.startDate!.month,
                                                      select.tom_date.value.day),
                                                  DateTime(
                                                      element.startDate!.year,
                                                      element.startDate!.month, 1).add(Duration(days: days - 1)));
                                              select.daterange.value.add(pick);
                                            }
                                            else {
                                              int days = DateUtils.getDaysInMonth(
                                                  element.startDate!.year,
                                                  element.startDate!.month);
                                              PickerDateRange pick = PickerDateRange(
                                                  DateTime(
                                                      element.startDate!.year,
                                                      element.startDate!.month,
                                                      1),
                                                  DateTime(
                                                      element.startDate!.year,
                                                      element.startDate!.month, 1).add(Duration(days: days - 1)));
                                              select.daterange.value.add(pick);
                                            }
                                            print("month=${select.daterange.value}");
                                          }
                                        });
                                        _datePickerController.selectedRanges = select.daterange.value;
                                      },
                                    )),
                              )*/