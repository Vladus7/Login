import 'dart:async';
import 'sport_api_provider.dart';
import 'leagues_api_provider.dart';
import 'teams_api_provider.dart';
import '../models/sport_model.dart';
import '../models/lig_model.dart';
import '../models/teams_model.dart';
import 'firestore_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Repository {
  final _firestoreProvider = FirestoreProvider();


  Future<int> authenticateUser(String email, String password) =>
      _firestoreProvider.authenticateUser(email, password);

  Future<int> registerAuthUser(String email, String password) =>
      _firestoreProvider.registerAuthUser(email, password);

  Future<int> signIn(String email, String password) =>
      _firestoreProvider.registerAuthUser(email, password);

  Future<void> registerUser(String email, String password) =>
      _firestoreProvider.registerUser(email, password);

  Future<void> registerUserWithGoogle(String email, String password, String name, String photo) =>
      _firestoreProvider.registerUserWithGoogle(email, password, name,  photo);

  Future<void> registerUserWithFacebook(String email, String password, String name, String photo) =>
      _firestoreProvider.registerUserWithFacebook(email, password, name,  photo);

  Future<void> UpdateUser(String email, bool isAdmin, String name, String password ,String photo) =>
      _firestoreProvider.UpdateUser(email, isAdmin, name, password ,photo);

  Future<void> UpdateUserFacebook(String email, bool isAdmin, String name, String password ,String photo) =>
      _firestoreProvider.UpdateUserFacebook(email, isAdmin, name, password ,photo);

  Future<void> uploadGoal(String title, String price, String photo, String goal) =>
      _firestoreProvider.addData(title, price, photo, goal);

  Future<void>UpdateData(String name, String description, String photo, String price) =>
      _firestoreProvider.UpdateData(name, description, photo,  price);

  Future<void>addGoods(email, String title, String price, String photo, String goal) =>
      _firestoreProvider.addGoods(email, title, price, photo, goal);

  Future<void> deleteData(name)=>
      _firestoreProvider.deleteData(name);

  Future<void> deleteGoods(email, title)=>
      _firestoreProvider.deleteGoods(email, title);

  Stream<DocumentSnapshot> accountUser(String email) =>
      _firestoreProvider.accountUser(email);

  Stream<QuerySnapshot> othersGoodsList() => _firestoreProvider.othersGoodsList();

  Stream<QuerySnapshot> goodsList(email) => _firestoreProvider.goodsList(email);

}



class SportRepository {
  final sportApiProvider = SportApiProvider();

  Future<ItemModel> fetchAllSport() => sportApiProvider.fetchSportList();
}

class LeaguesRepository {
  final leaguesApiProvider = LeaguesApiProvider();

  Future<leaguesModel> fetchAllLeagues(sport, country) => leaguesApiProvider.fetchLeaguesList(sport, country);
}

class TeamsRepository {
  final teamsApiProvider = TeamsApiProvider();

  Future<TeamsModel> fetchAllTeams(id) => teamsApiProvider.fetchTeamsList(id);
}
