import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/screens/news.dart';
import 'package:my_app/provider/news_details_provider.dart';
import 'package:my_app/provider/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsSearch extends StatefulWidget {
  const NewsSearch({super.key, required this.searchProvider});
  final NewsProvider searchProvider;
  @override
  State<NewsSearch> createState() => _NewsSearchState();
}

class _NewsSearchState extends State<NewsSearch> {
  final NewsProvider _searchProvider = NewsProvider();
  List<dynamic> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  String? searchKeyword;

  void _performSearch(String query) async {
    await _searchProvider.fetchNews(query);
    setState(() {
      _searchResults = _searchProvider.newsList;
    });
  }

  apiCall(String keyword) async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    await newsProvider.fetchNews(keyword);
    setState(() {
      _searchResults = _searchProvider.newsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<dynamic> eventsToDisplay = _searchResults;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 50,
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 30, color: Colors.blueAccent),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onEditingComplete: () {
                        searchKeyword = _searchController.text;
                        apiCall(searchKeyword!);
                      },
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 19),
                        hintText: "Type Anything",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 1,
        child: ListView.builder(
          itemCount: Provider.of<NewsProvider>(context).newsList.length,
          itemBuilder: ((context, index) {
            final newsItem = Provider.of<NewsProvider>(context).newsList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  final newsDetailProvider =
                      Provider.of<NewsDetailProvider>(context, listen: false);
                  print(newsItem.description);

                  newsDetailProvider.setDetails(
                      img: newsItem.urlToImage,
                      description: newsItem.description,
                      author: newsItem.author,
                      title: newsItem.title,
                      story_url: newsItem.url,
                      sourceId: newsItem.sourceId,
                      sourceName: newsItem.sourceName,
                      publishedAt: newsItem.publishedAt,
                      content: newsItem.content);
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
                    border: Border.all(color: Colors.black26, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          newsItem.urlToImage,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              'assets/notfound.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
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
                                    text: newsItem.title.trim(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                                // RichText(text: TextSpan(text: )),
                                ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 20),
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: newsItem.description.length > 44
                                        ? newsItem.description.substring(0, 44)
                                        : newsItem.description,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                                // RichText(text: TextSpan(text: )),
                                ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: newsItem.sourceId ?? "Unknown",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 0.8,
                                    softWrap: true,
                                    text: TextSpan(
                                      text:
                                          _truncateText(newsItem.author, 20) ??
                                              '',
                                      style: TextStyle(color: Colors.black),
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
    );
  }
}

String _truncateText(String? text, int maxLength) {
  if (text == null || text.length <= maxLength) {
    return text ?? '';
  } else {
    return text.substring(0, maxLength) + '...';
  }
}
