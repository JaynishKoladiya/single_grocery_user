// ignore_for_file: must_be_immutable, camel_case_types, non_constant_identifier_names, use_key_in_widget_constructors,   prefer_const_constructors, use_build_context_synchronously, empty_catches

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlegrocery/model/cart/orderplaceMODEL.dart';
import 'package:singlegrocery/widgets/loader.dart';
import 'package:singlegrocery/common%20class/prefs_name.dart';
import 'package:singlegrocery/config/api/API.dart';
import 'package:singlegrocery/pages/cart/ordersucess.dart';

class orderrazorpay extends StatefulWidget {
  //order
  String? ordertotal;
  String? ordertype;
  String? offercode;
  String? discountamount;
  String? taxamount;
  String? delivery_charge;
  // address
  String? addresstype;
  String? address;
  String? area;
  String? houseno;
  String? lang;
  String? lat;
  //extra
  String? ordernote;
  //key

  String? publickey;
  String? secretkey;
  // String? livepublic;
  // String? livesecret;
  String? currency;

  // const orderrazorpay({Key? key}) : super(key: key);

  @override
  State<orderrazorpay> createState() => _orderrazorpayState();
  orderrazorpay([
    //order
    this.ordertotal,
    this.ordertype,
    this.offercode,
    this.discountamount,
    this.taxamount,
    this.delivery_charge,
    //address
    this.addresstype,
    this.address,
    this.area,
    this.houseno,
    this.lang,
    this.lat,
    // extra
    this.ordernote,
    //key
    this.publickey,
    this.secretkey,
    this.currency,
  ]);
}

class _orderrazorpayState extends State<orderrazorpay> {
  String? payment_id;
  String? pay_message;
  late Razorpay razorpay;
  String? userid;
  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    openchekout();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    payment_id = response.paymentId;
    pay_message = "success"; // Do

    placeorderAPI(); // something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.back();
    print('Error Response: ${response.message}');
    // loader.showErroDialog(description: "payment failed");
    //  Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {

    // loader.showErroDialog(description: response.toString());
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  openchekout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(UD_user_id);
    var options = {
      'key': "rzp_test_4r8y0wDMkrUDFn",
      // 'key': widget.publickey,
      'amount': (double.parse(widget.ordertotal!) * 100).toInt(),
      'currency': widget.currency,
      'name': prefs.getString(UD_user_name),
      'description': "Service Provider",
      'prefill': {
        'contact': prefs.getString(UD_user_mobile),
        'email': prefs.getString(UD_user_email),
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  placeorderAPI() async {
    loader.showLoading();
    var map = {
      "user_id": userid,
      "grand_total": widget.ordertotal,
      "transaction_type": "3",
      "transaction_id": payment_id,
      "order_type": widget.ordertype,
      "address_type": widget.addresstype,
      "address": widget.address,
      "area": widget.area,
      "house_no": widget.houseno,
      "lang": widget.lang,
      "lat": widget.lat,
      "offer_code": widget.offercode == "0" ? "" : widget.offercode,
      "discount_amount": widget.discountamount,
      "tax_amount": double.parse(widget.taxamount.toString()),
      "delivery_charge": widget.delivery_charge,
      "order_notes": widget.ordernote,
      "order_from": "flutter",
      "card_number": "",
      "card_exp_month": "",
      "card_exp_year": "",
      "card_cvc": ""
    };
    print("response=$map");

    var response = await Dio().post(DefaultApi.appUrl + PostAPI.Order, data: map);
    print("response====${response}");
    orderplaceMODEL placedorederdata = orderplaceMODEL.fromJson(response.data);

    loader.hideLoading();
    if (placedorederdata.status == 1) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Ordersucesspage()));
    } else {
      int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold());
  }
}
