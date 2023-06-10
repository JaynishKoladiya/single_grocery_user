// ignore_for_file: must_be_immutable, prefer_const_constructors, unrelated_type_equality_checks, unused_import, prefer_final_fields, camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names
import 'dart:collection';

import 'package:singlegrocery/pages/Home/product.dart';
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
import '../cart/cartpage.dart';



class custompage extends StatefulWidget {
  int? itemid;
  dynamic itemName,imgurl,itemType,tax,price,itemQty;

  custompage(this.itemid, this.itemName, this.imgurl, this.itemType, this.tax,
      this.price,this.itemQty);

  @override
  State<custompage> createState() => _custompageState();

}

class _custompageState extends State<custompage> {
  DateRangePickerController _datePickerController = DateRangePickerController();
  String? userid = "";
  int? cart;
  itemdetailsmodel? itemdata;
  sub.SubscriptionType? SubscriptionTypemodel;
  cartcount count = Get.put(cartcount());
  bool? isproductdetail = true;
  bool? issubscriptiondetail = true;
  String? currency;
  String? currency_position;
  List<String> arr_addonsid = [];
  List<String> arr_addonsname = [];
  List<String> arr_addonsprice = [];
  List<String> days = ["SU","M","TU","W","T","F","S"];


  buttoncontroller select = Get.put(buttoncontroller());
  @override
  void initState() {
    super.initState();
    date();
    select.total.value=0;
    select.counts = [1,1,1,1,1,1,1].obs;
  }

