import 'package:flutter/material.dart';
import 'package:login_program/countries.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

String photo = 'images/men.png';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Future<Null>  getPhoto() async {
    final File _photo = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (_photo != null) photo = _photo.path;
    });
  }
  Future<Null> makePhoto() async {
    final File _photo = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (_photo != null) photo = _photo.path;
    });
  }

  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  // title: new Text('Make a photo'),
                  onPressed: () {makePhoto();},
                ),
                IconButton(
                  icon: new Icon(Icons.photo),
                  //title: new Text('Upload a photo'),
                  onPressed: () {getPhoto();},
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Your account')),
        body:ListView(children: <Widget>[
          Column(children: <Widget>[
            Container(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                  autovalidate: true,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          iconSize: 200,
                          icon: CircleAvatar(
                            backgroundImage: ExactAssetImage(photo),
                            radius: 125,
                          ),
                          onPressed: () {_settingModalBottomSheet(context);
                          },),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter email';
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Name',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Name';
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 7.0),
                        _DropdowButton(),
                      ])),
            )
          ])
        ]),floatingActionButton: FloatingActionButton.extended(
      backgroundColor: Colors.red,
      onPressed: () {
        Navigator.of(context).pushNamed('/home_screen');
      },
      icon: Icon(Icons.save),
      label: Text('Save'),

    ),);
  }
}



class _DropdowButton extends StatefulWidget {
  @override
  __DropdowButtonState createState() => __DropdowButtonState();
}

class __DropdowButtonState extends State<_DropdowButton> {
  static const menuItems = countriesList;

  final List<DropdownMenuItem<String>> _dropDownItems = menuItems
      .map((String CountruValue) => DropdownMenuItem<String>(
    value : CountruValue,
    child: Text(CountruValue),
  ),
  ).toList();
  String _newCountries;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          DropdownButton(
            hint: Text('Chooise'),
            items: _dropDownItems,
            value: _newCountries,
            onChanged: ((String newValue){
              setState((){
                _newCountries = newValue;
              });
            }),
          ),
        ]
    );
  }
}
