// game_detail_page.dart
import 'package:flutter/material.dart';
import 'models/game.dart';

class GameDetailPage extends StatelessWidget {
  final Game game;

  GameDetailPage({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${game.date.toLocal()}'),
            Text('Status: ${game.status}'),
            SizedBox(height: 16),
            Text('Teams and Scores:'),
            _buildTeamsTable(),
            // Add more details as needed
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsTable() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Home Team', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Visitor Team', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(game.homeTeam.fullName),
              SizedBox(height: 4),
              Text('${game.homeTeamScore}', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            children: [
              Text(game.visitorTeam.fullName),
              SizedBox(height: 4),
              Text('${game.visitorTeamScore}', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ],
  );
}

}
