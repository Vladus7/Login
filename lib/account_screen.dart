import 'package:flutter/material.dart';
import 'package:login_program/countries.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
                        Container(
                      width: 190.0,
                      height: 190.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                          image: ExactAssetImage('images/men.png'),
                        ))),
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
