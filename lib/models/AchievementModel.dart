import 'package:flutter/material.dart';

class AchievementModel {
  final int id;
  final String name;
  final String description;
  final String category;
  AchievementModel({this.id,this.name,this.description, this.category});
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
    );
  }
}