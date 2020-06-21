import 'package:flutter/material.dart';

class ResponseBody {
  final int status_code;
  final data;

  ResponseBody({this.status_code,this.data});
  factory ResponseBody.fromJson(Map<String, dynamic> json) {
    return ResponseBody(
      status_code: json['status_code'],
      data: json['data'],
    );
  }
}