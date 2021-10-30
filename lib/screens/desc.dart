import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DescPage extends StatefulWidget {
  final int item;
  final String title;
  const DescPage({Key? key, required this.item, required this.title})
      : super(key: key);

  @override
  _DescPageState createState() => _DescPageState();
}

class _DescPageState extends State<DescPage> {
  late Future<Desc> descc;

  @override
  void initState() {
    super.initState();
    descc = fetchDesc(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color.fromRGBO(253, 1, 40, 1),
          title: Text(
            widget.title,
            style: GoogleFonts.nunito(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<Desc>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.network(
                      snapshot.data!.image_url,
                      width: 300,
                      height: 300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      snapshot.data!.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(color: Colors.red),
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      'Score: ${snapshot.data!.score} ⭐',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(color: Colors.black),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    'Broadcast: ${snapshot.data!.broadcast}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(color: Colors.black),
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      snapshot.data!.synopsis,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(color: Colors.black),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong :('),
              );
            }
            return const CircularProgressIndicator(
              color: Colors.white,
            );
          },
          future: descc,
        )));
  }
}

class Desc {
  final int mal_id;
  final String title;
  final String image_url;
  final String synopsis;
  final String broadcast;
  final num score;

  Desc({
    required this.mal_id,
    required this.title,
    required this.image_url,
    required this.synopsis,
    required this.broadcast,
    required this.score,
  });

  factory Desc.fromJson(Map<String, dynamic> json) {
    return Desc(
      mal_id: json['mal_id'],
      title: json['title'],
      image_url: json['image_url'],
      synopsis: json['synopsis'],
      broadcast: json['broadcast'],
      score: json['score'],
    );
  }
}

Future<Desc> fetchDesc(id) async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v3/anime/$id'));

  if (response.statusCode == 200) {
    return Desc.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load description');
  }
}
