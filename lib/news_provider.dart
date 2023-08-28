import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsProvider extends ChangeNotifier {
  List<dynamic> _newsList = [];
  List<dynamic> get newsList => _newsList;

  Future<void> fetchNews(String keyword) async {
    final url =
        "https://newsapi.org/v2/everything?q=$keyword&apiKey=5733eb82f6304e8f8dce26f6fd0ea8fd";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      _newsList = json.decode(response.body)['articles'];
      notifyListeners();
    } else {
      print("Error in loading news");
    }
  }
}
