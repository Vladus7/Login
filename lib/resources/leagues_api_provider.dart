import 'dart:async';
import 'package:http/http.dart' as Client;
import 'dart:convert';
import '../models/lig_model.dart';


class LeaguesApiProvider {


  Future<leaguesModel> fetchLeaguesList(sport, country) async {
    print("entered");
    Client.Response response;
    String key = "countrys";
    if (country == null && sport == null) {
      response = await Client
          .get("https://www.thesportsdb.com/api/v1/json/1/all_leagues.php");
      key = "leagues";
    } else if (country != null && sport == null) {
      response = await Client
          .get(
          "https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?c=$country");
    } else {
      response = await Client
          .get(
          "https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?c=$country&s=$sport");
    }
    print(response);
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return leaguesModel.fromJson(json.decode(response.body), sport, key);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}