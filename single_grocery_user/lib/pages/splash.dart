import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:sizer/sizer.dart';

import '../theme/ThemeModel.dart';
import 'Home/Homepage.dart';

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage(0),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ThemeModel themenofier, child) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                color: themenofier.isdark ? Colors.black : color.primarycolor,
                child: Center(
                child: Image.asset("Icons/logo-white.png",height: 50.h,width: 50
                .w,),
            ),
          ))
          );
        });
  }
}
