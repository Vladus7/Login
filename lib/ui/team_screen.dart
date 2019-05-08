import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
