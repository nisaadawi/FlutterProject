class MyMembership {
  String? membershipId;
  String? membershipName;
  String? description;
  double? price;
  String? benefits;
  String? terms;
  String? duration;
  String? membershipFileName;

  // Constructor
  MyMembership({
    this.membershipId,
    this.membershipName,
    this.description,
    this.price,
    this.benefits,
    this.terms,
    this.duration,
    this.membershipFileName
  });

  // From JSON
  MyMembership.fromJson(Map<String, dynamic> json) {
    membershipId = json['membership_id'];
    membershipName = json['membership_name'];
    description = json['description'];
    price = json['price'] != null
        ? double.tryParse(json['price'].toString())
        : null;
    benefits = json['benefits'];
    terms = json['terms'];
    duration = json['duration'];
    membershipFileName = json['membership_filename'];

  }

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['membership_id'] = membershipId;
    data['membership_name'] = membershipName;
    data['description'] = description;
    data['price'] = price?.toString(); 
    data['benefits'] = benefits;
    data['terms'] = terms;
    data['duration'] = duration;
    data['membership_filename'] = membershipFileName;
    return data;
  }
}
