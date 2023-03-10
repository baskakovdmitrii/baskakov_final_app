import 'dart:math';
import 'package:baskakov_app/features/internet_check.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:intl/intl.dart';
import 'package:baskakov_app/screens/full_news_screen.dart';
import 'package:baskakov_app/widgets/image_widget.dart';
import 'package:baskakov_app/features/parse_description.dart';

const url = "https://lenta.ru/rss";

class HomeScreenRSS extends StatefulWidget {
  const HomeScreenRSS({super.key});

  @override
  _HomeScreenRSSState createState() => _HomeScreenRSSState();
}

class _HomeScreenRSSState extends State {
  final List _newsList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InternetCHeck>(
      create: (_) => InternetCHeck(connectivity: Connectivity()),
      child: MaterialApp(
        theme: ThemeData.light(),
        home: BlocListener<InternetCHeck, ConnectivityResult>(
  listener: (context, state) {
    if (state == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Нет интернет-соединения"),
      ));
    }
  },
          child: Scaffold(
            backgroundColor: Colors.lightBlueAccent[100],
            appBar: AppBar(
              title: Text(
              'Lenta.ru',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            centerTitle: true,
            toolbarHeight: 60.2,
            toolbarOpacity: 0.8,
            shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            elevation: 0.00,
            backgroundColor: Colors.lightBlueAccent[400],
            ),
             body: FutureBuilder(
                future: _getHttpNews(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                   return const Center(
                   child: CircularProgressIndicator(),
                   );
                    } else {
                return ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                      top: 10.0,
                      right: 5.0,
                      bottom: 10.0,
                    ),
                    scrollDirection: Axis.vertical,
                    itemCount: _newsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final dateTime = DateFormat('EEE, dd MMM yy HH:mm:ss').parse(_newsList[index].pubDate); // Вывод даты публикации новости
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Column(
                            children: [
                              Text(
                                '${_newsList[index].title}', // Вывод заголовка новости
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600
                                ),),
                              ),
                              ImageWidget(
                                  urlImage: (_newsList[index] as RssItem).enclosure?.url??''), // Вывод изображения
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '${parseDescriptionOfNews(_newsList[index].description)}', // Вывод описания
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400
                                  ),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}',
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400
                                        ),),

                                    ),
                                    FloatingActionButton.small(
                                      heroTag: null,
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FullNewsScreen(urlNews: '${_newsList[index].link}')
                                          )
                                      ),
                                      shape: const RoundedRectangleBorder(),
                                      backgroundColor: Colors.lightBlueAccent[400],
                                      child: const Icon(Icons.arrow_forward),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    );
              }
            },
          ),
        ),
),
      ),
    );
  }

  _getHttpNews() async {
    final response = await http.Client().get(Uri.parse(url));
    final rssFeed = RssFeed.parse(response.body);
    for (var element in rssFeed.items) {
      _newsList.add(element);
    }
    return _newsList;
  }
}
