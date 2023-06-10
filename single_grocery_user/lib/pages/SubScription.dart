import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/pages/edit_Subscription.dart';
import 'package:singlegrocery/pages/profile/transactionhistory.dart';
import 'package:singlegrocery/theme/ThemeModel.dart';
import 'package:sizer/sizer.dart';

import '../translation/locale_keys.g.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  @override
  Widget build(BuildContext context) {
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
          title: Text(
            LocaleKeys.Subscription.tr(),
            textAlign: TextAlign.center,
            style:
             TextStyle(fontFamily: 'Poppins_semibold', fontSize: 16,
              color: themenofier.isdark
                  ? Colors.white
                  : color.primarycolor,
            ),
          ),
          centerTitle: true,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Transaction_history()),
                  );
                },
                child: const ImageIcon(
                  AssetImage('Icons/info.png'),
                  size: 26,
                )),
            const Padding(padding: EdgeInsets.only(right: 15))
          ],
        ),
        body: Column(children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 2.h,
                    left: 2.w,
                    right: 2.w,
                    bottom: 2.h,
                  ),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: color.primarycolor,
                      ),
                      height: 22.5.h,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Image.asset("Image/grocery.png",height: 50,width: 50,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 1.h,
                                    left: 2.5.w,
                                    right: 2.5.w,
                                  ),
                                  child: Text(
                                    LocaleKeys.More_sub.tr(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins_semibold',
                                        fontSize: 15.sp,
                                        color: Colors.white),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 2.h,
                                    left: 2.5.w,
                                    right: 2.5.w,
                                  ),
                                  child: Text(
                                    LocaleKeys.add_sub.tr(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 8.8.sp,
                                        color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: color.primarycolor
                                  ),
                                  onPressed: () {

                                  },
                                  child: Text(
                                    LocaleKeys.add_now.tr(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins_bold',
                                        fontSize: 12.5.sp,
                                       ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  margin: EdgeInsets.only(
                                    bottom: 1.2.h,
                                    left: 2.5.w,
                                    right: 2.5.w,
                                  ),
                                  child: Text(
                                    LocaleKeys.t_c
                                        .tr(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 7.sp,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(child: _tabSection(context))
              ],
            ),
          ),


        ]),
    ),
      );
    });
  }
}

