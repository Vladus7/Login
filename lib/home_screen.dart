import 'package:flutter/material.dart';
import 'package:login_program/loading_screen.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();

  final List<String> items;
  HomeScreen({Key key, @required this.items}) : super(key: key);
}

class HomeScreenState extends State<HomeScreen> {
  int HomeScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _ListPages = <Widget>[
      SportLigPage(),
      Icon(Icons.compare_arrows),
    ];
    final HomeScreenBottmonNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('Sport list')),
      BottomNavigationBarItem(icon: Icon(Icons.filter_frames), title: Text('Lig list')),
    ];
    assert(_ListPages.length == HomeScreenBottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: HomeScreenBottmonNavBarItems,
      currentIndex: HomeScreenIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          HomeScreenIndex = index;
        });
      },
    );

      return Scaffold(
        appBar: AppBar(
            title: Text('Chooise'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed('/login_screen');
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/account_screen');
                },
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Navigator.of(context).pushNamed('/share_screen');
                },
              ),
            ]),
        body:  _ListPages[HomeScreenIndex],
      bottomNavigationBar: bottomNavBar,
    )
    ;
  }
}


class SportLigPage extends StatefulWidget {
  @override
  _SportLigPageState createState() => new _SportLigPageState();
}

class _SportLigPageState extends State<SportLigPage> {
  List data;

  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull('https://www.thesportsdb.com/api/v1/json/1/all_sports.php'), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = json.decode(response.body);
      data = extractdata["sports"];
    });
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              return new ListTile(
                title: new Text(data[i]["strSport"]),
                leading: Image.network(
                  data[i]["strSportThumb"],
                  width: 100,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new DetailInformationScreen(data[i])));
                },
              );
            }));
  }
}

class DetailInformationScreen extends StatelessWidget {
  DetailInformationScreen(this.data);

  final data;

  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(title: new Text('More Information')),
      body: ListView(children: <Widget>[
        Column(children: <Widget>[
          SizedBox(height: 5.0),
          Container(
            child: Text(data["strSport"],
                style: TextStyle(color: Colors.red, fontSize: 32)),
          ),
          SizedBox(height: 5.0),
          Image.network(
            data["strSportThumb"],
          ),
          SizedBox(height: 20.0),
          SizedBox(
            child: Text(data["strSportDescription"]),
            width: 500,
          ),
        ])
      ]));
}
