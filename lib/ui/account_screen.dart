import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../bloc/login_bloc.dart';
import '../models/user_model.dart';
import 'package:login_program/resources/countries.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:login_program/resources/login_bloc_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login_program/ui/widgets/sign_in_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_program/resources/globals.dart' as globals;

class AccountScreen extends StatefulWidget {
  final String _emailAddress;

  AccountScreen(this._emailAddress);

  @override
  AccountScreenState createState() {
    return AccountScreenState();
  }
}

class AccountScreenState extends State<AccountScreen> {
  LoginBloc _bloc;
  String url;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showLoading = false;
  bool change = false;
  SharedPreferences sharedPreferences;
  bool sharedPreferenceFacebook;

  @override
  void initState() {
    super.initState();
    _onChanged();
  }

  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferenceFacebook = sharedPreferences.getBool("loginFacebook");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  uploadImage(var imageFile, name) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = dowurl.toString();
    return url;
  }

  Widget button(email, isAdmin, newName, password, url, name) {
    return FutureBuilder(builder: (context, snapshot) {
      if (showLoading == true) {
        return CircularProgressIndicator();
      } else {
        return ButtonTheme(
          minWidth: 350,
          height: 48.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Color(0xffd50000),
            onPressed: () {
              showLoading = true;
              setState(() {
              });
      if (change == true) {
              if (newName != null) {
                uploadImage(sampleImage, email).then((url) {
                  _bloc.UpdateUser(email, isAdmin, newName, password, url);
                  showLoading = false;
                  Navigator.of(context).pop();
                });
              } else {
                uploadImage(sampleImage, email).then((url) {
                  _bloc.UpdateUser(email, isAdmin, name, password, url);
                  showLoading = false;
                  Navigator.of(context).pop();
                });
              }}
              else{if (newName != null) {
          _bloc.UpdateUser(email, isAdmin, newName, password, url);
          showLoading = false;
          Navigator.of(context).pop();
              } else {
          _bloc.UpdateUser(email, isAdmin, name, password, url);
          showLoading = false;
          Navigator.of(context).pop();
      }}
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
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  Widget buttonFacebook(email, isAdmin, newEmail, password, url, name) {
    return FutureBuilder(builder: (context, snapshot) {
      if (showLoading == true) {
        return CircularProgressIndicator();
      } else {
        return ButtonTheme(
          minWidth: 350,
          height: 48.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Color(0xffd50000),
            onPressed: () {
              showLoading = true;
              setState(() {
              });
              if (change == true) {
                if (newEmail != null) {
                  uploadImage(sampleImage, name).then((url) {
                    _bloc.UpdateUserFacebook(newEmail, isAdmin, name, password, url);
                    showLoading = false;
                    Navigator.of(context).pop();
                  });
                } else {
                  uploadImage(sampleImage, name).then((url) {
                    _bloc.UpdateUserFacebook(email, isAdmin, name, password, url);
                    showLoading = false;
                    Navigator.of(context).pop();
                  });
                }}
              else{if (newEmail != null) {
                _bloc.UpdateUserFacebook(newEmail, isAdmin, name, password, url);
                showLoading = false;
                Navigator.of(context).pop();
              } else {
                _bloc.UpdateUserFacebook(email, isAdmin, name, password, url);
                showLoading = false;
                Navigator.of(context).pop();
              }}
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
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffd50000).withOpacity(0.78),
      body: Container(
          alignment: Alignment(0.0, 0.0),
          child: StreamBuilder(
            stream: _bloc.accountUser(widget._emailAddress),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot doc = snapshot.data;
                List<User> userList= _bloc.mapToList(doc: doc);
                if (userList.isNotEmpty) {
                  if (sharedPreferenceFacebook == false){return buildList(userList);}
                  else {return buildListFacebook(userList);}
                } }
            },
          )
//        StreamBuilder(
//            stream: _bloc.accountUser(widget._emailAddress),
//            builder:
//                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//              if (snapshot.hasData) {
//                DocumentSnapshot doc = snapshot.data;
//                List<User> userList = _bloc.mapToList(doc: doc);
//                if (userList.isNotEmpty) {
//                  return buildList(userList);
//                } else {
//                  return Text("No Goals");
//                }
//              } else {
//                return Text("No Goals");
//              }
//            }),
          ),
    );
  }

  File sampleImage;

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

  Future getUpdateImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  Future makePhoto() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      sampleImage = tempImage;
    });
  }

  String newName;
  String newEmail;

  void _settingModalBottomSheet(context) {
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
                    makePhoto();
                  },
                ),
                IconButton(
                  icon: new Icon(Icons.photo),
                  //title: new Text('Upload a photo'),
                  onPressed: () {
                    getUpdateImage();
                    //getPhoto();
                  },
                ),
              ],
            ),
          );
        });
  }

  int n = 0;

  Widget buildList(List<User> userList) {
    return ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          String email = userList[index].email;
          bool isAdmin = userList[index].isAdmin;
          String name = userList[index].name;
          String password = userList[index].password;
          url = userList[index].photo;
          if (index == 0) {
            if (n == 0) {
              if (isAdmin == true) {
                globals.admin = true;
              } else {
                globals.admin = false;
              }
            }
            n++;
            return Container(
                height: 790.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
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
                            height: 360.0,
                            alignment: AlignmentDirectional.center,
                            child: Form(
                              autovalidate: true,
                              child: Column(children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: Column(children: <Widget>[
                                      SizedBox(
                                        height: 98,
                                      ),
                                      Text('Account',
                                          style: TextStyle(
                                            color: Color(0xffd50000),
                                            fontSize: 30,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      FlatButton(child: Text(email, style: TextStyle(
                                        fontSize: 16,
                                      )),
                                          textColor: Colors.black.withOpacity(0.56),
                                          onPressed: () { _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                              duration: new Duration(seconds: 4),
                                              content:
                                              new Text("  You can not change the email")
                                          ));}),
                                      SizedBox(height: 5.0),
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: name,
                                        ),
                                        onChanged: (value) {
                                          print(value);
                                          newName = value;
                                          print(name);
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      SizedBox(height: 15.0),
                                      _DropdowButton(),
                                    ])),
                                SizedBox(
                                  height: 15,
                                ),
                                button(email, isAdmin, newName, password, url, name), //193;185
                                // SizedBox(width: 50,),
                              ]),
                            )))
                  ]),
                  Container(
                    margin: EdgeInsets.only(
                        left: 100.0, right: 100.0, top: 70.0, bottom: 30.0),
                    //padding: const EdgeInsets.all(40.0),
                    child: IconButton(
                      iconSize: 150,
                      color: Colors.red,
                      icon: updatePhotoProd(url),
                      onPressed: () {
                        change = true;
                        _settingModalBottomSheet(context);
                      },
                    ),
                  ),
                ]));
          }
        });
  }

  Widget buildListFacebook(List<User> userList) {
    return ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          String email = userList[index].email;
          bool isAdmin = userList[index].isAdmin;
          String name = userList[index].name;
          String password = userList[index].password;
          url = userList[index].photo;
          if (index == 0) {
            if (n == 0) {
              if (isAdmin == true) {
                globals.admin = true;
              } else {
                globals.admin = false;
              }
            }
            n++;
            return Container(
                height: 790.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
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
                            height: 360.0,
                            alignment: AlignmentDirectional.center,
                            child: Form(
                              autovalidate: true,
                              child: Column(children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: Column(children: <Widget>[
                                      SizedBox(
                                        height: 98,
                                      ),
                                      Text('Account',
                                          style: TextStyle(
                                            color: Color(0xffd50000),
                                            fontSize: 30,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      FlatButton(child: Text(name, style: TextStyle(
                                        fontSize: 16,
                                      )),
                                          textColor: Colors.black.withOpacity(0.56),
                                          onPressed: () { _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                              duration: new Duration(seconds: 4),
                                              content:
                                              new Text("  You can not change the name")
                                          ));}),
                                      SizedBox(height: 5.0),
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: email,
                                        ),
                                        onChanged: (value) {
                                          newEmail = value;
                                          print(newEmail);
                                        },
                                        keyboardType:
                                        TextInputType.emailAddress,
                                      ),
                                      SizedBox(height: 15.0),
                                      _DropdowButton(),
                                    ])),
                                SizedBox(
                                  height: 15,
                                ),
                                buttonFacebook(email, isAdmin, newEmail, password, url, name), //193;185
                                // SizedBox(width: 50,),
                              ]),
                            )))
                  ]),
                  Container(
                    margin: EdgeInsets.only(
                        left: 100.0, right: 100.0, top: 70.0, bottom: 30.0),
                    //padding: const EdgeInsets.all(40.0),
                    child: IconButton(
                      iconSize: 150,
                      color: Colors.red,
                      icon: updatePhotoProd(url),
                      onPressed: () {
                        change = true;
                        _settingModalBottomSheet(context);
                      },
                    ),
                  ),
                ]));
          }
        });
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
    return DropdownButton(
      isExpanded: true,
      hint: Text('Chooise'),
      items: _dropDownItems,
      value: _newCountries,
      onChanged: ((String newValue) {
        setState(() {
          _newCountries = newValue;
        });
      }),
    );
  }
}
