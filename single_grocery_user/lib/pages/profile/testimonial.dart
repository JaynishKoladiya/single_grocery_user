// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, file_names, avoid_unnecessary_containers, non_constant_identifier_names,   use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/common%20class/allformater.dart';
import 'package:singlegrocery/model/settings/addratingmodel.dart';
import 'package:singlegrocery/model/settings/ratereviewmodel.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:singlegrocery/common%20class/height.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:singlegrocery/common%20class/color.dart';
import '../../theme/ThemeModel.dart';
import '../authentication/Login.dart';

class Ratingreview extends StatefulWidget {
  const Ratingreview({Key? key}) : super(key: key);

  @override
  State<Ratingreview> createState() => _RatingreviewState();
}

class _RatingreviewState extends State<Ratingreview> {
  String userid = "";
  Ratereviewmodel? finaldata;

  @override
  void initState() {
    super.initState();
    getstatus();
    reviewAPI();
  }

  getstatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = (prefs.getString(UD_user_id) ?? "null");
    });
  }

  Future reviewAPI() async {
    print("api called");
    var response = await Dio().get(DefaultApi.appUrl + GetAPI.rattinglist);
    print("finaldata=$response");
    var finallist = await response.data;
    print("finaldata=$finaldata");
    finaldata = Ratereviewmodel.fromJson(finallist);
    return finaldata;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ThemeModel themenofier, child) {
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
                      LocaleKeys.Testimonials.tr(),
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontFamily: 'Poppins_semibold', fontSize: 12.sp,
                        color: themenofier.isdark
                        ? Colors.white
                            : color.primarycolor,
                      ),
                    ),
                    leadingWidth: 40,
                    centerTitle: true,
                  ),
                  floatingActionButton: FloatingActionButton(
                      elevation: 0.0,
                      backgroundColor: color.primarycolor,
                      onPressed: () {
                        userid == "null"
                            ? Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (c) => Login()),
                                (r) => false)
                            : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Testimonioal()),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      )),
                  body: FutureBuilder(
                      future: reviewAPI(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                              itemBuilder: (context, index) =>
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 0.8.h, left: 4.w, right: 4.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    finaldata!
                                                        .data![index]
                                                        .profileImage
                                                        .toString()),
                                                backgroundColor: Colors.black12,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(finaldata!.data![index]
                                                      .name
                                                      .toString()),
                                                  SizedBox(
                                                    height: 4.sp,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      if (finaldata!
                                                          .data![index]
                                                          .ratting ==
                                                          "1") ...[
                                                        Image.asset(
                                                          "Image/ratting1.png",
                                                          color: color.yellow,
                                                          width: 25.w,
                                                        )
                                                      ] else
                                                        if (finaldata!
                                                            .data![index]
                                                            .ratting ==
                                                            "2") ...[
                                                          Image.asset(
                                                            "Image/ratting2.png",
                                                            color: color.yellow,
                                                            width: 25.w,
                                                          )
                                                        ] else
                                                          if (finaldata!
                                                              .data![index]
                                                              .ratting ==
                                                              "3") ...[
                                                            Image.asset(
                                                              "Image/ratting3.png",
                                                              color: color
                                                                  .yellow,
                                                              width: 25.w,
                                                            )
                                                          ] else
                                                            if (finaldata!
                                                                .data![index]
                                                                .ratting ==
                                                                "4") ...[
                                                              Image.asset(
                                                                "Image/ratting4.png",
                                                                color: color
                                                                    .yellow,
                                                                // color: Colors.white,
                                                                width: 25.w,
                                                              )
                                                            ] else
                                                              if (finaldata!
                                                                  .data![index]
                                                                  .ratting ==
                                                                  "5") ...[
                                                                Image.asset(
                                                                  "Image/ratting5.png",
                                                                  color: color
                                                                      .yellow,
                                                                  width: 25.w,
                                                                )
                                                              ],
                                                      SizedBox(
                                                        width: 32.w,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          FormatedDate(
                                                              finaldata!
                                                                  .data![index]
                                                                  .date
                                                                  .toString()),
                                                          style: TextStyle(
                                                            fontSize: 9.sp,
                                                            fontFamily: 'Poppins',
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.1.h,
                                        ),
                                        Text(
                                          finaldata!.data![index].comment
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.grey,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 1.5.h,
                                        ),
                                      ],
                                    ),
                                  ),
                              separatorBuilder: (context, index) =>
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 0.5.h, left: 2.5.w, right: 2.5
                                        .w),
                                    height: 0.8.sp,
                                    color: Colors.grey,
                                  ),
                              itemCount: finaldata!.data!.length);
                        }
                        return Center(
                          child: Text(" No Reviews Found"),
                        );
                      })));

        });
  }
}

