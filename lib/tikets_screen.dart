import 'package:flutter/material.dart';
import 'package:login_program/widgets/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/crud.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

//List cart;
class TicketsScreen extends StatefulWidget {
  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  SharedPreferences sharedPreferences;
  bool sharedPreferenceIsAdmin;
  String sharedPreferenceUser;

  File sampleImage;
  String product;
  String description;
  String photoUrl;
  String price;
  String ticketId;

  QuerySnapshot tickets;
  crudMedthods crudObj = crudMedthods();

  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferenceUser = sharedPreferences.getString("username");
      sharedPreferenceIsAdmin = sharedPreferences.getBool("isAdmin");
    });
  }

  @override
  void initState() {
    crudObj.getDataTickets().then((results) {
      setState(() {
        tickets = results;
      });
    });
    super.initState();
    _onChanged();
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
      addDialog(context);
    });
  }

  Future getUpdateImage(data) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
      uploadDialog(context, data);
    });
  }

  photoProd() {
    if (sampleImage != null) {
      return CircleAvatar(
        backgroundImage: FileImage(sampleImage),
        radius: 125,
      );
    } else
      return CircleAvatar(
        backgroundImage: ExactAssetImage('images/painting.jpg'),
        radius: 125,
      );
  }

  screenController() {
    if (sharedPreferenceIsAdmin == true) {
      return _ticketsAdminList();
    } else
      return _ticketsUserList();
  }

  floatingActionsButtonControler() {
    if (sharedPreferenceIsAdmin == true) {
      return FloatingActionButton(
        onPressed: () {
          addDialog(context);
        },
        backgroundColor: Color(0xffd50000),
        mini: false,
        child: Icon(Icons.add),
      );
    } else
      return null;
  }

  updatePhotoProd(photo) {
    if (sampleImage != null) {
      return CircleAvatar(
        backgroundImage: FileImage(sampleImage),
        radius: 125,
      );
    } else
      return CircleAvatar(
        backgroundImage: NetworkImage(photo),
        radius: 125,
      );
  }

  Future getUrl(name) async {
    final ref = FirebaseStorage.instance.ref().child(name);
    this.photoUrl = await ref.getDownloadURL();
  }

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text('Add Tiket', style: TextStyle(fontSize: 15.0)),
              //content:
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(children: <Widget>[
                      IconButton(
                        iconSize: 150,
                        color: Colors.red,
                        icon: photoProd(),
                        onPressed: () {
                          getImage();
                        },
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: 125.0, top: 105.0, bottom: 10.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 30,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              //String name;
                              var name = this.product; //wordPair.asPascalCase;
                              final StorageReference firebaseStorageRef =
                                  FirebaseStorage.instance.ref().child(name);
                              final StorageUploadTask task =
                                  firebaseStorageRef.putFile(sampleImage);
                              getUrl(name);
                            },
                          )),
                    ]),
                    Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(children: <Widget>[
                          TextField(
                            decoration:
                                InputDecoration(hintText: 'Enter product Name'),
                            onChanged: (value) {
                              this.product = value;
                            },
                          ),
                          SizedBox(height: 5.0),
                          TextField(
                            decoration:
                                InputDecoration(hintText: 'Enter description'),
                            onChanged: (value) {
                              this.description = value;
                            },
                          ),
                          SizedBox(height: 5.0),
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Enter product price'),
                            onChanged: (value) {
                              this.price = value;
                            },
                          ),
                        ])),
                    FlatButton(
                      child: Text('Add'),
                      textColor: Color(0xffd50000),
                      onPressed: () {
                        sampleImage = null;
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        crudObj.addData({
                          'productName': this.product,
                          'description': this.description,
                          'photoUrl': this.photoUrl,
                          'price': this.price,
                        }).catchError((e) {
                          print(e);
                        });
                      },
                    )
                  ],
                ),
              ]);
        });
  }

  Future<bool> uploadDialog(BuildContext context, data) async {
    this.product = data['productName'];
    this.description = data['description'];
    this.price = data['price'];
    this.photoUrl = data['photoUrl'];
    //sampleImage = null;
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text('Update Tiket', style: TextStyle(fontSize: 15.0)),
              //content:
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(children: <Widget>[
                      IconButton(
                        iconSize: 150,
                        color: Colors.red,
                        icon: updatePhotoProd(data['photoUrl']),
                        onPressed: () {
                          //data['photoUrl'] = null;
                          getUpdateImage(data);
                        },
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: 125.0, top: 105.0, bottom: 10.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 30,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              //String name;
                              var name = this.product; //wordPair.asPascalCase;
                              final StorageReference firebaseStorageRef =
                                  FirebaseStorage.instance.ref().child(name);
                              final StorageUploadTask task =
                                  firebaseStorageRef.putFile(sampleImage);
                              getUrl(name);
                            },
                          )),
                    ]),
                    Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(children: <Widget>[
                          TextField(
                            decoration: InputDecoration(hintText: this.product),
                            onChanged: (value) {
                              this.product = value;
                            },
                          ),
                          SizedBox(height: 5.0),
                          TextField(
                            decoration:
                                InputDecoration(hintText: this.description),
                            onChanged: (value) {
                              this.description = value;
                            },
                          ),
                          SizedBox(height: 5.0),
                          TextField(
                            decoration: InputDecoration(hintText: this.price),
                            onChanged: (value) {
                              this.price = value;
                            },
                          ),
                        ])),
                    FlatButton(
                      child: Text('Update'),
                      textColor: Color(0xffd50000),
                      onPressed: () {
                        sampleImage = null;
                        crudObj.UpdateData({
                          'productName': this.product,
                          'description': this.description,
                          'photoUrl': this.photoUrl,
                          'price': this.price,
                        }).catchError((e) {
                          print(e);
                        });
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => TicketsScreen()));
                      },
                    )
                  ],
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffd50000).withOpacity(0.78),
        //Colors.red[900].withOpacity(0.7),
        // Colors.pink[100],
        //Color(0xffff1744),
        body: DefaultTabController(
          length: 7,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    backgroundColor: Colors.grey[900].withOpacity(0.89),
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text("Ticets",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            )),
                        background: Image.asset(
                          "images/silverappbar.jpg",
                          fit: BoxFit.cover,
                        )),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          crudObj.getDataTickets().then((results) {
                            setState(() {
                              tickets = results;
                            });
                          });
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
              ];
            },
            body: screenController(),
          ),
        ),
        floatingActionButton: floatingActionsButtonControler());
  }


  Widget _ticketsUserList() {
    if (tickets != null) {
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: tickets.documents.length,
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
                          child: Text(tickets.documents[i].data['productName'],
                              style: TextStyle(color: Colors.white)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40.0),
                          child: Text(tickets.documents[i].data['description'],
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
                              tickets.documents[i].data['price'],
                              style: TextStyle(color: Colors.black),
                            )),
                      ]),
                      Container(
                          margin: EdgeInsets.only(
                            left: 10.0,
                            right: 5.0,
                            top: 10.0,
                            bottom: 10.0,
                          ),
                          //padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                          child: Column(children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.clear, color: Colors.white),
                              onPressed: () {
                                crudObj.DelateData(tickets.documents[i].data);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                              onPressed: () {
                                crudObj.addGoods(
                                tickets.documents[i].data, sharedPreferenceUser,
                                ).catchError((e) {
                                  print(e);
                                });
                                //print(it);
//                                ListTile lt = ListTile(
//                                  leading: CircleAvatar(
//                                    backgroundImage:
//                                    NetworkImage(tickets.documents[i].data['photoUrl']),
//                                    radius: 50,
//                                  ),
//                                    title: Text(tickets.documents[i].data['productName'],
//                                        style: TextStyle(color: Colors.white)),
//                                subtitle: Text(tickets.documents[i].data['description'],
//                                    style: TextStyle(color: Colors.white)),
//                                trailing: Container(
//                                    margin: EdgeInsets.only(
//                                        left: 200.0, top: 45.0, bottom: 10.0),
//                                    decoration: BoxDecoration(
//                                        color: Color(0xffd50000).withOpacity(0.78),
//                                        borderRadius: BorderRadius.circular(3.0)),
//                                    width: 60.0,
//                                    height: 30.0,
//                                    alignment: AlignmentDirectional.center,
//                                    child: Text(
//                                      tickets.documents[i].data['price'],
//                                      style: TextStyle(color: Colors.black),
//                                    )),);
//                                cart.add(it);
                              },
                            ),
                          ])),
