import 'package:flutter/material.dart';
import 'package:login_program/countries.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/crud.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:login_program/widgets/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_program/loginScreen.dart';
import 'package:login_program/all_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
String photo = 'images/person.jpg';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
//  Future<Null> getPhoto() async {
//    final File _photo =
//        await ImagePicker.pickImage(source: ImageSource.gallery);
//    setState(() {
//      if (_photo != null) photo = _photo.path;
//    });
//  }
//
//  Future<Null> makePhoto() async {
//    final File _photo = await ImagePicker.pickImage(source: ImageSource.camera);
//    setState(() {
//      if (_photo != null) photo = _photo.path;
//    });
//  }

//  List user;
  crudMedthods crudObj = crudMedthods();
  SharedPreferences sharedPreferences;
  String sharedPreferenceEmail;
  bool sharedPreferenceisAdmin;

  @override
  void initState() {
    crudObj.getDataUser().then((results) {
      setState(() {
        users = results;
      });
    });
    super.initState();
    _onChanged();
  }

  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferenceEmail = sharedPreferences.getString("username");
      sharedPreferenceisAdmin = sharedPreferences.getBool("isAdmin");
    });
  }

  showAdmins(data) {
    if (sharedPreferenceisAdmin == true) {
      crudObj.UpdateUserData({
        'email': data['email'],
        'isAdmin': true,
        'Name' : data['Name'],
        'photo': data['photo'],
      }).catchError((e) {
        print(e);
      });
      return new Text('Admin account',
          style: TextStyle(
            color: Color(0xffd50000),
            fontSize: 20,
          ));
    } else
      crudObj.UpdateUserData({
        'email': data['email'],
        'isAdmin': false,
        'Name' : data['Name'],
        'photo': data['photo'],
      }).catchError((e) {
        print(e);
      });
      return new Text('User account',
          style: TextStyle(
            color: Color(0xffd50000),
            fontSize: 20,
          ));
  }

  bool _value1 = false;
  bool _value2 = false;

  void _onChanged1(bool value) => setState(() => _value1 = value);

  void _onChanged2(bool value) => setState(() => _value2 = value);
  QuerySnapshot users;

  Widget acount() {
    if (users != null) {
      return ListView.builder(
        itemCount: users.documents.length,
        //padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i) {
          if (users.documents[i].data['email'] == sharedPreferenceEmail) {
            return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.indigo.withOpacity(0.95), BlendMode.dstATop),
                    image: AssetImage("images/background5.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(children: <Widget>[
                  Column(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 154.0, bottom: 20.0),
                        //padding: const EdgeInsets.all(40.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[500].withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20.0)),
                            width: 350.0,
                            height: 590.0,
                            alignment: AlignmentDirectional.center,
                            child: Form(
                              autovalidate: true,
                              child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: Column(children: <Widget>[
                                          SizedBox(
                                            height: 110,
                                          ),
                                          FlatButton(
                                              child: showAdmins(users
                                                  .documents[i].data),
                                              splashColor: Colors.white,
                                              onPressed: () async {
                                                sharedPreferences =
                                                    await SharedPreferences
                                                        .getInstance();
                                                sharedPreferences.setBool(
                                                    "isAdmin", true);
                                                Navigator.of(context).pushNamed(
                                                    '/account_screen');
                                              }),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                              //filled: true,
                                              fillColor: Colors.white,
                                              labelText: users
                                                  .documents[i].data['email'],
                                            ),
                                            onChanged: (value) {
                                              users.documents[i].data['email'] = value;
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                          SizedBox(height: 5.0),
                                          TextField(
                                            decoration: InputDecoration(
                                              // filled: true,
                                              //fillColor: Colors.white,
                                              labelText: users
                                                  .documents[i].data['Name'],
                                            ),
                                            // onSaved: name,
                                            onChanged: (value) {
                                              users.documents[i].data['Name'] = value;
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                          SizedBox(height: 15.0),
                                          _DropdowButton(),
                                        ])),
                                    SizedBox(
                                      height: 193,
                                    ), //193;185
                                    ButtonTheme(
                                      minWidth: 350,
                                      height: 48.0,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        color: Color(0xffd50000),
                                        onPressed: () {
                                          crudObj.UpdateUserData({
                                            'email':users
                                                .documents[i].data['email'],
                                            'isAdmin': users
                                                .documents[i].data['isAdmin'],
                                            'Name' : users
                                                .documents[i].data['Name'],
                                            'photo': users
                                                .documents[i].data['photo'],
                                          }).catchError((e) {
                                            print(e);
                                          });
                                          Navigator.of(context)
                                              .pushNamed('/home_screen');
                                        },
                                        child: Row(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            SizedBox(
                                              width: 120,
                                            ),
                                            Icon(
                                              Icons.save,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ), // SizedBox(width: 50,),
                                  ]),
                            )))
                  ]),
                  Container(
                      margin: EdgeInsets.only(
                          left: 100.0, right: 100.0, top: 70.0, bottom: 30.0),
                      //padding: const EdgeInsets.all(40.0),
                      child: Stack(children: <Widget>[
                        IconButton(
                          iconSize: 150,
                          color: Colors.red,
                          icon: updatePhotoProd(users.documents[i].data['photo']),
                          onPressed: () {
                            _settingModalBottomSheet(context, users.documents[i].data);
                          },
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: 125.0, top: 105.0, bottom: 10.0),
                            child:
                            IconButton(
                              icon: Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () async{
                                var name = users.documents[i].data['email'];
                                final StorageReference firebaseStorageRef =
                                FirebaseStorage.instance.ref().child(name);
                                final StorageUploadTask task =
                                firebaseStorageRef.putFile(sampleImage);
                                final ref = FirebaseStorage.instance.ref().child(name);
                                users.documents[i].data['photo'] = await ref.getDownloadURL();;
                              },
                            )),
                      ]),
//                      IconButton(
//                        iconSize: 175,
//                        color: Colors.red,
//                        icon: CircleAvatar(
//                          backgroundImage: ExactAssetImage(photo),
//                          radius: 125,
//                        ),
//                        onPressed: () {
//                          _settingModalBottomSheet(context);
//                        },
//                      )
                  ),
                ]));
          };
        },
      );
    } else {
      return LoadingIndicator();
    }
  }

  File sampleImage;
  updatePhotoProd(photo) {
    if (sampleImage != null) {
      return CircleAvatar(
        backgroundImage:FileImage(sampleImage),
        radius: 125,
      );
    } else
      return CircleAvatar(
        backgroundImage: NetworkImage(photo),
        radius: 125,
      );
  }
  Future getUpdateImage(data) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }
  Future makePhoto(data) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      sampleImage = tempImage;
    });
  }

  void _settingModalBottomSheet(context, data) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  // title: new Text('Make a photo'),
                  onPressed: () {
                    makePhoto(data);
                  },
                ),
                IconButton(
                  icon: new Icon(Icons.photo),
                  //title: new Text('Upload a photo'),
                  onPressed: () {
                    getUpdateImage(data);
                    //getPhoto();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: acount(),
      // appBar: AppBar(title: Text('Your account')),
//      body: ListView(children: <Widget>[
//        Container(
//            decoration: BoxDecoration(
//              image: DecorationImage(
//                colorFilter: ColorFilter.mode(
//                    Colors.indigo.withOpacity(0.95), BlendMode.dstATop),
//                image: AssetImage("images/background5.jpg"),
//                fit: BoxFit.cover,
//              ),
//            ),
//            child: acount()
//        )
//      ]),
    );
  }
}

class _DropdowButton extends StatefulWidget {
  @override
  __DropdowButtonState createState() => __DropdowButtonState();
}

class __DropdowButtonState extends State<_DropdowButton> {
  static const menuItems = countriesList;

  final List<DropdownMenuItem<String>> _dropDownItems = menuItems
      .map(
        (String CountruValue) => DropdownMenuItem<String>(
              value: CountruValue,
              child: Text(CountruValue),
            ),
      )
      .toList();
  String _newCountries;

  @override
  Widget build(BuildContext context) {
    return
//      Container(padding: EdgeInsets.all(0),child: Column(
//        children: <Widget>[
        DropdownButton(
      isExpanded: true,
      hint: Text('Chooise'),
      items: _dropDownItems,
      value: _newCountries,
      onChanged: ((String newValue) {
        setState(() {
          _newCountries = newValue;
        });
      }),
      //)
      //]
      //)
    );
  }
}
