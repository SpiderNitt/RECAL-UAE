import 'package:flutter/material.dart';

class User {
  final String email;
  final String password;
  final String name;
  final int user_id;
  User({this.name,this.email,this.password, this.user_id});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      user_id: json['user_id'],
    );
  }
}