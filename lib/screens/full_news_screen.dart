import 'package:flutter/material.dart';
import 'package:baskakov_app/models/news_model.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class FullNewsScreen extends StatefulWidget {
  final urlNews;

  FullNewsScreen({@required this.urlNews});

  @override
  _FullNewsScreenState createState() => _FullNewsScreenState();
}

class _FullNewsScreenState extends State<FullNewsScreen> {
  var _newsModel = News(title: '', news_url: '', body: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _getNews());
  }

  _getNews() {
    return FutureBuilder(
      future: _getHttpFullNews(),
      builder: (context, AsyncSnapshot<News> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: RepaintBoundary(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return ListView(
            padding: const EdgeInsets.only(
                left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${snapshot.data?.title}',
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${snapshot.data?.body}',
                  style: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<News> _getHttpFullNews() async {
    var response = await http.Client().get(Uri.parse(widget.urlNews));
    final _news = parse(response.body);

    _newsModel.title = _news.getElementsByClassName('topic-body__titles')[0].text;
    _newsModel.body = _news.getElementsByClassName('topic-body__content')[0].text;
    _newsModel.news_url = widget.urlNews;

    return _newsModel;
  }
}
