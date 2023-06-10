// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:singlegrocery/common%20class/color.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:singlegrocery/model/settings/privacymodel.dart';
import 'package:singlegrocery/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class teamscondition extends StatefulWidget {
  const teamscondition({Key? key}) : super(key: key);

  @override
  State<teamscondition> createState() => _teamsconditionState();
}

class _teamsconditionState extends State<teamscondition> {
  cmsMODEL? data;
  String? htmlcode;

  teamsAPI() async {
    try {
      var response = await Dio().get(DefaultApi.appUrl + GetAPI.cmspages);
      data = cmsMODEL.fromJson(response.data);
      htmlcode = data!.termscondition;

      return data;
    } catch (e) {
      rethrow;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = WebViewController()
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
      ..loadRequest(Uri.dataFromString(htmlcode!,
          mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
  }

  @override
  Widget build(BuildContext context) {
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
          LocaleKeys.TeamsConditions.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins_semibold', fontSize: 12.sp),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: teamsAPI(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: color.primarycolor,
                ),
              );
            }
            return WebViewWidget(controller: _controller);
          }),
    ));
  }

  // _loadHtmlFromAssets() async {
  //   // String fileText = await rootBundle.loadString('help.html');
  //   _controller.loadUrl(Uri.dataFromString(htmlcode!,
  //           mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //       .toString());
  // }

  late WebViewController _controller;
}
