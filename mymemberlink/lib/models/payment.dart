class MyProduct {
  String? paymentId;
  String? billplzId;
  String? adminEmail;
  String? adminPhone;
  String? adminName;
  double? price; 
  String? membershipName;
  String? paymentStatus;
  String? datePurchased;

  MyProduct(
      {this.paymentId,
      this.billplzId,
      this.adminEmail,
      this.adminPhone,
      this.adminName,
      this.price,
      this.membershipName,
      this.paymentStatus,
      this.datePurchased});

  MyProduct.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    billplzId = json['billplz_id'];
    adminEmail = json['admin_email'];
    adminPhone = json['amdin_phone']?.toString();
    adminName = json['admin_name'];
    price = json['price'] != null ? 
            double.tryParse(json['price'].toString()) 
            : null;
    membershipName = json['membership_name'];
    paymentStatus = json['payment_status'];
    datePurchased = json['date_purchased'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_id'] = paymentId;
    data['billplz_id'] = billplzId;
    data['admin_email'] = adminEmail;
    data['admin_phone'] = adminPhone;
    data['admin_name'] = adminName;
    data['price'] = price?.toString();
    data['membership_name'] = membershipName;
    data['payment_status'] = paymentStatus;
    data['date_purchased'] = datePurchased;
    return data;
  }
}
