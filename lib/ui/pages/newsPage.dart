import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/model/article.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/others/contants.dart';
import 'dart:async';
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

class NewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewsPageState();
  }
}

class _NewsPageState extends State<NewsPage> {
  List<Article> _news = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final newsData = await _fetchNewsData();
    setState(() {
      _news = newsData;
      _isLoading = false;
    });
  }

  Future<List<Article>> _fetchNewsData() async {
    final url = AppConstants.NEWS_API_URL;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final results = jsonDecode(response.body)["articles"];

        List<Article> articles = [];

        for (var item in results) {
          articles.add(Article.fromMap(item));
        }

        return articles;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print("_fetchNewsData exception : $e");
      return [];
    }
  }

  Widget _customWidget(Article article) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _customWebViewWrapper(article),
          ),
        )
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    article.title,
                    maxLines: 10,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Image.network(
                    article.urlToImage,
                    width: 100,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null)
                        return child;
                      else
                        return Center(child: CupertinoActivityIndicator());
                    },
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _customWebViewWrapper(Article article) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        centerTitle: true,
        toolbarHeight: 40,
        leading: BackButton(),
      ),
      body: WebView(
        initialUrl: article.url,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        centerTitle: true,
        toolbarHeight: 40,
      ),
      body: _isLoading
          ? Center(child: CupertinoActivityIndicator())
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _news.length,
              itemBuilder: (context, index) {
                return _customWidget(_news[index]);
              },
            ),
    );
  }
}
