import 'package:flutter/material.dart';
import 'package:login_program/loading_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class TeamsListScreen extends StatefulWidget {
  final String _idLeague;

  TeamsListScreen(this._idLeague);

  @override
  _TeamsListScreenState createState() => _TeamsListScreenState(_idLeague);
}

class _TeamsListScreenState extends State<TeamsListScreen> {
  final String _idLeague;

  _TeamsListScreenState(this._idLeague);

  List data;

  Future<List> getJsonData() async {
    var response = await http.get(
        Uri.encodeFull(
            'https://www.thesportsdb.com/api/v1/json/1/lookup_all_teams.php?id=$_idLeague'),
        headers: {"Accept": "application/json"});

    var extractdata = json.decode(response.body);
    data = extractdata['teams'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Teams List'),
        ),
        body: FutureBuilder(
            future: getJsonData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ?  PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, i) {
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
                                  Text(data[i]["strTeam"].toString(),
                                      style: TextStyle(
                                          fontSize: 35,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center),
                                  SizedBox(height: 50),
                                  Hero(
                                    tag: 'imageTeamHero${data[i]["strTeam"]}',
                                    child: Image.network(
                                      data[i]["strTeamBadge"],
                                      width: 230,
                                    ),
                                  ),
                                ])),
                            GestureDetector(onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                    return TeamsScreen(
                                        data[i]["strTeam"],
                                        data[i]["strTeamBadge"],
                                        data[i]["strDescriptionEN"],
                                        data[i]["strYoutube"],
                                        data[i]["strInstagram"],
                                        data[i]["strFacebook"],
                                        data[i]["strWebsite"]);
                                  }));
                            }),
                        ]));})
                  : LoadingIndicator();
            }));
  }
}

class TeamsScreen extends StatelessWidget {
  final String teamName;
  final String picture;
  final String teamDescription;
  final String youtube;
  final String instagtam;
  final String facebook;
  final String website;

  TeamsScreen(
    this.teamName,
    this.picture,
    this.teamDescription,
    this.youtube,
    this.instagtam,
    this.facebook,
    this.website,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(teamName)),
        body: Container(
            alignment: Alignment.center,
            child: ListView(children: <Widget>[
              Column(children: <Widget>[
                SizedBox(height: 20),
                SizedBox(
                    height: 200.0,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: <
                            Widget>[
                      Row(children: <Widget>[
                        Hero(
                            tag: 'imageTeamHero${teamName}',
                            child: Image.network(picture, width: 150)),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              website.length != 0
                                  ? Row(children: <Widget>[
                                      Image.network(
                                          "https://img.icons8.com/metro/1600/domain.png",
                                          width: 30),
                                      FlatButton(
                                          onPressed: () {
                                            loadWebSite(website);
                                          },
                                          child: Text(website,
                                              style: TextStyle(fontSize: 16)))
                                    ])
                                  : SizedBox(height: 0),
                              instagtam.length != 0
                                  ? Row(children: <Widget>[
                                      Image.network(
                                          "https://instagram-brand.com/wp-content/uploads/2016/11/app-icon2.png",
                                          width: 30),
                                      FlatButton(
                                          onPressed: () {
                                            loadWebSite(instagtam);
                                          },
                                          child: Text(instagtam,
                                              style: TextStyle(fontSize: 16)))
                                    ])
                                  : SizedBox(height: 0),
                              facebook.length != 0
                                  ? Row(children: <Widget>[
                                      Image.network(
                                          "http://www.iconarchive.com/download/i54037/danleech/simple/facebook.ico",
                                          width: 30),
                                      FlatButton(
                                          onPressed: () {
                                            loadWebSite(facebook);
                                          },
                                          child: Text(facebook,
                                              style: TextStyle(fontSize: 16)))
                                    ])
                                  : SizedBox(height: 0),
                              youtube.length != 0
                                  ? Row(children: <Widget>[
                                      Image.network(
                                          "https://cdn0.iconfinder.com/data/icons/social-flat-rounded-rects/512/youtube_v2-512.png",
                                          width: 30),
                                      FlatButton(
                                          onPressed: () {
                                            loadWebSite(youtube);
                                          },
                                          child: Text(youtube,
                                              style: TextStyle(fontSize: 16)))
                                    ])
                                  : SizedBox(height: 0),
                            ])
                      ])
                    ])),
                SizedBox(height: 15),
                Text(
                  teamName,
                  style: TextStyle(fontSize: 32),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(teamDescription,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.justify)),
              ])
            ])));
  }

  void loadWebSite(String url) async {
    if (await canLaunch("http://$url")) {
      await launch("http://$url");
    } else {
      throw 'Could not launch $url';
    }
  }
}
