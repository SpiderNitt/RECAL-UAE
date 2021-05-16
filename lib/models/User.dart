import 'package:shared_preferences/shared_preferences.dart';

class User {
  String email;
  String password;
  String name;
  int user_id;
  String cookie;
  int year_of_graduation;
  String mobile_no;
  String organization;
  String position;
  String gender;
  bool is_registered;
  String linkedIn_link;
  String branch;
  String emirate;
  bool loggedIn;
  String profile_pic;

  User(
      {this.email,
      this.password,
      this.name,
      this.user_id,
      this.cookie,
      this.year_of_graduation,
      this.mobile_no,
      this.organization,
      this.position,
      this.gender,
      this.is_registered,
      this.linkedIn_link,
      this.branch,
      this.emirate,
      this.loggedIn,
      this.profile_pic});

  saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Login email before:  ${prefs.getString("email")}");
    print("Login name before:  ${prefs.getString("name")}");
    prefs.setString("email", email);
    prefs.setString("name", name);
    prefs.setString("user_id", user_id.toString());
    prefs.setString("cookie", cookie);
    print("cookie: " + cookie);
    print("login after name ${prefs.getString("name")}");
  }

  Future<User> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.name =
        prefs.getString("name") == null ? "+9,q" : prefs.getString("name");
    this.email =
        prefs.getString("email") == null ? "+9,q" : prefs.getString("email");
    this.cookie =
        prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");
    this.user_id = prefs.getString("user_id") == null
        ? -1
        : int.parse(prefs.getString("user_id"));
    return this;
  }

  factory User.fromLogin(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      user_id: json['user_id'],
    );
  }

  factory User.fromStorage(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      cookie: json['cookie'],
    );
  }

  factory User.fromCheckLogin(Map<String, dynamic> json) {
    return User(
      loggedIn: json['loggedIn'],
    );
  }

  factory User.fromNormal(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }

  factory User.fromProfile(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      year_of_graduation: json['year_of_graduation'],
      mobile_no: json['mobile_no'],
      organization: json['organization'],
      position: json['position'],
      gender: json['gender'],
      is_registered: json['is_registered'],
      linkedIn_link: json['linkedIn_link'],
      branch: json['branch'],
      emirate: json['emirate'],
      profile_pic: json['profile_pic'],
    );
  }
}
