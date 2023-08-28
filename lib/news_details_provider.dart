import 'package:flutter/material.dart';

class NewsDetailProvider extends ChangeNotifier {
  String img = '';
  String description = '';
  String author = '';
  String title = '';

  void setDetails({
    required String img,
    required String description,
    required String author,
    required String title,
  }) {
    this.img = img;
    this.description = description;
    this.author = author;
    this.title = title;
    notifyListeners();
  }
}