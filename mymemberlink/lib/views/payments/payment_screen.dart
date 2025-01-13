import 'package:flutter/material.dart';
import 'package:mymemberlink/models/mymembership.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final MyMembership myMembership;

  const PaymentScreen({super.key, required this.myMembership});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController wvcontroller;

  @override
  void initState() {
    super.initState();
   // String price = widget.myMembership.price.toString();
    wvcontroller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onHttpError: (HttpResponseError error) {},
      onWebResourceError: (WebResourceError error) {},
    ),
  )
  ..loadRequest(Uri.parse('https://www.uum.edu.my'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: wvcontroller,
      )
    );
  }
}