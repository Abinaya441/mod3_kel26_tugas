import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mod3_kel26/screens/detail.dart';
import 'package:mod3_kel26/screens/desc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    AnimePage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(bottom: Radius.elliptical(50, 50))),
        title: Text(
          'MyAnimeList',
          style: GoogleFonts.pacifico(
              fontSize: 30, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(253, 1, 40, 1),
      ),
      body: IndexedStack(
        children: _pages,
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        // unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.red,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AnimePage extends StatefulWidget {
  const AnimePage();
  @override
  _AnimePageState createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  late Future<List<Show>> shows;
  late Future<List<ShowAir>> showsAir;

  @override
  void initState() {
    super.initState();
    shows = fetchShows();
    showsAir = fetchShowsAir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              'Top Anime Airing',
              style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(253, 1, 40, 1)),
            ),
          ),
          //HORIZONTAL
          FutureBuilder(
            builder: (context, AsyncSnapshot<List<ShowAir>> snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DescPage(
                                        item: snapshot.data![index].malId,
                                        title: snapshot.data![index].title)));
                          },
                          child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: SizedBox(
                                height: 200,
                                width: 100,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Center(
                                          child: Image.network(
                                            snapshot.data![index].imageUrl,
                                            width: 100,
                                            height: 170,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index].title,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                    Container(
                                        height: 20,
                                        width: 50,
                                        margin:
                                            EdgeInsets.only(left: 5, top: 5),
                                        decoration: new BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            borderRadius: new BorderRadius.all(
                                                Radius.elliptical(10, 10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            '⭐ ${snapshot.data![index].score}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunito(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        ))
                                  ],
                                ),
                              )))),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong :('));
              }
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            },
            future: showsAir,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              'Top Anime of All Time',
              style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(253, 1, 40, 1)),
            ),
          ),
          //VERTIKAL
          Expanded(
            child: FutureBuilder(
              builder: (context, AsyncSnapshot<List<Show>> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.white,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    snapshot.data![index].imageUrl),
                              ),
                              title: Text(
                                snapshot.data![index].title,
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Score: ${snapshot.data![index].score}',
                                style: GoogleFonts.nunito(fontSize: 14),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                          item: snapshot.data![index].malId,
                                          title: snapshot.data![index].title),
                                    ));
                              },
                            ),
                          );
                        }),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong :('));
                }
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              },
              future: shows,
            ),
          )
        ],
      ),
    );
  }
}

class AboutPage extends StatefulWidget {
  const AboutPage();
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Image.asset(
                  "images/geo.png",
                  width: 250,
                  height: 250,
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Kelompok 26',
                style: GoogleFonts.nunito(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 194, 85, 1)),
              ),
            ),
            Text(
              'Rizaldy Imam - 21120119140119\nHaickal Fattih - 21120119140131\nM Abinaya Isaqofi - 21120119130039\nAdzra Fatikha - 21120119120032',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}

class Show {
  final int malId;
  final String title;
  final String imageUrl;
  final num score;

  Show({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['image_url'],
      score: json['score'],
    );
  }
}

Future<List<Show>> fetchShows() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v3/top/anime/1'));

  if (response.statusCode == 200) {
    var topShowsJson = jsonDecode(response.body)['top'] as List;
    return topShowsJson.map((show) => Show.fromJson(show)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}

class ShowAir {
  final int malId;
  final String title;
  final String imageUrl;
  final num score;

  ShowAir({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
  });

  factory ShowAir.fromJson(Map<String, dynamic> json) {
    return ShowAir(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['image_url'],
      score: json['score'],
    );
  }
}

Future<List<ShowAir>> fetchShowsAir() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v3/top/anime/1/airing'));

  if (response.statusCode == 200) {
    var topShowsJson = jsonDecode(response.body)['top'] as List;
    return topShowsJson.map((show) => ShowAir.fromJson(show)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
