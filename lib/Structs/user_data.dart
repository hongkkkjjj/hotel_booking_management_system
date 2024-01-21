class UserData {
  String username;
  String mobileNo;
  bool isAdmin = false;

  UserData(this.username, this.mobileNo, this.isAdmin);

  Map<String, dynamic> toMap() {
    return {
      'is_admin': isAdmin,
      'name': username,
      'mobile_no': mobileNo,
    };
  }
}