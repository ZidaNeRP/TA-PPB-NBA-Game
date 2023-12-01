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
  int selectedYear = DateTime.now().year;
  bool isDataLoaded = false; // Flag to check if data has been loaded

  @override
  void initState() {
    super.initState();
    getGames(selectedYear);
  }

  Future<void> getGames(int year) async {
    if (!isDataLoaded) {
      final String startDate = '$year-01-01';
      final String endDate = '$year-12-31';

      try {
        var response = await http.get(
          Uri.https('www.balldontlie.io', 'api/v1/games', {
            'start_date': startDate,
            'end_date': endDate,
            'seasons[]': year.toString(),
            'team_ids[]': '1', // Change this to the desired team ID
          }),
        );

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          setState(() {
            games.clear();
            for (var gameData in jsonData['data']) {
              final game = Game.fromJson(gameData);
              games.add(game);
            }
            isDataLoaded = true; // Set the flag to true after data is loaded
          });

          print(games.length);
        } else {
          print('Failed to load games. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error during games request: $error');
      }
    }
  }

  // Function to change the selected year and reload data
  void changeYear(int year) {
    setState(() {
      selectedYear = year;
      isDataLoaded = false; // Reset the flag when changing the year
    });
    getGames(selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('NBA Games'),
              SizedBox(width: 16),
              Spacer(),
              // DropdownButton for selecting year
              DropdownButton<int>(
                value: selectedYear,
                items: List.generate(
                  DateTime.now().year - 1990 + 1,
                  (index) => DropdownMenuItem<int>(
                    value: 1990 + index,
                    child: Text((1990 + index).toString()),
                  ),
                ),
                onChanged: (int? year) {
                  if (year != null) {
                    changeYear(year);
                  }
                },
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: getGames(selectedYear),
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
