import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final int item;
  final String title;
  const DetailPage({Key? key, required this.item, required this.title})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<Episode>> episodes;

  @override
  void initState() {
    super.initState();
    episodes = fetchEpisodes(widget.item);
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
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          )),
      body: Center(
          child: FutureBuilder(
        builder: (context, AsyncSnapshot<List<Episode>> snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Color.fromRGBO(253, 1, 40, 1),
                        child: Text(
                          '${snapshot.data![index].episodeId}',
                          style: TextStyle(color: Colors.white),
                        )),
                    title: Text(snapshot.data![index].title),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong :('));
          }
          return const CircularProgressIndicator(
            color: Colors.white,
          );
        },
        future: episodes,
      )),
    );
  }
}

class Episode {
  final int episodeId;
  final String title;

  Episode({required this.episodeId, required this.title});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(episodeId: json['episode_id'], title: json['title']);
  }
}

Future<List<Episode>> fetchEpisodes(id) async {
  final response = await http
      .get(Uri.parse('https://api.jikan.moe/v3/anime/$id/episodes/1'));

  if (response.statusCode == 200) {
    var episodesJson = jsonDecode(response.body)['episodes'] as List;
    return episodesJson.map((episode) => Episode.fromJson(episode)).toList();
  } else {
    throw Exception('Failed to load episodes');
  }
}