Widget _tabSection(BuildContext context) {
  return DefaultTabController(
    length: 2,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: color.white,
          constraints: BoxConstraints.expand(height: 50),
          child: TabBar(tabs: [
            Tab(text: LocaleKeys.My_Subscription.tr(),),
            Tab(text: LocaleKeys.Explore.tr(),)
          ],labelColor: color.primarycolor,
          indicatorColor: color.primarycolor,),
        ),
        Expanded(
          // height: MediaQuery.of(context).size.height,
          child: TabBarView(children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 15.h,
                        margin: EdgeInsets.only(left: 4.w,top: 2.h),
                        // color: color.primarycolor,
                        child:Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Image/grocery.png",
                              fit: BoxFit.contain,
                              height: 10.h,
                              width: 10.h,
                            ),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  "product name",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppins_semibold',
                                  ),
                                ),
                                Text(
                                  "% ${LocaleKeys.additional_tax.tr()}",
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
                            ),
                            Column(children: [
                              Expanded(child: InkWell(onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => edit_Subscription(),));
                              },child: Column(children: [Icon(Icons.edit,color: color.primarycolor,),Text("EDIT")],))),
                              Expanded(child: InkWell(onTap: () {

                              },child: Column(children: [Icon(Icons.pause,color: color.primarycolor,),Text("PAUSE")],))),
                            ],)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4.w),
                        height: 8.h,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(children: [
                              Text(
                                "Plan Type",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins_semibold',
                                ),
                              ),
                              Text(
                                "Customized daily",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 8.sp,
                                  color: color.primarycolor,
                                ),
                              ),

                            ],),
                            SizedBox(width: 8.h,),
                            Column(children: [
                              Text(
                                "Start Date",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins_semibold',
                                ),
                              ),
                              Text(
                                "14 may 2023",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 8.sp,
                                  color: color.primarycolor,
                                ),
                              ),

                            ],)
                          ],
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
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppins_semibold',
                                  ),
                                ),
                                Container(
                                  height: 5,
                                  // color: Colors.blue,
                                ),
                                Text(
                                  "Qty",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 8.sp,
                                    color: color.primarycolor,
                                  ),
                                ),

                              ],),
                            Container(
                              width: 8.w,
                              // color: Colors.blue,
                            ),
                            Column(children: [
                              Text(
                                "All",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins_semibold',
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
                                  fontSize: 8.sp,
                                  color: color.primarycolor,
                                ),
                              ),

                            ],)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 15.h,
                        margin: EdgeInsets.only(left: 4.w,top: 2.h),
                        // color: color.primarycolor,
                        child:Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Image/grocery.png",
                              fit: BoxFit.contain,
                              height: 10.h,
                              width: 10.h,
                            ),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  "product name",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppins_semibold',
                                  ),
                                ),
                                Text(
                                  "% ${LocaleKeys.additional_tax.tr()}",
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
                            ),
                            Column(children: [
                              Expanded(child: Column(children: [Icon(Icons.edit,color: color.primarycolor,),Text("EDIT")],)),
                              Expanded(child: Column(children: [Icon(Icons.pause,color: color.primarycolor,),Text("PAUSE")],)),
                            ],)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4.w),
                        height: 8.h,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(children: [
                              Text(
                                "Plan Type",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins_semibold',
                                ),
                              ),
                              Text(
                                "Customized daily",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 8.sp,
                                  color: color.primarycolor,
                                ),
                              ),

                            ],),
                            SizedBox(width: 8.h,),
                            Column(children: [
                              Text(
                                "Start Date",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins_semibold',
                                ),
                              ),
                              Text(
                                "14 may 2023",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 8.sp,
                                  color: color.primarycolor,
                                ),
                              ),

                            ],)
                          ],
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
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppins_semibold',
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  width: 15.w,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "Qty",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12.sp,
                                    color: color.primarycolor,
                                  ),
                                ),

                              ],),
                            Container(
                              width: 8.w,
                              // color: Colors.blue,
                            ),
                            Column(children: [
                              Text(
                                "All",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins_semibold',
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
                                  fontSize: 8.sp,
                                  color: color.primarycolor,
                                ),
                              ),

                            ],)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 15.h,
                        margin: EdgeInsets.only(left: 4.w,top: 2.h),
                        // color: color.primarycolor,
                        child:Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Image/grocery.png",
                              fit: BoxFit.contain,
                              height: 10.h,
                              width: 10.h,
                            ),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  "product name",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppins_semibold',
                                  ),
                                ),
                                Text(
                                  "% ${LocaleKeys.additional_tax.tr()}",
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
                            ),
                            Column(children: [
                              Expanded(child: Column(children: [Icon(Icons.edit,color: color.primarycolor,),Text("EDIT")],)),
                              Expanded(child: Column(children: [Icon(Icons.pause,color: color.primarycolor,),Text("PAUSE")],)),
                            ],)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4.w),
                        height: 8.h,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(children: [
                              Text(
                                "Plan Type",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins_semibold',
                                ),
                              ),
                              Text(
                                "Customized daily",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 8.sp,
                                  color: color.primarycolor,
                                ),
                              ),

                            ],),
                            SizedBox(width: 8.h,),
                            Column(children: [
                              Text(
                                "Start Date",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins_semibold',
                                ),
                              ),
                              Text(
                                "14 may 2023",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 8.sp,
                                  color: color.primarycolor,
                                ),
                              ),

                            ],)
                          ],
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
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppins_semibold',
                                  ),
                                ),
                                Container(
                                  height: 5,
                                  // color: Colors.blue,
                                ),
                                Text(
                                  "Qty",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 8.sp,
                                    color: color.primarycolor,
                                  ),
                                ),

                              ],),
                            Container(
                              width: 8.w,
                              // color: Colors.blue,
                            ),
                            Column(children: [
                              Text(
                                "All",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins_semibold',
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
                                  fontSize: 8.sp,
                                  color: color.primarycolor,
                                ),
                              ),

                            ],)
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Text("Articles Body"),
            ),
          ]),
        ),
      ],
    ),
  );
}
