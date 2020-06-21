import 'package:flutter/material.dart';

class ResumeWriteModel {
  final String writer_id;
  final String writer_name;
  final String contact_number;
  final String email;
  final String discounts;
  ResumeWriteModel({this.writer_id,this.writer_name,this.contact_number, this.email, this.discounts});
  factory ResumeWriteModel.fromJson(Map<String, dynamic> json) {
    return ResumeWriteModel(
      writer_id: json['writer_id'],
      writer_name: json['writer_name'],
      contact_number: json['contact_number'],
      email: json['email'],
      discounts: json['discounts'],
    );
  }
}