// ignore_for_file: non_constant_identifier_names
import 'package:singlegrocery/common%20class/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/common%20class/allformater.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:singlegrocery/common class/color.dart';

import '../../theme/ThemeModel.dart';
import 'addmoney.dart';
import 'transactionhistory.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? walletmoney;
  String? currency;
  String? currency_position;
  int? amount;
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      walletmoney = (prefs.getString(UD_user_wallet) ?? "0.00");
      currency = (prefs.getString(APPcurrency) ?? "");
      currency_position = (prefs.getString(APPcurrency_position) ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themenofier, child) {
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
          title: Text(
            LocaleKeys.My_Wallet.tr(),
            textAlign: TextAlign.center,
            style:
                 TextStyle(fontFamily: 'Poppins_semibold', fontSize: 16,
                   color: themenofier.isdark
                     ? Colors.white
                     : color.primarycolor,),
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
          Container(
            margin: EdgeInsets.only(
              bottom: 5.h,
              left: 2.w,
              right: 2.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              // color: themenofier.isdark ? Colors.grey.shade800 : Colors.white,
            ),
            // height: 43.h,
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  // color: color.primarycolor,
                  child: Image.asset(
                    'Icons/ic_logo.png',
                    height: 12.h,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 1.6.h,
                  ),
                  child: Text(
                    LocaleKeys.Wallet_Money.tr(),
                    style: TextStyle(
                      fontFamily: 'Poppins_semibold',
                      fontSize: 17.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.w,
                ),
                Row(
                  children: [
                    Image.asset(
                      'Icons/right.png',
                      height: 4.h,
                      color: color.primarycolor,
                    ),
                    SizedBox(
                      width: 2.5.w,
                    ),
                    Text(
                      LocaleKeys.Fast_Easy_Payments.tr(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Row(
                  children: [
                    Image.asset(
                      'Icons/right.png',
                      height: 4.h,
                      color: color.primarycolor,
                    ),
                    SizedBox(
                      width: 2.5.w,
                    ),
                    Text(
                      LocaleKeys.Secure_Payments.tr(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Row(
                  children: [
                    Image.asset(
                      'Icons/right.png',
                      height: 4.h,
                      color: color.primarycolor,
                    ),
                    SizedBox(
                      width: 2.5.w,
                    ),
                    Text(
                      LocaleKeys.No_Document_Upload_Required.tr(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Container(
          //   margin: EdgeInsets.only(
          //       top: 1.5.h, bottom: 1.5.h, left: 3.5.w, right: 3.5.w),
          //   child: Card(
          //     elevation: 5,
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(6),
          //         color:
          //             themenofier.isdark ? Colors.grey.shade800 : Colors.white,
          //       ),
          //       height: 43.h,
          //       width: double.infinity,
          //       child: Column(
          //         children: [
          //           Container(
          //             margin: EdgeInsets.only(top: 2.h),
          //             // color: color.redbutton,
          //             child: Image.asset(
          //               'Image/grocery.png',
          //               height: 12.h,
          //             ),
          //           ),
          //           Container(
          //             margin: EdgeInsets.only(
          //               top: 1.6.h,
          //             ),
          //             child: Text(
          //               LocaleKeys.Wallet_Money.tr(),
          //               style: TextStyle(
          //                 fontFamily: 'Poppins_semibold',
          //                 fontSize: 17.sp,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 4.5.w,
          //           ),
          //           Row(
          //             children: [
          //               Container(
          //                 margin: EdgeInsets.only(left: 3.5.w, right: 2.5.w),
          //                 child: Image.asset(
          //                   'Icons/right.png',
          //                   height: 4.h,
          //                 ),
          //               ),
          //               Text(
          //                 LocaleKeys.Fast_Easy_Payments.tr(),
          //                 style: TextStyle(
          //                   fontFamily: 'Poppins',
          //                   fontSize: 12.sp,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           SizedBox(
          //             height: MediaQuery.of(context).size.height / 50,
          //           ),
          //           Row(
          //             children: [
          //               Container(
          //                 margin: EdgeInsets.only(left: 3.5.w, right: 2.5.w),
          //                 child: Image.asset(
          //                   'Icons/right.png',
          //                   height: 4.h,
          //                 ),
          //               ),
          //               Text(
          //                 LocaleKeys.Secure_Payments.tr(),
          //                 style: TextStyle(
          //                   fontFamily: 'Poppins',
          //                   fontSize: 12.sp,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           SizedBox(
          //             height: MediaQuery.of(context).size.height / 50,
          //           ),
          //           Row(
          //             children: [
          //               Container(
          //                 margin: EdgeInsets.only(left: 3.5.w, right: 2.5.w),
          //                 child: Image.asset(
          //                   'Icons/right.png',
          //                   height: 4.h,
          //                 ),
          //               ),
          //               Text(
          //                 LocaleKeys.No_Document_Upload_Required.tr(),
          //                 style: TextStyle(
          //                   fontFamily: 'Poppins',
          //                   fontSize: 12.sp,
          //                 ),
          //               ),
          //             ],
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          // Text(
          //   LocaleKeys.Devbygravityinfo.tr(),
          //   style: TextStyle(fontFamily: 'Poppins', fontSize: 8.8.sp),
          // ),
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
                        LocaleKeys.Wallet_Money.tr(),
                        style: TextStyle(
                            fontFamily: 'Poppins_semibold',
                            fontSize: 15.sp,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 4.h,
                        left: 2.5.w,
                        right: 2.5.w,
                      ),
                      child: Text(
                        LocaleKeys.Total_Balance.tr(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 8.8.sp,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 1.h,
                        bottom: 1.5.h,
                        left: 2.5.w,
                        right: 2.5.w,
                      ),
                      child: Text(
                        // walletmoney.toString(),
                        currency_position == "1"
                            ? "$currency${numberFormat.format(double.parse(walletmoney.toString()))}"
                            : "${numberFormat.format(double.parse(
                                walletmoney.toString(),
                              ))}$currency",
                        style: TextStyle(
                            fontFamily: 'Poppins_bold',
                            fontSize: 12.5.sp,
                            color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 1.2.h,
                        left: 2.5.w,
                        right: 2.5.w,
                      ),
                      child: Text(
                        LocaleKeys.WALLET_MONEY_Can_only_be_used_for_your_orders
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
            ),
          ),
          TextButton(
            onPressed: () async {
              amount = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Addmoney()),
              );
              if (amount == null) {
                getdata();

                // setState(() async {
                //   SharedPreferences prefs =
                //       await SharedPreferences.getInstance();
                //   walletmoney = prefs.getString(UD_user_wallet);
                // });
              }
            },
            child: Text(
              LocaleKeys.ADD_MONEY.tr(),
              style: TextStyle(
                fontFamily: 'Poppins_semibold',
                fontSize: 11.sp,
                color: color.primarycolor,
              ),
            ),
          )
        ]),
      );
    });
  }
}
