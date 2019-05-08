import 'package:flutter/material.dart';
import 'package:login_program/ui/widgets/loading_indicator.dart';
import 'package:login_program/ui/team_screen.dart';
import 'package:login_program/models/teams_model.dart';
import 'package:login_program/bloc/team_bloc.dart';

class TeamsListScreen extends StatefulWidget {
  final String _idLeague;

  TeamsListScreen(this._idLeague);

  @override
  _TeamsListScreenState createState() => _TeamsListScreenState(_idLeague);
}

class _TeamsListScreenState extends State<TeamsListScreen> {
  final String _idLeague;

  _TeamsListScreenState(this._idLeague);


  @override
  Widget build(BuildContext context) {
    teamsBloc.fetchAllTeams(_idLeague);
    return Scaffold(
      appBar: AppBar(
        title: Text('Teams List'),
      ),
      body: StreamBuilder(
        stream: teamsBloc.allTeams,
        builder: (context, AsyncSnapshot<TeamsModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return LoadingIndicator();
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<TeamsModel> snapshot) {
          return  PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.results.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 55, vertical: 60),
                    child: Stack(
                        children: <Widget>[
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.red[200],
                                  borderRadius: BorderRadius.circular(10.0)),
                              width: 300.0,
                              height: 450.0,
                              alignment: AlignmentDirectional.center,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(snapshot.data.results[index].title.toString(),
                                        style: TextStyle(
                                            fontSize: 35,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 50),
                                    Hero(
                                      tag: 'imageTeamHero${snapshot.data.results[index].title}',
                                      child: Image.network(
                                        snapshot.data.results[index].picture,
                                        width: 230,
                                      ),
                                    ),
                                  ])),
                          GestureDetector(onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                                  return TeamsScreen(
                                      snapshot.data.results[index].title,
                                      snapshot.data.results[index].picture,
                                      snapshot.data.results[index].descriptionEN,
                                      snapshot.data.results[index].Youtube,
                                      snapshot.data.results[index].Instagram,
                                  snapshot.data.results[index].Facebook,
                                      snapshot.data.results[index].Website);
                                }));
                          }),
                        ]));});

  }
}
