import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/news.dart';
import 'package:my_app/news_details_provider.dart';
import 'package:my_app/news_provider.dart';
import 'package:provider/provider.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = PostHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsDetailProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();

  String? searchKeyword;

  Future<void> apiCall(String keyword) async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    await newsProvider.fetchNews(keyword);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: new BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(width: 1, color: Colors.white),
                    ),
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      onPressed: () => _searchController.clear(),
                    ),
                  ),
                  onEditingComplete: () {
                    searchKeyword = _searchController.text;
                    apiCall(searchKeyword!);
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 1,
                child: ListView.builder(
                  itemCount: Provider.of<NewsProvider>(context).newsList.length,
                  itemBuilder: ((context, index) {
                    final newsItem =
                        Provider.of<NewsProvider>(context).newsList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          final newsDetailProvider =
                              Provider.of<NewsDetailProvider>(context,
                                  listen: false);

                          newsDetailProvider.setDetails(
                            img: newsItem['urlToImage'],
                            description: newsItem['description'],
                            author: newsItem['author'],
                            title: newsItem['title'],
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return NewsScreen();
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.black26, width: 0.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          newsItem["urlToImage"] ?? "",
                                        ),
                                        fit: BoxFit.cover),
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              Flexible(
                                  child: Container(
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, top: 20),
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            text: newsItem["title"],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        )
                                        // RichText(text: TextSpan(text: )),
                                        ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, top: 20),
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            text: newsItem["description"],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        )
                                        // RichText(text: TextSpan(text: )),
                                        ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              text: newsItem["source"]['id'] ??
                                                  "Unknown",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            textScaleFactor: 0.8,
                                            softWrap: true,
                                            text: TextSpan(
                                              text: _truncateText(newsItem['author'],20 )?? '',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}
String _truncateText(String? text, int maxLength) {
  if (text == null || text.length <= maxLength) {
    return text ?? '';
  } else {
    return text.substring(0, maxLength) + '...';
  }
}