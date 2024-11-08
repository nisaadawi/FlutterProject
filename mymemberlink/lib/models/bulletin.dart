class Bulletin {
  String? bulletinId;
  String? bulletinTitle;
  String? bulletinDetails;
  String? bulletinDate;

  Bulletin(
      {this.bulletinId,
      this.bulletinTitle,
      this.bulletinDetails,
      this.bulletinDate});

  Bulletin.fromJson(Map<String, dynamic> json) {
    bulletinId = json['bulletin_id'];
    bulletinTitle = json['bulletin_title'];
    bulletinDetails = json['bulletin_details'];
    bulletinDate = json['bulletin_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bulletin_id'] = bulletinId;
    data['bulletin_title'] = bulletinTitle;
    data['bulletin_details'] = bulletinDetails;
    data['bulletin_date'] = bulletinDate;
    return data;
  }
}