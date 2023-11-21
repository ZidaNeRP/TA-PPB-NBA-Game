// home_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/game.dart';
import 'game_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Game> games = [];

  // get games
  Future<void> getGames() async {
    var response = await http.get(Uri.https('www.balldontlie.io', 'api/v1/games'));
    var jsonData = jsonDecode(response.body);

    for (var gameData in jsonData['data']) {
      final game = Game.fromJson(gameData);
      games.add(game);
    }

    print(games.length);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('NBA Games'), // Set your app bar title
        ),
        body: FutureBuilder(
          future: getGames(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: games.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GameDetailPage(game: games[index]),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            '${games[index].homeTeam.fullName} vs ${games[index].visitorTeam.fullName}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Score: ${games[index].homeTeamScore} - ${games[index].visitorTeamScore}',
                          ),
                          trailing: Text('Season: ${games[index].season}'),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
