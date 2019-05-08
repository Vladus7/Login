import 'package:flutter/material.dart';
import '../bloc/tiket_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_program/resources/tikets_provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UploadTiketScreen extends StatefulWidget {
  final String name;
  final String description;
  final String photoUrl;
  final String cost;

  UploadTiketScreen(this.name, this.description, this.photoUrl, this.cost);

  @override
  UploadTiketState createState() {
    return UploadTiketState();
  }
}

class UploadTiketState extends State<UploadTiketScreen> {
  GoodsBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController myController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController productName = TextEditingController();
  File sampleImage;
  String url;
  String newDescription;
  String newCost;
  bool change = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = GoodsBlocProvider.of(context);
  }

  @override
  void dispose() {
    myController.dispose();
    priceController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, false);
    return Future.value(false);
  }

  Future getUpdateImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
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

  uploadImage(var imageFile, name) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = dowurl.toString();
    return url;
  }

  void showMessage() {
    final snackbar = SnackBar(
        content: Text('You can not change the name of the goods'),
        duration: new Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.name;
    String description = widget.description;
    url = widget.photoUrl;
    String cost = widget.cost;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            "Upload Tiket",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xffd50000),
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment(0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    SizedBox(
                      width: 95,
                    ),
                    IconButton(
                      iconSize: 150,
                      color: Colors.red,
                      icon: updatePhotoProd(url),
                      onPressed: () {
                        change = true;
                        //data['photoUrl'] = null;
                        getUpdateImage();
                        setState(() {});
                      },
                    ),
                  ]),
                  Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(children: <Widget>[
                        FlatButton(
                            child: Text(name,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                            textColor: Colors.black.withOpacity(0.56),
                            onPressed: () {
                              _scaffoldKey.currentState.showSnackBar(
                                  new SnackBar(
                                      duration: new Duration(seconds: 4),
                                      content: new Text(
                                          "  You can not change the email")));
                            }),
//                        TextField(
//                          decoration: InputDecoration(hintText: name),
//                          onChanged: (value) {
//                            name = value;
//                          },
//                        ),
                        SizedBox(height: 5.0),
                        TextField(
                          decoration: InputDecoration(hintText: description),
                          onChanged: (value) {
                            newDescription = value;
                            //description = value;
                          },
                        ),
                        SizedBox(height: 5.0),
                        TextField(
                          decoration: InputDecoration(hintText: cost),
                          onChanged: (value) {
                            newCost = value;
                          },
                        ),
                      ])),
                  FlatButton(
                      child: Text('Update'),
                      textColor: Color(0xffd50000),
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          duration: new Duration(seconds: 4),
                          content: new Row(
                            children: <Widget>[
                              new CircularProgressIndicator(),
                              new Text("  Loading...")
                            ],
                          ),
                        ));
                        if (change == true) {
                          if (newDescription != null) {
                            if (newCost != null) {
                              uploadImage(sampleImage, name).then((url) {
                                _bloc.UpdateData(
                                    name, newDescription, url, newCost);
                                Navigator.of(context).pop();
                              });
                            } else {
                              uploadImage(sampleImage, name).then((url) {
                                _bloc.UpdateData(
                                    name, newDescription, url, cost);
                                Navigator.of(context).pop();
                              });
                            }
                          } else {
                            if (newCost != null) {
                              uploadImage(sampleImage, name).then((url) {
                                _bloc.UpdateData(
                                    name, description, url, newCost);
                                Navigator.of(context).pop();
                              });
                            } else {
                              uploadImage(sampleImage, name).then((url) {
                                _bloc.UpdateData(name, description, url, cost);
                                Navigator.of(context).pop();
                              });
                            }
                          }
                        } else {
                          if (newDescription != null) {
                            if (newCost != null) {
                              _bloc.UpdateData(
                                  name, newDescription, url, newCost);
                              Navigator.of(context).pop();
                            } else {
                              _bloc.UpdateData(name, newDescription, url, cost);
                              Navigator.of(context).pop();
                            }
                          } else {
                            if (newCost != null) {
                              _bloc.UpdateData(name, description, url, newCost);
                              Navigator.of(context).pop();
                            } else {
                              _bloc.UpdateData(name, description, url, cost);
                              Navigator.of(context).pop();
                            }
                          }
                        }
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  photoProd() {
    if (sampleImage != null) {
      return CircleAvatar(
        backgroundImage: FileImage(sampleImage),
        radius: 125,
      );
    } else
      return CircleAvatar(
        backgroundImage: NetworkImage(widget.photoUrl),
        radius: 125,
      );
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }
}
