import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mymemberlink/models/admin.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:mymemberlink/views/shared/drawer_main_screen.dart';

class PaymentHistory extends StatefulWidget {
  final Admin admin;
  const PaymentHistory({super.key, required this.admin});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  late double screenWidth, screenHeight;
  List<Map<String, dynamic>> paymentList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPaymentHistory();
  }

  Future<void> loadPaymentHistory() async {
    try {
      final response = await http.get(
        Uri.parse('${MyConfig.servername}/memberlink/api/load_payment_history.php?admin_email=${widget.admin.adminemail}'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {
            paymentList = List<Map<String, dynamic>>.from(jsonResponse['data']);
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load payment history');
        }
      } else {
        throw Exception('Server error');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final appBarHeight = isPortrait ? 145.0 : 90.0;

    return Scaffold(
      drawer: MainScreenDrawer(admin: widget.admin),
      appBar: AppBar(
        title: Text(
          "Payment History",
          style: GoogleFonts.lexendTera(
            color: const Color.fromARGB(252, 255, 255, 255),
            fontSize: 25.5,
            fontWeight: FontWeight.bold,
            shadows: [
              const Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
                color: Color.fromARGB(128, 65, 3, 87),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              loadPaymentHistory();
            },
            icon: const Icon(
              Icons.refresh_outlined,
              color: Colors.white,
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg/memberships.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
        ),
        toolbarHeight: appBarHeight,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(219, 255, 255, 255),
              Color.fromARGB(219, 214, 178, 241),
              Color.fromARGB(255, 80, 17, 148),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : paymentList.isEmpty
                ? Center(
                    child: Text(
                      'No payment history found',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: paymentList.length,
                    itemBuilder: (context, index) {
                      final payment = paymentList[index];
                      final date = DateFormat('dd/MM/yyyy HH:mm')
                          .format(DateTime.parse(payment['date_purchased']));
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                payment['membership_name'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 80, 17, 148),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'RM ${payment['price']}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'Receipt ID: ${payment['billplz_id']}',
                                style: GoogleFonts.montserrat(fontSize: 14),
                              ),
                              Text(
                                'Date: $date',
                                style: GoogleFonts.montserrat(fontSize: 14),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: payment['payment_status'] == 'Success'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              payment['payment_status'],
                              style: TextStyle(
                                color: payment['payment_status'] == 'Success'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}