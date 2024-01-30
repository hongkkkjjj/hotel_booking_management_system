class UserData {
  String username;
  String mobileNo;
  bool isAdmin = false;
  String email;

  UserData(this.username, this.mobileNo, this.isAdmin, this.email);

  Map<String, dynamic> toMap() {
    return {
      'is_admin': isAdmin,
      'name': username,
      'mobile_no': mobileNo,
      'email': email,
    };
  }
}