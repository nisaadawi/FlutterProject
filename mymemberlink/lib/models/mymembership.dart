class MyMembership {
  String? membershipId;
  String? membershipName;
  double? price;
  String? description;
  String? benefits;
  String? terms;
  String? duration;

  MyMembership({
    this.membershipId,
    this.membershipName,
    this.price,
    this.description,
    this.benefits,
    this.terms,
    this.duration,
  });

  MyMembership.fromJson(Map<String, dynamic> json) {
    try {
      membershipId = json['membership_id']?.toString();
      membershipName = json['membership_name'];
      price = json['price'] != null ? double.parse(json['price'].toString()) : null;
      description = json['description'];
      benefits = json['benefits'];
      terms = json['terms'];
      duration = json['duration'];
    } catch (e) {
      print('Error parsing MyMembership: $e'); // Debug print
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['membership_id'] = membershipId;
    data['membership_name'] = membershipName;
    data['price'] = price;
    data['description'] = description;
    data['benefits'] = benefits;
    data['terms'] = terms;
    data['duration'] = duration;
    return data;
  }
}
