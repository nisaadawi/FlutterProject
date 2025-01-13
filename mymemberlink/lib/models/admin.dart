class Admin {
  String? adminid;
  String? adminname;
  String? adminemail;
  String? adminphone; 
  String? admindob;
  String? adminaddress;
  String? adminpassword;
  String? membertype;
  String? admindatereg;

  Admin({
    this.adminid,
    this.adminname,
    this.adminemail,
    this.adminphone,
    this.admindob,
    this.adminaddress,
    this.adminpassword,
    this.membertype,
    this.admindatereg,
  });

  Admin.fromJson(Map<String, dynamic> json) {
    adminid = json['admin_id']?.toString();
    adminname = json['admin_name'];
    adminemail = json['admin_email'];
    adminphone = json['admin_phone']?.toString(); 
    admindob = json['admin_dob'];
    adminaddress = json['admin_address'];
    adminpassword = json['admin_pass'];
    membertype = json['member_type'];
    admindatereg = json['admin_datereg'];
  }

  Map<String, dynamic> toJson() {
    return{
      'admin_id': adminid,
      'admin_name': adminname,
      'admin_email': adminemail,
      'admin_phone': adminphone,
      'admin_dob': admindob,
      'admin_address': adminaddress,
      'admin_password': adminpassword,
      'member_type': membertype,
      'admin_datereg': admindatereg,
    };
}
}
