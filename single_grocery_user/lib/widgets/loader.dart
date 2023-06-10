// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';

class loader {
  // show error; Dialog
  static void showErroDialog({String? description = 'Something went wrong'}) {
    Get.dialog(
      AlertDialog(
        title: Text(
          LocaleKeys.Single_Grocery.tr(),
          style: TextStyle(fontSize: 14.sp, fontFamily: 'Poppins_semibold',color: color.primarycolor),
        ),
        content: Text(
          description ?? '',
          style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppins'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (Get.isDialogOpen!) Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color.primarycolor,
            ),
            child: Text(
              LocaleKeys.Ok.tr(),
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showLoading([String? message]) {
    Get.dialog(
      barrierDismissible: false,
      // useSafeArea: true,
      barrierColor: Colors.transparent,
      Center(
        child: CircularProgressIndicator(
          color: color.primarycolor,
        ),
      ),
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }
}
