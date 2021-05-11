import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'new-model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String date = DateTime.now().toString().substring(0, 10);
  List<Article> news = [];
  List<String> types = ['Covid', 'business', 'sports', 'politics', 'travel', 'technology'];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getArticles('india'));
    super.initState();
  }

  Future<void> getArticles(String value) async {
    news.clear();
    String url =
        "https://newsapi.org/v2/everything?q=$value&from=$date&sortBy=popularity&apiKey=9a9ac82d4fac47a5ab6e37138c5b86ad";
    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);
    jsonData["articles"].forEach((element) {
      Article article = Article(
        source: element['source']['name'] ?? '',
        title: element['title'],
        author: element['author'],
        description: element['description'],
        imgUrl: element['urlToImage'],
        publshedAt: DateTime.parse(element['publishedAt']),
        content: element["content"],
        articleUrl: element["url"],
      );
      setState(() {
        news.add(article);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter'),
            Text(
              'News',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: types.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      getArticles(types[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black45,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          types[index],
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: news.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                                image: NetworkImage(
                                  news[index].imgUrl ??
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7sB-3R8zwPPtSinx_2F4sPnmFzHbfnYjYfA6bc9YHaB5SNBe17MnErkDSSVi90UL-WLs&usqp=CAU',
                                ),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Title of the news Title of the news Title of the news Title of the news Title of the news ',
                          maxLines: 2,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Description of the news Description of the news Description of the news Description of the news Description of the news ',
                          maxLines: 2,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
