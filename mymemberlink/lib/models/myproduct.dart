class MyProduct {
  String? productId;
  String? productName;
  String? productDescription;
  double? productPrice; 
  int? productQuantity; 
  String? productFilename;
  String? productDate;

  MyProduct(
      {this.productId,
      this.productName,
      this.productDescription,
      this.productPrice,
      this.productQuantity,
      this.productFilename,
      this.productDate});

  MyProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productPrice = json['product_price'] != null
        ? double.tryParse(json['product_price'].toString())
        : null; // Parse as double
    productQuantity = json['product_quantity'] != null
        ? int.tryParse(json['product_quantity'].toString())
        : null; // Parse as int
    productFilename = json['product_filename'];
    productDate = json['product_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_description'] = productDescription;
    data['product_price'] = productPrice?.toString(); 
    data['product_quantity'] = productQuantity?.toString(); 
    data['product_filename'] = productFilename;
    data['product_date'] = productDate;
    return data;
  }
}
