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

  List data;

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to exit an App'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull('https://api.myjson.com/bins/8jxuc'), headers: {'Accept': 'application/json'}
    );

    this.setState(() {
      data = json.decode(response.body);
    });
    print(data[1]['title']);

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
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
            body: Center(child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: data == null ? 0 : data.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        title: new Text(data[i]['title']),
                        subtitle: Text(data[i]['subtitle']),
                      );
                    },
                  );
                } 
                return LoadingIndicator();
              },
        ))
    )
    );
  }
}