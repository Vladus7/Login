import 'package:flutter/material.dart';
import '../bloc/tiket_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_program/resources/tikets_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

class AddGoalScreen extends StatefulWidget {
  final String _emailAddress;

  AddGoalScreen(this._emailAddress);

  @override
  AddGoalsState createState() {
    return AddGoalsState();
  }
}

class AddGoalsState extends State<AddGoalScreen> {
  GoodsBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController myController = TextEditingController();
  TextEditingController productName = TextEditingController();
  File sampleImage;
  String url;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = GoodsBlocProvider.of(context);
  }

  @override
  void dispose() {
    myController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  //Handing back press
  Future<bool> _onWillPop() {
    Navigator.pop(context, false);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(

          title: Text(
            "Add Tiket",
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
              Row(children: <Widget>[SizedBox(width: 95,),photo()],),
              Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
              nameField(),
              Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
              goalField(),
              Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
              priceField(),
              Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
              buttons(),
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
        backgroundImage: ExactAssetImage('images/painting.jpg'),
        radius: 125,
      );
  }



//  loadPhoto(name) async
//  {
//    final StorageReference firebaseStorageRef =
//    FirebaseStorage.instance.ref().child(name);
//    final StorageUploadTask task =
//    firebaseStorageRef.putFile(sampleImage);
//    return sampleImage;
//  }

  uploadImage(var imageFile, name ) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = dowurl.toString();
    return url;
  }
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }
//
//  Future getUrl(name) async
//  {
//    final ref = FirebaseStorage.instance.ref().child(name);
//    await loadPhoto(name);
//   // StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//    //var changePhoto = Uri.parse(await ref.getDownloadURL() as String);
//    //StorageTaskSnapshot storageTaskSnapshot = await loadPhoto(name).onComplete;
//    changePhoto = await await loadPhoto(name).onCompletref.getDownloadURL();
//    print(changePhoto);
//    return changePhoto;
//  }

  Widget photo() {
    return
      IconButton(
        iconSize: 150,
        color: Colors.red,
        icon: photoProd(),
        onPressed: () {
          getImage();
          setState(() {});
        },
      );
  }

  Widget nameField() {
    return StreamBuilder(
        stream: _bloc.name,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            controller: productName,
            onChanged: _bloc.changeName,
            decoration: InputDecoration(
                hintText: "Enter name", errorText: snapshot.error),
          );
        });
  }

  Widget goalField() {
    return StreamBuilder(
        stream: _bloc.goalMessage,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          myController.value = myController.value.copyWith(text: snapshot.data);
          return TextField(
            controller: myController,
            keyboardType: TextInputType.multiline,
            // maxLines: 3,
            onChanged: _bloc.changeGoalMessage,
            decoration: InputDecoration(
                hintText: "Enter your goal here", errorText: snapshot.error),
          );
        });
  }

  Widget priceField() {
    return StreamBuilder(
        stream: _bloc.price,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _bloc.changePrice,
            decoration: InputDecoration(
                hintText: "Enter price", errorText: snapshot.error),
          );
        });
  }

  Widget buttons() {
    return StreamBuilder(
        stream: _bloc.showProgress,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                submitButton(),
                Container(margin: EdgeInsets.only(left: 5.0, right: 5.0)),
              ],
            );
          } else {
            if (!snapshot.data) {
              //hide progress bar
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  submitButton(),
                  Container(margin: EdgeInsets.only(left: 5.0, right: 5.0)),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }
        });
  }

  Widget submitButton() {
    final name = productName.text;
    return RaisedButton(
        textColor: Colors.white,
        color: Color(0xffd50000),
        child: Text("Add"),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(duration: new Duration(seconds: 4), content:
              new Row(
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Text("  loading...")
                ],
              ),
              ));
      uploadImage(sampleImage, name).then((url){
    _bloc.submit(url);
    Navigator.of(context).pop();});
        });}
  }

