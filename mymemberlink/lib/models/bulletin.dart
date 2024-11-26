class Bulletin {
  String? bulletinId;
  String? bulletinTitle;
  String? bulletinDetails;
  String? bulletinDate;
  late bool isEdited;

  Bulletin(
      {this.bulletinId,
      this.bulletinTitle,
      this.bulletinDetails,
      this.bulletinDate,
      this.isEdited = false});

  factory Bulletin.fromJson(Map<String, dynamic> json) {
  return Bulletin(
    bulletinId: json['bulletin_id'],
    bulletinTitle: json['bulletin_title'],
    bulletinDetails: json['bulletin_details'],
    bulletinDate: json['bulletin_date'],
    // Ensure the 'isEdited' field is properly parsed as an integer and converted to a boolean
    isEdited: int.parse(json['isEdited'].toString()) == 1,  // Converts 1 to true, 0 to false
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bulletin_id'] = bulletinId;
    data['bulletin_title'] = bulletinTitle;
    data['bulletin_details'] = bulletinDetails;
    data['bulletin_date'] = bulletinDate;
    data['isEdited'] = isEdited ? 1 : 0;
    return data;
  }
}
