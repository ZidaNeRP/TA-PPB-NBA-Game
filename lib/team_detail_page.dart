import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/team.dart';

class TeamDetailPage extends StatefulWidget {
  final Team team;

  TeamDetailPage({required this.team});

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  Map<String, dynamic>? teamDetails;

  @override
  void initState() {
    super.initState();
    _fetchTeamDetails();
  }

  Future<void> _fetchTeamDetails() async {
    try {
      final response = await http.get(
        Uri.https('www.balldontlie.io', 'api/v1/teams'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final teams = jsonData['data'] as List<dynamic>;

        // Check if the widget is still mounted before updating state
        if (mounted) {
          for (var team in teams) {
            if (team['abbreviation'] == widget.team.abbreviation) {
              setState(() {
                teamDetails = team;
              });
              break;
            }
          }
        }
      } else {
        // Handle error if the request fails
        print('Failed to load team details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any exception during the request
      print('Error during team details request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Details'),
      ),
      body: teamDetails == null
          ? Center(child: CircularProgressIndicator())
          : _buildTeamDetails(),
    );
  }

  Widget _buildTeamDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Name: ${teamDetails!["full_name"]}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Abbreviation: ${teamDetails!["abbreviation"]}'),
          SizedBox(height: 8),
          Text('City: ${teamDetails!["city"]}'),
          // Add more details as needed
        ],
      ),
    );
  }
}
