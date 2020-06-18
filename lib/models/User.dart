import 'package:flutter/material.dart';

class User {
  final String email;
  final String password;
  final String name;
  User({this.name,this.email,this.password});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }
}