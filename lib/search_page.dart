import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/team.dart';
import 'team_detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Team> allTeams = [];
  List<Team> searchResults = [];
  late Future<void> _fetchTeamsFuture; // Declare the Future variable

  @override
  void initState() {
    super.initState();
    _fetchTeamsFuture = _getTeams(); // Assign the Future in initState
  }

  // get all teams
  Future<void> _getTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      );
      allTeams.add(team);
    }

    setState(() {
      searchResults = List.from(allTeams);
    });

    print(allTeams.length);
  }

  // search teams
  void _searchTeams(String query) {
    setState(() {
      searchResults = allTeams
          .where((team) =>
              team.abbreviation.toLowerCase().contains(query.toLowerCase()) ||
              team.city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _fetchTeamsFuture.then((_) {
      if (mounted) {
        setState(
            () {}); // Check if the widget is still mounted before calling setState
      }
    }).catchError((error) {
      // Handle errors if any
      print("Error during dispose: $error");
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Teams'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchTeams,
              decoration: InputDecoration(
                hintText: 'Search teams...',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TeamDetailPage(team: searchResults[index]),
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
                        title: Text(searchResults[index].abbreviation),
                        subtitle: Text(searchResults[index].city),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
