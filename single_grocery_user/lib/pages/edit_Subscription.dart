import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getmethod;
import 'package:singlegrocery/pages/Home/product.dart';
import 'package:sizer/sizer.dart';
import 'package:singlegrocery/common%20class/color.dart';
import '../config/API/API.dart';
import '../translation/locale_keys.g.dart';
import 'package:singlegrocery/widgets/loader.dart';
import '../../model/home/SubscriptionTypeModel.dart' as sub;
class edit_Subscription extends StatefulWidget {
  const edit_Subscription({Key? key}) : super(key: key);

  @override
  State<edit_Subscription> createState() => _edit_SubscriptionState();
}

class _edit_SubscriptionState extends State<edit_Subscription> {
  buttoncontroller select = getmethod.Get.put(buttoncontroller());
  bool? issubscriptiondetail = true;
  sub.SubscriptionType? SubscriptionTypemodel;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscriptionAPI();

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
  @override
  Widget build(BuildContext context) {
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
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 15.h,
              margin: EdgeInsets.only(left: 4.w,top: 2.h,right: 4.w),
              // color: color.primarycolor,
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "Image/grocery.png",
                    fit: BoxFit.contain,
                    height: 10.h,
                    width: 10.h,
                  ),
                  Column(children: [
                    Text(
                      "product name",
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Poppins_semibold',
                      ),
                    ),
                    Text(
                      "% ${LocaleKeys.additional_tax}",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 8.sp,
                        color: color.primarycolor,
                      ),
                    ),
                    Text(
                      "Rs.14",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Poppins_bold',
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
                  fontSize: 12.sp,
                  fontFamily: 'Poppins_semibold',
                ),
              ),
            ),
            SizedBox(height: 5.h,),
            ListTile(
             title: Text(
               "Your customized daily plan details",
               overflow: TextOverflow.clip,
               textAlign: TextAlign.start,
               style: TextStyle(
                 fontSize: 12.sp,
                 fontFamily: 'Poppins_semibold',
               ),
             ),
             trailing: Text(
               "Edit Plan",
               overflow: TextOverflow.clip,
               textAlign: TextAlign.start,
               style: TextStyle(
                 color: color.primarycolor,
                 fontSize: 12.sp,
                 fontFamily: 'Poppins_semibold',
               ),
             ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4.w),
              height: 8.h,
              // color: color.primarycolor,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        "Day(s)",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Poppins_semibold',
                          color: color.status1
                        ),
                      ),
                      Container(
                        height: 2,
                        width: 15.w,
                          color: color.status1
                      ),
                      Text(
                        "Qty",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.sp,
                            color: color.status1
                        ),
                      ),

                    ],),
                  Container(
                      height: 2,
                      width: 15.w,
                      // color: color.status1
                  ),
                  Column(children: [
                    Text(
                      "All",
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Poppins_semibold',
                          color: color.status1
                      ),
                    ),
                    Container(
                      height: 5,
                      // color: Colors.blue,
                    ),
                    Text(
                      "2",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                          color: color.status1
                      ),
                    ),

                  ],),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4.w),
              child: Text(
                "Start Date",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Poppins_semibold',
                    color: color.status1
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4.w),
              child: Text(
                "14 Dec 22",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Poppins_semibold',
                    color: color.status1
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4.w,top: 4.h,bottom: 4.h),
              child: Text(
                "Or Change the plan type",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    fontFamily: 'Poppins_semibold',
                    color: color.black
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: select.listdata.value.map((e) {
                  return e.isAvailable==1?
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    height: 4.h,
                    child: TextButton(
                      child:Text(
                        "${e.subsType}",
                        style: TextStyle(
                          fontFamily: 'Poppins_medium',
                          color: Colors.black,
                          fontSize: 8.sp,
                        ),
                      ),
                     onPressed: () {

                     },
                    ),
                  ):SizedBox();
                }).toList()
            ),
            SizedBox(height: 5.h,),
            ListTile(
             leading: Icon(Icons.delete,color: color.primarycolor,),
             title: Text("Remove From Subscription",style: TextStyle(color: color.primarycolor),),
            )
          ],
        ),
      ),
    );
  }
}
