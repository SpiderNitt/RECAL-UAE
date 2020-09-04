import 'package:flutter/material.dart';

class PositionModel {
  final int position_id;
  final String company;
  final String placed;
  final String author;
  final String position;
  final String description;
  final String contact;
  final String open_until;
  PositionModel({this.position_id,this.company,this.placed, this.author, this.position, this.description, this.contact, this.open_until});
  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      position_id: json['position_id'],
      company: json['company'],
      placed: json['placed'],
      author: json['author'],
      position: json['position'],
      description: json['description'],
      contact: json['contact'],
      open_until: json['open_until'],
    );
  }
}