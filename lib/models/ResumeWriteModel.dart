import 'package:flutter/material.dart';

class ResumeWriteModel {
  final int writer_id;
  final String writer_name;
  final String contact_number;
  final String email;
  final String discounts;
  final String link;
  ResumeWriteModel({this.writer_id,this.writer_name,this.contact_number, this.email, this.discounts, this.link});
  factory ResumeWriteModel.fromJson(Map<String, dynamic> json) {
    return ResumeWriteModel(
      writer_id: json['writer_id'],
      writer_name: json['writer_name'],
      contact_number: json['contact_number'],
      email: json['email'],
      discounts: json['discounts'],
      link: json['link'],
    );
  }
}