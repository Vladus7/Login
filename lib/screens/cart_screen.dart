import 'package:flutter/material.dart';
import 'package:login_program/tikets_screen.dart';
import 'package:login_program/widgets/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login_program/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  SharedPreferences sharedPreferences;
  String sharedPreferenceUser;

  QuerySnapshot cart;
  crudMedthods crudObj = crudMedthods();

  @override
  void initState() {
    super.initState();
    _onChanged();
  }

  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferenceUser = sharedPreferences.getString("username");
      crudObj.getDataGoods(sharedPreferenceUser).then((results) {
        setState(() {
          cart = results;
        });
      });
    });

  }

  Widget _cartUserList() {
    if (cart!= null) {
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: cart.documents.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ), //child: Padding(
            //padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                //color: Color(0xffd50000).withOpacity(0.78),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Stack(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 50.0),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.89), //80
                        borderRadius: BorderRadius.circular(10.0)),
                    width: 400.0,
                    height: 130.0,
                    child: Row(children: <Widget>[
                      Column(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 50.0),
                          child: Text(cart.documents[i].data['productName'],
                              style: TextStyle(color: Colors.white)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40.0),
                          child: Text(cart.documents[i].data['description'],
                              style: TextStyle(color: Colors.white)),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: 200.0, top: 45.0, bottom: 10.0),
                            decoration: BoxDecoration(
                                color: Color(0xffd50000).withOpacity(0.78),
                                borderRadius: BorderRadius.circular(3.0)),
                            width: 60.0,
                            height: 30.0,
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              cart.documents[i].data['price'],
                              style: TextStyle(color: Colors.black),
                            )),
                      ]),
                Container(
                        margin: EdgeInsets.only(
                          left: 10.0,
                          right: 5.0,
                          top: 3.0,
                          bottom: 80.0,
                        ),
                        //padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                        child:
                            IconButton(
                              icon: Icon(Icons.clear, color: Colors.white),
                              onPressed: () {
                                crudObj.DelateGoods(sharedPreferenceUser, cart.documents[i].data['productName']);
                              },
                            ),)
                    ])
                  //)
                ),
                Padding(
                    padding: EdgeInsets.only(top: 12.5),
                    child: CircleAvatar(
                      backgroundImage:
                      NetworkImage(cart.documents[i].data['photoUrl']),
                      radius: 50,
                    )),
              ]),
            ),
          );
        },
      );
    } else {
      return LoadingIndicator();
    }
  }



  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Buying'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
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
        body:  _cartUserList(),
          floatingActionButton: FloatingActionButton.extended(
//            onPressed: () {
//            addDialog(context);
//          },
            backgroundColor: Color(0xffd50000),
            icon: Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                ),
                label: Text(
                  'Buy',
                  style: TextStyle(
                      color: Colors.white),
                ),
          )
      );
  }
}
