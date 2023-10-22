class UserEmail {
  String email;

  UserEmail._internal(this.email);

  factory UserEmail() {
    return _globalUser;
  }

  static final UserEmail _globalUser = UserEmail._internal("");

  void setUserEmail(String newEmail) {
    _globalUser.email = newEmail;
  }
}
