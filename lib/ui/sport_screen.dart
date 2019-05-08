import 'package:login_program/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import '../models/sport_model.dart';
import '../bloc/sport_bloc.dart';
import 'package:login_program/ui/detail_inf_sport_screen.dart';
import 'package:login_program/ui/account_screen.dart';
import 'package:login_program/ui/share_screen.dart';

class SportLigPage extends  StatefulWidget {
  final String _emailAddress;

  SportLigPage(this._emailAddress);
  @override
  _SportLigPageState createState() {
    return _SportLigPageState();
  }
}

class _SportLigPageState extends State<SportLigPage> {

  @override
  Widget build(BuildContext context) {
    sportBloc.fetchAllSport();
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
      body: StreamBuilder(
        stream: sportBloc.allSport,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
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

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.results.length,
        itemBuilder: (BuildContext context, int index) {
          return  ListTile(
                      title: Text(snapshot.data.results[index].title),
                      leading:   Image.network(
                        snapshot.data.results[index].picture,
                        fit: BoxFit.cover,
                        width: 100,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new DetailInformationScreen(snapshot.data.results[index])));
                      },
                    );
        });
  }
}