// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:singlegrocery/model/settings/privacymodel.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/ThemeModel.dart';

class Privacypolicy extends StatefulWidget {
  const Privacypolicy({Key? key}) : super(key: key);

  @override
  State<Privacypolicy> createState() => _PrivacypolicyState();
}

class _PrivacypolicyState extends State<Privacypolicy> {
  String privacycode = "";
  cmsMODEL? privacydata;
  PrivacyAPI() async {
    var response = await Dio().get(DefaultApi.appUrl + GetAPI.cmspages);
    privacydata = cmsMODEL.fromJson(response.data);
    privacycode = privacydata!.privacypolicy!;
    return cmsMODEL();
  }

  late WebViewController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.dataFromString(privacycode,
          mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
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
                        Navigator.pop(
                          context,
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 20,
                      )),
                  title: Text(
                    LocaleKeys.Privacy_Policy.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Poppins_semibold', fontSize: 12.sp,
                      color: themenofier.isdark
                          ? Colors.white
                          : color.primarycolor,),
                  ),
                  centerTitle: true,
                ),
                body: FutureBuilder(
                  future: PrivacyAPI(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: color.primarycolor,
                        ),
                      );
                    }
                    return WebViewWidget(controller: controller);
                  },
                ),
              ));
        });
  }

  // _loadHtmlFromAssets() async {
  //   _controller.loadUrl(Uri.dataFromString(privacycode,
  //           mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //       .toString());
  // }
}
