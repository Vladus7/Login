import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/teams_model.dart';

class TeamsApiProvider {
  Client client = Client();


  Future<TeamsModel> fetchTeamsList(_idLeague) async {
    print("entered");
    final response = await client
        .get('https://www.thesportsdb.com/api/v1/json/1/lookup_all_teams.php?id=$_idLeague');
    print(response.body.toString());
    if (response.statusCode == 200) {
      return TeamsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}