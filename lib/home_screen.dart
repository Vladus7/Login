import 'package:flutter/material.dart';
import 'package:login_program/team_container.dart';
import 'package:login_program/countries.dart';
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
      LigList(),
    ];
    final HomeScreenBottmonNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.list), title: Text('Sport list')),
      BottomNavigationBarItem(
          icon: Icon(Icons.filter_frames), title: Text('League list')),
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
              icon: Icon(Icons.account_circle),
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
      body: _ListPages[HomeScreenIndex],
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

  Future<List> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(
        'https://www.thesportsdb.com/api/v1/json/1/all_sports.php'),
        headers: {"Accept": "application/json"});

      var extractdata = json.decode(response.body);
      data = extractdata["sports"];

    return data;
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: FutureBuilder(
        future: makeRequest(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
    return snapshot.hasData ?
    ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, i) {
              return  ListTile(
                title:  Text(data[i]["strSport"]),
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
            }):LoadingIndicator();}));
  }
}

class DetailInformationScreen extends StatelessWidget {
  DetailInformationScreen(this.data);

  final data;

  @override
  Widget build(BuildContext context) =>
      new Scaffold(
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
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(data["strSportDescription"],
                style: TextStyle(fontSize: 18)),
                             ),
            ])
          ]));
}

class LigList extends StatefulWidget {
  @override
  _LigListState createState() => _LigListState();
}

class _LigListState extends State<LigList> {


  String sport;
  String country;
  List data;
  Future<List<ListTile>> getJsonData() async {
    http.Response data;
    String key = "countrys";
    List<ListTile> listTiles = [];

    if (country == null && sport == null) { data = await http.get("https://www.thesportsdb.com/api/v1/json/1/all_leagues.php");
    key = "leagues";
    } else if (country != null&& sport == null) {
      data = await http.get("https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?c=$country");
    } else {
      data = await http.get("https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?c=$country&s=$sport");
    }
    var jsonData = json.decode(data.body);

    for (var i in jsonData[key]) {
      if (((sport != null) & (sport == i["strSport"])) | (sport == null)) {
        ListTile lt = ListTile(
          title: Text(i["strLeague"]),
          subtitle: Text(i["strSport"]),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeamsListScreen(i["idLeague"])));},
                  );
        listTiles.add(lt);
      }
    }
    return listTiles;
  }

  static const menuItems = countriesList;
  final List<DropdownMenuItem<String>> _dropDownItems = menuItems
      .map((String CountruValue) =>
      DropdownMenuItem<String>(
        value: CountruValue,
        child: Text(CountruValue),
      ),
  ).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(children: <Widget>[
          DropdownButton(
            value: country,
            hint: Text("Choose a countre league of which you want to find"),
            items:  _dropDownItems,
            onChanged: (value) {
              country = value;
              print(country);
              setState(() {});
              getJsonData();
            },
          ),
          SizedBox(width: 5),
          FutureBuilder(
              future: _getSports(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? DropdownButton(
                  value: sport,
                  hint: Text("Choose a sport league of which you want to find"),
                  items: snapshot.data,
                  onChanged: (value) {
                    sport = value;
                    print(sport);
                    getJsonData();
                    setState(() {});
                  },
                )
                    : Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator());
              }),
          Flexible(
              child: FutureBuilder(
                  future: getJsonData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return snapshot.data[index];
                        })
                        : Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child:  LoadingIndicator());
                  }))
        ]),
      ),
    );
  }
}


Future<List<DropdownMenuItem<String>>> _getSports() async {
  var data = await http
      .get("https://www.thesportsdb.com/api/v1/json/1/all_sports.php");
  var jsonData = json.decode(data.body);

  List<DropdownMenuItem<String>> listDrops = [];


  for (var i in jsonData["sports"]) {
    listDrops.add(DropdownMenuItem(
      child: Row(children: <Widget>[
        Text(i["strSport"].toString()),
      ]),
      value: i["strSport"],
    ));
  }
  return listDrops;
}
