import 'package:flutter/material.dart';

class DetailInformationScreen extends StatelessWidget {
  DetailInformationScreen(this.data);

  final data;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('More Information')),
      body: ListView(children: <Widget>[
        Column(children: <Widget>[
          SizedBox(height: 5.0),
          Container(
            child: Text(data.title,
                style: TextStyle(color: Colors.red, fontSize: 32)),
          ),
          SizedBox(height: 5.0),
          Image.network(
            data.picture,
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(data.subtitle,
                style: TextStyle(fontSize: 18)),
          ),
        ])
      ]));
}