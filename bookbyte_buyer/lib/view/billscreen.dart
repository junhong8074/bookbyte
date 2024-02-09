//import 'dart:async';
import 'package:bookbyte_buyer/model/user.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillScreen extends StatefulWidget {
  final User user;
  final double totalprice;

  const BillScreen({super.key, required this.user, required this.totalprice});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  var loadingPercentage = 0;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    print('https://junhong.infinitebe.com/bookbyte_buyer/php/payment.php?&userid=${widget.user.userid}&email=${widget.user.useremail}&&name=${widget.user.username}&amount=${widget.totalprice.toStringAsFixed(2)}');
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
            'https://junhong.infinitebe.com/bookbyte_buyer/php/payment.php?&userid=${widget.user.userid}&email=${widget.user.useremail}&&name=${widget.user.username}&amount=${widget.totalprice.toStringAsFixed(2)}'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}