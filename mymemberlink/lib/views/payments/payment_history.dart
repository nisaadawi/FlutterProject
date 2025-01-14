import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mymemberlink/models/admin.dart';
import 'package:mymemberlink/models/payment.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:mymemberlink/views/shared/drawer_main_screen.dart';
import 'package:mymemberlink/views/payments/receipt_screen.dart';

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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadPaymentHistory();
    // Check every 30 seconds instead of every minute
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        loadPaymentHistory();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showFailureDialog(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final date = DateFormat('dd/MM/yyyy HH:mm')
            .format(DateTime.parse(payment['date_purchased']));

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.red[700],
              ),
              const SizedBox(height: 10),
              Text(
                'Payment Failed',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Membership', payment['membership_name']),
              _buildInfoRow('Amount', 'RM ${payment['price']}'),
              _buildInfoRow('Date', date),
              _buildInfoRow('Receipt ID', payment['billplz_id']),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red[700], size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This payment was unsuccessful. Please try making the payment again.',
                        style: GoogleFonts.montserrat(
                          color: Colors.red[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.montserrat(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(' : '),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final appBarHeight = isPortrait ? 145.0 : 90.0;

    return Scaffold(
      drawer: MainScreenDrawer(admin: widget.admin),
      appBar: AppBar(
        title: Text(
          "Pay. History",
          style: GoogleFonts.lexendTera(
            color: const Color.fromARGB(252, 255, 255, 255),
            fontSize: 26.5,
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
                    padding: const EdgeInsets.all(5),
                    itemCount: paymentList.length,
                    itemBuilder: (context, index) {
                      final payment = paymentList[index];
                      final date = DateFormat('dd/MM/yyyy HH:mm')
                          .format(DateTime.parse(payment['date_purchased']));
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (payment['payment_status'] == 'Failed') {
                              _showFailureDialog(payment);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReceiptScreen(
                                    billplzId: payment['billplz_id'],
                                  ),
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: payment['payment_status'] == 'Success'
                                    ? [Colors.white, Colors.green.shade50]
                                    : payment['payment_status'] == 'Pending'
                                        ? [Colors.white, Colors.orange.shade50]
                                        : [Colors.white, Colors.red.shade50],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      payment['membership_name'],
                                      style: GoogleFonts.montserrat(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 80, 17, 148),
                                      ),
                                    ),
                                    _buildStatusBadge(
                                      payment['payment_status'],
                                      payment['date_purchased'],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'RM ${payment['price']}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Receipt ID: ${payment['billplz_id']}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      date,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Future<void> loadPaymentHistory() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${MyConfig.servername}/memberlink/api/load_payment_history.php?admin_email=${widget.admin.adminemail}'),
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

  Future<void> _updatePendingPayments() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${MyConfig.servername}/memberlink/api/update_pending_payments.php'),
      );
      if (response.statusCode == 200) {
        loadPaymentHistory(); // Reload the list after updating
      }
    } catch (e) {
      print('Error updating pending payments: $e');
    }
  }

  Color _getStatusColor(String status, String datePurchased) {
    if (status == 'Pending') {
      final purchaseTime =
          DateTime.parse(datePurchased).toLocal(); // Convert to local time
      final currentTime = DateTime.now();
      final difference = currentTime.difference(purchaseTime);

      print('Purchase Time: $purchaseTime'); // Debug print
      print('Current Time: $currentTime'); // Debug print
      print('Difference in minutes: ${difference.inMinutes}'); // Debug print

      if (difference.inMinutes >= 5) {
        return Colors.red; // Failed color
      }
      return Colors.orange; // Pending color
    }

    switch (status) {
      case 'Success':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.yellow;
    }
  }

  Widget _buildStatusBadge(String status, String datePurchased) {
    final color = _getStatusColor(status, datePurchased);
    String displayStatus = status;

    if (status == 'Pending') {
      final purchaseTime = DateTime.parse(datePurchased).toLocal();
      final currentTime = DateTime.now();
      final difference = currentTime.difference(purchaseTime);

      if (difference.inMinutes >= 5) {
        displayStatus = 'Failed';
        // Update the status in the database
        _updatePaymentStatus(datePurchased);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // Add this new method to update payment status
  Future<void> _updatePaymentStatus(String datePurchased) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${MyConfig.servername}/memberlink/api/update_pending_payments.php'),
        body: {
          'date_purchased': datePurchased,
          'admin_email': widget.admin.adminemail,
        },
      );

      if (response.statusCode == 200) {
        loadPaymentHistory(); // Reload the list after updating
      }
    } catch (e) {
      print('Error updating payment status: $e');
    }
  }
}
