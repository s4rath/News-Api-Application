import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/model/news_model.dart';

class TopNewsProvider extends ChangeNotifier {
  List<Article> _newsList = [];
  List<Article> get newsList => _newsList;

  Future<void> fetchNews() async {
    const url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=5733eb82f6304e8f8dce26f6fd0ea8fd";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['articles'];
        _newsList = data
            .where((e) => e['title'] != "[Removed]")
            .map((e) => Article.fromJson(e))
            .toList();
        notifyListeners();
      } else {
        print("Error in loading news: ${response.statusCode}");
        // You might want to throw an exception or handle this error more explicitly
      }
    } catch (error) {
      print("Error: $error");
      // Handle the error, log it, or show a message to the user
    }
  }
}

