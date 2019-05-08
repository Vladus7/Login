import 'package:flutter/material.dart';
import '../models/lig_model.dart';
import '../bloc/leagues_bloc.dart';
import 'package:login_program/resources/sport.dart';
import 'package:login_program/resources/countries.dart';
import 'package:login_program/ui/team_list_screen.dart';
import 'package:login_program/ui/widgets/loading_indicator.dart';
import 'package:login_program/ui/account_screen.dart';
import 'package:login_program/ui/share_screen.dart';

class LigList extends StatefulWidget {
  final String _emailAddress;

  LigList(this._emailAddress);

  @override
  _LigListState createState() => _LigListState();
}

class _LigListState extends State<LigList> {
  String sport;
  String country;
  List data;


  static const menuItems = countriesList;
  final List<DropdownMenuItem<String>> _dropDownItems = menuItems
      .map(
        (String CountruValue) => DropdownMenuItem<String>(
      value: CountruValue,
      child: Text(CountruValue),
    ),
  )
      .toList();

  static const menuItemsSport = sportList;
  final List<DropdownMenuItem<String>> _dropDownItemsSport = menuItemsSport
      .map(
        (String SportValue) => DropdownMenuItem<String>(
      value: SportValue,
      child: Text(SportValue),
    ),
  )
      .toList();

  @override
  Widget build(BuildContext context) {
    leaguesBloc.fetchAllLeagues(sport, country);
    return Scaffold(
        appBar: AppBar(
            title: Text('Chooise'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountScreen(widget._emailAddress)));
                },
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShareScreen()));
                },
              ),
            ]),
        body:
        Container(
          child: Center(
            child: Column(children: <Widget>[
              DropdownButton(
                value: country,
                hint: Text("    Countre"),
                items: _dropDownItems,
                isExpanded: true,
                onChanged: (value) {
                  country = value;
                  print(country);
                  setState(() {
                  });
                },
              ),
              SizedBox(width: 5),
              DropdownButton(
                value: sport,
                isExpanded: true,
                hint: Text("    Sport"),
                items: _dropDownItemsSport,
                onChanged: (value) {
                  sport = value;
                  print(sport);
                  setState(() {
                  });
                },
              ),
              Flexible(child:
              StreamBuilder(
                stream: leaguesBloc.allLeagues,
                builder: (context, AsyncSnapshot<leaguesModel> snapshot) {
                  if (snapshot.hasData) {
                    return buildList(snapshot);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return LoadingIndicator();
                },
              ),
              )
           ]),
          ),
        )
    );
  }

  Widget buildList(AsyncSnapshot<leaguesModel> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.results.length,
        itemBuilder: (BuildContext context, int index) {
          return  ListTile(
            title: Text(snapshot.data.results[index].title),
              subtitle: Text(snapshot.data.results[index].subtitle),
            onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeamsListScreen(snapshot.data.results[index].id)));
          },
          );
        },
    );
  }
}