  date() async {
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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              actions: [
                // IconButton(onPressed: () {
                //   Navigator.of(context).pop();
                // }, icon: Icon(Icons.arrow_back))
              ],
            ),
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:Column(
                      children: [
                        Container(
                            height: 15.h,
                            margin: EdgeInsets.only(left: 4.w,top: 2.h,right: 4.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  widget.imgurl!,
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
                                    widget.itemName.toString(),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'Poppins_semibold',
                                      color: color.primarycolor
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
                                  if (widget.itemQty == "" ||
                                      double.parse(widget.itemQty
                                          .toString()) <=
                                          0) ...[
                                    Text(
                                      LocaleKeys.Out_of_Stock.tr(),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 8.sp,
                                        color: color.grey,
                                      ),
                                    ),
                                  ]
                                  else if (widget.tax == "" ||
                                      widget.tax == "0") ...[
                                    Text(
                                      LocaleKeys.Inclusive_of_all_taxes.tr(),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 8.sp,
                                        color: color.primarycolor,
                                      ),
                                    ),
                                  ]
                                  else ...[
                                      Text(
                                        "${widget.tax}% ${LocaleKeys.additional_tax.tr()}",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 8.sp,
                                          color: color.primarycolor,
                                        ),
                                      ),

                                    ],
                                  Text(
                                    "Rs.${numberFormat.format(double.parse(widget.price.toString()))}",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontFamily: 'Poppins_bold',
                                    ),
                                  ),
                                ],)
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top:
                                MediaQuery.of(context).size.height /
                                    95)),
                        Column(
                          children: [
                            Container(
                            margin: EdgeInsets.only(
                              left: 4.w,
                              right: 4.w,
                              top: 1.h,
                              bottom: 2.h,

                            ),
                            child: Text(
                              LocaleKeys.select_days,
                              style: TextStyle(
                                  fontSize: 12.sp, fontFamily: 'Poppins_semibold',color: color.primarycolor),
                            ),

                          ),
                            // Obx(() => Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //     children: days.map((e) => Expanded(
                            //       child: Container(
                            //         margin: EdgeInsets.all(2.w),
                            //         decoration: BoxDecoration(
                            //           color: select.selectday.value==e?color.primarycolor.withOpacity(0.5):null,
                            //           borderRadius: BorderRadius.circular(8),
                            //           border: Border.all(
                            //             color: select.selectday.value==e?color.primarycolor:Colors.black,
                            //           ),
                            //         ),
                            //         // height: 4.h,
                            //         child: TextButton(
                            //           child:Text(
                            //             "$e",
                            //             style: TextStyle(
                            //               fontFamily: 'Poppins_medium',
                            //               color: Colors.black,
                            //               fontSize: 10.sp,
                            //             ),
                            //           ),
                            //           onPressed: () async {
                            //             select.selectday.value=e;
                            //             if(select.selectday.value==LocaleKeys.sunday)
                            //               {
                            //                 select.selectdayvisible.value[0]=!select.selectdayvisible.value[0];
                            //                 select.selectdayvisible.refresh();
                            //               }
                            //           },
                            //         ),
                            //       ),
                            //     )).toList()
                            // ),),
                            GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: days.length
                            ), itemCount: days.length,shrinkWrap:true,itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  select.selectday.value=days[index];
                                  select.selectdayvisible.value[index]=!select.selectdayvisible.value[index];
                                  if(select.selectdayvisible.value[index])
                                    {
                                      select.total.value=select.total.value+double.parse(widget.price.toString());
                                    }
                                  else
                                    {

                                      select.total.value=select.total.value-(select.counts[index]*double.parse(widget.price.toString()));
                                      select.counts[index]=1;
                                    }
                                  select.selectdayvisible.refresh();
                                },
                                child: Obx(() => Container(
                                  margin: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: select.selectdayvisible.value[index]?color.primarycolor.withOpacity(0.5):Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: select.selectdayvisible.value[index]?color.primarycolor:Colors.black,
                                      // color: Colors.black,
                                    ),
                                  ),
                                  // height: 4.h,
                                  child: TextButton(
                                    child:Text(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   margin: EdgeInsets.only(
                            //     left: 4.w,
                            //     right: 4.w,
                            //     top: 1.h,
                            //     bottom: 2.h,
                            //   ),
                            //   child: Text(
                            //     LocaleKeys.select_per_days,
                            //     style: TextStyle(
                            //         fontSize: 12.sp, fontFamily: 'Poppins_semibold'),
                            //   ),
                            // ),
                            Obx(() => Column(
                              children:  List.generate(7, (index) => Visibility(
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 3.w, right: 3.w),
                                title: Text(
                                  "${select.daylist[index]}",
                                  style: TextStyle(
                                      fontSize: 12.sp, fontFamily: 'Poppins_semibold'),
                                ),
                                trailing: Container(
                                  // margin: EdgeInsets.all(3.w),
                                  decoration: BoxDecoration(
                                    color: color.primarycolor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
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
                                          if(select.counts[index]>0)
                                            {
                                              select.total.value=select.total.value-double.parse(widget.price.toString());
                                              select.counts[index]=select.counts[index]-1;
                                            }

                                        },
                                        style: TextButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                        "${select.counts[index]}",
                                        style: TextStyle(
                                          fontFamily: 'Poppins_medium',
                                          color: Colors.black,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          print("hello");
                                          select.counts[index]=select.counts[index]+1;
                                          select.total.value=select.total.value+double.parse(widget.price.toString());
                                        },
                                        style: TextButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                              ),visible: select.selectdayvisible.value[index],))
                            )),

                          ],
                        ),
                        SizedBox(
                          height: 3.h,
                        )
                      ],
                    )
                ),

              ],
            ),
            // bottomSheet: Obx(() => select.selectdayvisible.value.contains(true)?Container(
            //   margin: EdgeInsets.all(3.w),
            //   padding: EdgeInsets.all(3.w),
            //   decoration: BoxDecoration(
            //     color: color.primarycolor.withOpacity(0.7),
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(
            //       color: color.primarycolor,
            //     ),
            //   ),
            //   height: 6.h,
            //   width: 100.w,
            //   child:Row(
            //     children: [Text(
            //       "${select.total.value}",
            //       style: TextStyle(
            //         fontFamily: 'Poppins_medium',
            //         color: Colors.black,
            //         fontSize: 12.sp,
            //         fontWeight: FontWeight.bold
            //       ),
            //     ),Spacer(),Text(
            //       "Confirm & Order",
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         fontFamily: 'Poppins_medium',
            //         color: Colors.black,
            //         fontSize: 10.sp,
            //           fontWeight: FontWeight.bold
            //       ),
            //     )],
            //   )
            // ):SizedBox(),)

        ));
  }
}
