import 'package:flutter/material.dart';
import 'package:mymemberlink/models/admin.dart';
import 'package:mymemberlink/models/mymembership.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final Admin admin;
  final MyMembership myMembership;

  const PaymentScreen({super.key, required this.myMembership, required this.admin});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController wvcontroller;

  @override
  void initState() {
    super.initState();
    String email = widget.admin.adminemail ?? '';
    String phone = widget.admin.adminphone ?? '';
    String name = widget.admin.adminname ?? '';
    String price = widget.myMembership.price?.toString() ?? '0';
    String member_type = widget.myMembership.membershipName ?? '';
    
    // Debug prints
    print('Payment Details:');
    print('Email: $email');
    print('Phone: $phone');
    print('Name: $name');
    print('Price: $price');
    print('Membership Type: $member_type');

    final Uri url = Uri.https(
      'humancc.site',
      '/ndhos/memberlink/api/payment.php',
      {
        'admin_email': email,
        'admin_phone': phone,
        'admin_name': name,
        'price': price,
        'member_type': member_type,
      },
    );

    print('Payment URL: ${url.toString()}'); // Debug print

    wvcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('Loading: $progress%');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Web Resource Error:');
            print('Error Code: ${error.errorCode}');
            print('Error Description: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation request to: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: wvcontroller,
          ),
          // You can add a loading indicator here
        ],
      ),
    );
  }
}