//                      Container(
//                        margin: EdgeInsets.only(
//                          left: 10.0,
//                          right: 5.0,
//                          top: 3.0,
//                          bottom: 80.0,
//                        ),
//                        //padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
//                        child: IconButton(
//                          icon: Icon(Icons.clear, color: Colors.white),
//                          onPressed: () {
//                            crudObj.DelateData(tickets.documents[i].data);
//                          },
//                        ),
//                      ),
                    ])
                    //)
                    ),
                Padding(
                    padding: EdgeInsets.only(top: 12.5),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(tickets.documents[i].data['photoUrl']),
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

  Widget _ticketsAdminList() {
    if (tickets != null) {
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: tickets.documents.length,
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
                          child: Text(tickets.documents[i].data['productName'],
                              style: TextStyle(color: Colors.white)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40.0),
                          child: Text(tickets.documents[i].data['description'],
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
                              tickets.documents[i].data['price'],
                              style: TextStyle(color: Colors.black),
                            )),
                      ]),
                      Container(
                          margin: EdgeInsets.only(
                            left: 10.0,
                            right: 5.0,
                            top: 10.0,
                            bottom: 10.0,
                          ),
                          //padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                          child: Column(children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.create,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                uploadDialog(
                                    context, tickets.documents[i].data);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                crudObj.DelateData(tickets.documents[i].data);
                              },
                            ),
                          ])),
                    ])
                    //)
                    ),
                Padding(
                    padding: EdgeInsets.only(top: 12.5),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(tickets.documents[i].data['photoUrl']),
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
}
//
//Future<List<ListTile>> getCart() async {
//
//  List<ListTile> listTiles = [];
//
//  for (var i in cart) {
//      ListTile lt = ListTile(
//        leading: CircleAvatar(
//          backgroundImage:
//          NetworkImage(i['photoUrl']),
//          radius: 50,
//        ),
//        title: Text(i['productName'],
//            style: TextStyle(color: Colors.white)),
//        subtitle: Text(i['description'],
//            style: TextStyle(color: Colors.white)),
//        trailing: Container(
//            margin: EdgeInsets.only(
//                left: 200.0, top: 45.0, bottom: 10.0),
//            decoration: BoxDecoration(
//                color: Color(0xffd50000).withOpacity(0.78),
//                borderRadius: BorderRadius.circular(3.0)),
//            width: 60.0,
//            height: 30.0,
//            alignment: AlignmentDirectional.center,
//            child: Text(
//              i['price'],
//              style: TextStyle(color: Colors.black),
//            )),);
//      listTiles.add(lt);
//    }
//
//  return listTiles;
//}