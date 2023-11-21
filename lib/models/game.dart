// game.dart
class Game {
  final int id;
  final DateTime date;
  final int homeTeamScore;
  final int visitorTeamScore;
  final int season;
  final int period;
  final String status;
  final String time;
  final bool postseason;
  final Team homeTeam;
  final Team visitorTeam;

  Game({
    required this.id,
    required this.date,
    required this.homeTeamScore,
    required this.visitorTeamScore,
    required this.season,
    required this.period,
    required this.status,
    required this.time,
    required this.postseason,
    required this.homeTeam,
    required this.visitorTeam,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      date: DateTime.parse(json['date']),
      homeTeamScore: json['home_team_score'],
      visitorTeamScore: json['visitor_team_score'],
      season: json['season'],
      period: json['period'],
      status: json['status'],
      time: json['time'],
      postseason: json['postseason'],
      homeTeam: Team.fromJson(json['home_team']),
      visitorTeam: Team.fromJson(json['visitor_team']),
    );
  }
}

class Team {
  final int id;
  final String abbreviation;
  final String city;
  final String conference;
  final String division;
  final String fullName;
  final String name;

  Team({
    required this.id,
    required this.abbreviation,
    required this.city,
    required this.conference,
    required this.division,
    required this.fullName,
    required this.name,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      abbreviation: json['abbreviation'],
      city: json['city'],
      conference: json['conference'],
      division: json['division'],
      fullName: json['full_name'],
      name: json['name'],
    );
  }
}
