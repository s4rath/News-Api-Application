import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/screens/TopNewsScreen.dart';
import 'package:my_app/screens/favscreen.dart';
import 'package:my_app/screens/news.dart';
import 'package:my_app/provider/news_details_provider.dart';
import 'package:my_app/provider/news_provider.dart';
import 'package:my_app/screens/news_search.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0,
          elevation: 0,
          title: const Text("News API", style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return NewsSearch(
                    searchProvider: newsProvider,
                  );
                }));
              },
              icon: const Icon(Icons.search, color: Colors.black),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.black),
            ),
            
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200.0,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          child: Container(
                            width: 150.0,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              elevation: 4.0,
                              child: InkWell(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                onTap: () {
                                    Navigator.of(context)
                                      .push(MaterialPageRoute(builder: ((ctx) {
                                    return TopNewsScreen();
                                  })));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  child: Hero(
                                    tag: "imgTag",
                                    child: Container(
                                      // height: 54,
                                      // width: 51,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/breakingnews.jpg"),
                                              fit: BoxFit.cover),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))),
                ),
                Container(
                  height: 200.0,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          child: Container(
                            width: 150.0,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              elevation: 4.0,
                              child: InkWell(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: ((ctx) {
                                    return FavoritesScreen();
                                  })));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  child: Hero(
                                    tag: "imgTag",
                                    child: Container(
                                      // height: 54,
                                      // width: 51,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/bookmark.jpeg"),
                                              fit: BoxFit.cover),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))),
                ),
              ],
            )
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     controller: _searchController,
            //     decoration: InputDecoration(
            //       enabledBorder: OutlineInputBorder(
            //         borderSide: BorderSide(color: Colors.grey),
            //         borderRadius: BorderRadius.circular(20.0),
            //       ),
            //       border: new OutlineInputBorder(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(20),
            //         ),
            //         borderSide: new BorderSide(color: Colors.grey),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(20),
            //         ),
            //         borderSide: BorderSide(width: 1, color: Colors.white),
            //       ),
            //       hintText: 'Search...',
            //       suffixIcon: IconButton(
            //         icon: Icon(
            //           Icons.clear,
            //           color: Colors.black,
            //         ),
            //         onPressed: () => _searchController.clear(),
            //       ),
            //     ),
            //     onEditingComplete: () {
            //       searchKeyword = _searchController.text;
            //       apiCall(searchKeyword!);
            //     },
            //   ),
            // ),
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width * 1,
            //   child: ListView.builder(
            //     itemCount: Provider.of<NewsProvider>(context).newsList.length,
            //     itemBuilder: ((context, index) {
            //       final newsItem =
            //           Provider.of<NewsProvider>(context).newsList[index];
            //       return Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: InkWell(
            //           onTap: () {
            //             final newsDetailProvider =
            //                 Provider.of<NewsDetailProvider>(context,
            //                     listen: false);

            //             newsDetailProvider.setDetails(
            //               img: newsItem.urlToImage,
            //               description: newsItem.description,
            //               author: newsItem.author,
            //               title: newsItem.title,
            //               story_url: newsItem.url,
            //               sourceId: newsItem.sourceId,
            //               sourceName: newsItem.sourceName,
            //               publishedAt: newsItem.publishedAt,
            //               content: newsItem.content
            //             );
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) {
            //                   return NewsScreen();
            //                 },
            //               ),
            //             );
            //           },
            //           child: Container(
            //             height: 100,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(8),
            //               color: Colors.white,
            //               border:
            //                   Border.all(color: Colors.black26, width: 0.5),
            //             ),
            //             child: Row(
            //               children: [
            //                 Container(
            //                   height: 100,
            //                   width: 100,
            //                   decoration: BoxDecoration(
            //                       image: DecorationImage(
            //                           image: NetworkImage(
            //                             newsItem.urlToImage ?? "",
            //                           ),
            //                           fit: BoxFit.cover),
            //                       color: Colors.blue,
            //                       borderRadius: BorderRadius.circular(8)),
            //                 ),
            //                 Flexible(
            //                     child: Container(
            //                   child: Column(
            //                     children: [
            //                       Padding(
            //                           padding: const EdgeInsets.only(
            //                               left: 8, right: 8, top: 20),
            //                           child: RichText(
            //                             overflow: TextOverflow.ellipsis,
            //                             text: TextSpan(
            //                               text: newsItem.title,
            //                               style:
            //                                   TextStyle(color: Colors.black),
            //                             ),
            //                           )
            //                           // RichText(text: TextSpan(text: )),
            //                           ),
            //                       Padding(
            //                           padding: const EdgeInsets.only(
            //                               left: 8, right: 8, top: 20),
            //                           child: RichText(
            //                             overflow: TextOverflow.ellipsis,
            //                             text: TextSpan(
            //                               text: newsItem.description,
            //                               style:
            //                                   TextStyle(color: Colors.black),
            //                             ),
            //                           )
            //                           // RichText(text: TextSpan(text: )),
            //                           ),
            //                       Row(
            //                         children: [
            //                           Padding(
            //                             padding:
            //                                 const EdgeInsets.only(left: 8),
            //                             child: RichText(
            //                               overflow: TextOverflow.ellipsis,
            //                               text: TextSpan(
            //                                 text: newsItem.sourceId ??
            //                                     "Unknown",
            //                                 style: TextStyle(
            //                                     color: Colors.black),
            //                               ),
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding:
            //                                 const EdgeInsets.only(left: 5),
            //                             child: RichText(
            //                               overflow: TextOverflow.ellipsis,
            //                               textScaleFactor: 0.8,
            //                               softWrap: true,
            //                               text: TextSpan(
            //                                 text: _truncateText(newsItem.author ,20 )?? '',
            //                                 style: TextStyle(
            //                                     color: Colors.black),
            //                               ),
            //                             ),
            //                           )
            //                         ],
            //                       )
            //                     ],
            //                   ),
            //                 ))
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     }),
            //   ),
            // ),
          ],
        ));
  }
}
// String _truncateText(String? text, int maxLength) {
//   if (text == null || text.length <= maxLength) {
//     return text ?? '';
//   } else {
//     return text.substring(0, maxLength) + '...';
//   }
// }