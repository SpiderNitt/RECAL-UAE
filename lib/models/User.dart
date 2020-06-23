import 'package:flutter/material.dart';

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
  String profile_pic;

  User({this.email, this.password, this.name, this.user_id, this.cookie, this.year_of_graduation, this.mobile_no, this.organization, this.position, this.gender, this.is_registered, this.linkedIn_link, this.branch, this.emirate, this.profile_pic});
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
      year_of_graduation : json['year_of_graduation'],
      mobile_no : json['mobile_no'],
      organization : json['organization'] ,
      position : json['position'],
      gender: json['gender'],
      is_registered: json['is_registered'],
      linkedIn_link: json['linkedIn_link'],
      branch: json['branch'],
      emirate: json['emirate'],
      profile_pic: json['profile_pic'],
    );
  }
}