class Testimonioal extends StatefulWidget {
  const Testimonioal({Key? key}) : super(key: key);

  @override
  State<Testimonioal> createState() => _TestimonioalState();
}

class _TestimonioalState extends State<Testimonioal> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final Comment = TextEditingController();
  String userid = "";
  int? rating;
  addratingmodel? finallist;

  addraring() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = (prefs.getString(UD_user_id) ?? "null");
    });
    try {
      loader.showLoading();
      // loader.showLoading();
      var map = {
        "user_id": userid,
        "comment": Comment.text.toString(),
        "ratting": rating.toString(),
      };

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.addrating, data: map);
      finallist = addratingmodel.fromJson(response.data);

      print("finallist=$finallist");
      if (finallist!.status == 1) {
        loader.hideLoading();
        Comment.clear();
        Navigator.of(context).pop();
        loader.showErroDialog(description: finallist!.message);
      } else {
        Navigator.of(context).pop();
        loader.showErroDialog(description: finallist!.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer(builder: (context, ThemeModel themenofier, child) {
        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 6.h, bottom: 5.h),
              child: Text(LocaleKeys.Add_Testimonial.tr(),
                  style:
                  TextStyle(color: themenofier.isdark
                      ? Colors.white
                      : color.primarycolor,fontSize: 17.sp, fontFamily: 'Poppins_semibold')),
            ),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 60,
              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: color.yellow,
              ),
              onRatingUpdate: (Value) {
                setState(() {
                  rating = Value.toInt();
                });
              },
            ),
            SizedBox(
              height: 40,
            ),
            Form(
              key: _formkey,
              child: Container(
                margin: EdgeInsets.only(
                  top: 0.8.h,
                  left: 3.5.w,
                  right: 3.5.w,
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: Comment,
                  maxLines: 10,
                  cursorColor: Colors.grey,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      hintText: LocaleKeys.Enteryoureview.tr(),
                      hintStyle:
                      TextStyle(fontSize: 11.sp, fontFamily: "Poppins"),
                      enabledBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color:color.primarycolor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color:color.primarycolor),
                      )),
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              height: 15,
            )
          ],
        );
      },),
      bottomSheet: Consumer(builder: (context, ThemeModel themenofier, child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                // margin: EdgeInsets.only(
                //   left: 1.6.w,
                //   right: 1.6.w,
                //   bottom: 1.5.h,
                // ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: color.red,
                  ),
                ),
                height: 6.5.h,
                width: 47.w,
                child: TextButton(
                  child: Text(
                    LocaleKeys.Cancel.tr(),
                    style: TextStyle(
                        fontFamily: 'Poppins_medium',
                        color: color.red,
                        fontSize: fontsize.Buttonfontsize),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                // margin: EdgeInsets.only(
                //   right: 1.6.w,
                //   left: 1.6.w,
                //   bottom: 1.5.h,
                // ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 6.5.h,
                width: 47.w,
                child: TextButton(
                  onPressed: () {
                    if (Comment.text.isEmpty) {
                      loader.showErroDialog(
                        description: LocaleKeys.Please_enter_all_details.tr(),
                      );
                    } else {
                      addraring();
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:themenofier.isdark
                        ? Colors.white
                        : color.primarycolor,
                  ),
                  child: Text(
                    LocaleKeys.Submit.tr(),
                    style: TextStyle(
                        fontFamily: 'Poppins_medium',
                        color: Colors.white,
                        fontSize: fontsize.Buttonfontsize),
                  ),
                ),
              ),
            ],
          ),
        );
      },),
    ));
  }
}
