// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types, non_constant_identifier_names,   use_build_context_synchronously, prefer_const_constructors, empty_catches

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/model/favorite/addtocartmodel.dart';
import 'package:singlegrocery/model/favorite/itemmodel.dart';
import 'package:singlegrocery/pages/authentication/Login.dart';
import 'package:singlegrocery/pages/cart/cartpage.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:singlegrocery/common%20class/allformater.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/common%20class/icons.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';

class showvariation extends StatefulWidget {
  itemmodel favaritelistdata;

  showvariation(this.favaritelistdata);

  @override
  State<showvariation> createState() => _showvariationState();
}

class _showvariationState extends State<showvariation> {
  int? _variationselecationindex = 0;
  List<String> arr_addonsid = [];
  List<String> arr_addonsname = [];
  List<String> arr_addonsprice = [];
  String? userid;
  String? currency;
  String? currency_position;
  cartcount count = Get.put(cartcount());

  variationaddonsadd_to_cartAPI() async {
    loader.showLoading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(UD_user_id) ?? "";
    currency = (prefs.getString(APPcurrency) ?? "");
    currency_position = (prefs.getString(APPcurrency_position) ?? "");
    double addonstotalprice = 0;
    for (int i = 0; i < arr_addonsprice.length; i++) {
      addonstotalprice = addonstotalprice + double.parse(arr_addonsprice[i]);
    }
    try {
      var map = {
        "user_id": userid,
        "item_id": widget.favaritelistdata.id,
        "item_name": widget.favaritelistdata.itemName,
        "item_image": widget.favaritelistdata.imageName,
        "item_type": widget.favaritelistdata.itemType,
        "tax": numberFormat.format(double.parse(
          widget.favaritelistdata.tax,
        )),
        "item_price": widget.favaritelistdata.hasVariation == "1"
            ? numberFormat.format(double.parse(widget.favaritelistdata
                .variation![_variationselecationindex!].productPrice!))
            : numberFormat.format(double.parse(widget.favaritelistdata.price!)),
        "variation_id": widget.favaritelistdata.hasVariation == "1"
            ? widget.favaritelistdata.variation![_variationselecationindex!].id
            : "",
        "variation": widget.favaritelistdata.hasVariation == "1"
            ? widget.favaritelistdata.variation![_variationselecationindex!]
                .variation
            : "",
        "addons_id": arr_addonsid.join(","),
        "addons_name": arr_addonsname.join(","),
        "addons_price": arr_addonsprice.join(","),
        "addons_total_price": numberFormat.format(addonstotalprice),
        "subscription_id": "",
        "start_date": "",
        "end_date": "",
        "custom_day":[],
      };
      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Addtocart, data: map);
      var finaldata = addtocartmodel.fromJson(response.data);
      print(response.data);
      if (finaldata.status == 1) {
        loader.hideLoading();
        prefs.setString(APPcart_count, finaldata.cartCount.toString());
        count.cartcountnumber(int.parse(prefs.getString(APPcart_count)!));
        Navigator.pop(context, 1);

        // Navigator.pop(context, 1);

        // Navigator.of(context).pop(1);
        // Navigator.pop(context, Favorite());
        // Get.back();
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getdata();


  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString(UD_user_id) ?? "";
      currency = (prefs.getString(APPcurrency) ?? "");
      currency_position = (prefs.getString(APPcurrency_position) ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.5.h,
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 2.5.h,
                  ),
                  if (widget.favaritelistdata.itemType == "1") ...[
                    Image.asset(
                      Defaulticon.vegicon,
                      height: 3.5.h,
                    ),
                  ] else ...[
                    Image.asset(
                      Defaulticon.nonvegicon,
                      height: 3.5.h,
                    ),
                  ],
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: Text(
                      widget.favaritelistdata.itemName!,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontFamily: 'Poppins_bold', fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
              if (widget.favaritelistdata.hasVariation == "1") ...[
                Container(
                  margin: EdgeInsets.only(
                      left: 4.w, top: 2.h, bottom: 1.h, right: 5.w),
                  child: Text(
                    widget.favaritelistdata.attribute!,
                    style:
                        TextStyle(fontFamily: 'Poppins_bold', fontSize: 15.sp),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(0),
                  height: widget.favaritelistdata.variation!.length * 7.2.h,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.favaritelistdata.variation!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 5.w, bottom: 1.h, right: 5.w),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _variationselecationindex = index;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 3.3.h,
                                width: 3.3.h,
                                decoration: BoxDecoration(
                                    color: _variationselecationindex == index
                                        ? color.primarycolor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: color.primarycolor)),
                                child: Icon(Icons.done,
                                    color: _variationselecationindex == index
                                        ? Colors.white
                                        : Colors.transparent,
                                    size: 13.sp),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.favaritelistdata.variation![index]
                                              .availableQty ==
                                          "" ||
                                      int.parse(widget.favaritelistdata
                                              .variation![index].availableQty
                                              .toString()) <=
                                          0) ...[
                                    Text(
                                      widget.favaritelistdata.variation![index]
                                          .variation!,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontFamily: 'Poppins_semibold',
                                        color: color.grey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          currency_position == "1"
                                              ? "$currency${numberFormat.format(double.parse(widget.favaritelistdata.variation![index].productPrice!))}"
                                              : "${numberFormat.format(double.parse(widget.favaritelistdata.variation![index].productPrice!))}$currency",
                                          style: TextStyle(
                                              fontSize: 8.sp,
                                              color: color.grey,
                                              fontFamily: 'Poppins'),
                                        ),
                                        SizedBox(
                                          width: 35.w,
                                        ),
                                        Text(
                                          LocaleKeys.Out_of_Stock.tr(),
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: color.grey,
                                              fontFamily: 'Poppins'),
                                        )
                                      ],
                                    )
                                  ] else ...[
                                    Text(
                                      widget.favaritelistdata.variation![index]
                                          .variation!,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontFamily: 'Poppins_semibold',
                                      ),
                                    ),
                                    Text(
                                      currency_position == "1"
                                          ? "$currency${numberFormat.format(double.parse(widget.favaritelistdata.variation![index].productPrice!))}"
                                          : "${numberFormat.format(double.parse(widget.favaritelistdata.variation![index].productPrice!))}$currency",
                                      style: TextStyle(
                                          fontSize: 8.sp,
                                          fontFamily: 'Poppins'),
                                    )
                                  ],
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
              if (widget.favaritelistdata.addons!.isNotEmpty) ...[
                Container(
                  margin: EdgeInsets.only(left: 4.w, bottom: 1.h, right: 4.w),
                  child: Text(
                    LocaleKeys.Add_ons.tr(),
                    style:
                        TextStyle(fontFamily: 'Poppins_bold', fontSize: 15.sp),
                  ),
                ),
                SizedBox(
                  height: widget.favaritelistdata.addons!.length * 7.h,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.favaritelistdata.addons!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 5.w, bottom: 1.h, right: 5.w),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              var addonobject =
                                  widget.favaritelistdata.addons![index];

                              addonobject.isselected == true
                                  ? addonobject.isselected = false
                                  : addonobject.isselected = true;

                              widget.favaritelistdata.addons!.removeAt(index);

                              widget.favaritelistdata.addons!
                                  .insert(index, addonobject);
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 3.3.h,
                                width: 3.3.h,
                                decoration: BoxDecoration(
                                    color: widget.favaritelistdata
                                                .addons![index].isselected ==
                                            false
                                        ? Colors.transparent
                                        : color.primarycolor,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(color: color.primarycolor)),
                                child: Icon(Icons.done,
                                    color: widget.favaritelistdata
                                                .addons![index].isselected ==
                                            false
                                        ? Colors.transparent
                                        : Colors.white,
                                    size: 13.sp),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget
                                        .favaritelistdata.addons![index].name!,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontFamily: 'Poppins_semibold',
                                    ),
                                  ),
                                  Text(
                                    currency_position == "1"
                                        ? "$currency${numberFormat.format(double.parse(widget.favaritelistdata.addons![index].price.toString()))}"
                                        : "${numberFormat.format(double.parse(widget.favaritelistdata.addons![index].price.toString()))}$currency",
                                    style: TextStyle(
                                        fontSize: 8.sp, fontFamily: 'Poppins'),
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
              SizedBox(height: 9.h)
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: color.red,
                      )),
                  height: 6.8.h,
                  width: 45.w,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey,
                    ),
                    child: Text(
                      LocaleKeys.Cancel.tr(),
                      style: TextStyle(
                          fontFamily: 'Poppins_medium',
                          color: color.red,
                          fontSize: 12.sp),
                    ),
                    onPressed: () {
                      Navigator.pop(context, 0);
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.primarycolor)),
                  height: 6.8.h,
                  width: 45.w,
                  child: TextButton(
                    onPressed: () {
                      if (userid == "") {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (c) => Login()),
                            (r) => false);
                      } else {
                        arr_addonsid.clear();
                        arr_addonsname.clear();
                        arr_addonsprice.clear();
                        for (int i = 0;
                            i < widget.favaritelistdata.addons!.length;
                            i++) {
                          if (widget.favaritelistdata.addons![i].isselected ==
                              true) {
                            arr_addonsid.add(widget
                                .favaritelistdata.addons![i].id
                                .toString());
                            arr_addonsname.add(widget
                                .favaritelistdata.addons![i].name
                                .toString());
                            arr_addonsprice.add(numberFormat.format(
                                double.parse(widget
                                    .favaritelistdata.addons![i].price
                                    .toString())));
                          }
                        }

                        variationaddonsadd_to_cartAPI();
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: color.primarycolor,
                    ),
                    child: Text(
                      LocaleKeys.Continue.tr(),
                      style: TextStyle(
                          fontFamily: 'Poppins_medium',
                          color: Colors.white,
                          fontSize: 12.sp),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
