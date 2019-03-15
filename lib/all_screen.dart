import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_program/loginScreen.dart';
import 'package:login_program/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/crud.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class ShareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Screen"),
        ),
        body: Text('Go back!'));
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  SharedPreferences sharedPreferences;
  bool _obscureText = true;
  crudMedthods crudObj = crudMedthods();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String _email, _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(children: <Widget>[
          Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.indigo.withOpacity(0.95), BlendMode.dstATop),
                  image: AssetImage("images/background4.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Form(
                key: _formKey,
                autovalidate: true,
                child: Container(
                  margin: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 40.0, bottom: 130.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Image.asset(
                        'images/logo10.png',
                        width: 250,
                        height: 250,
                      ),
                      SizedBox(height: 80.0),
                      Theme(
                        data: ThemeData(
                          hintColor: Colors.lightBlue[50],
                          //color border
                          primaryColor: Colors.lightBlue[50],
                          // click form color
                          accentColor: Colors.lightBlue[50],
                          // color |
                          scaffoldBackgroundColor: Colors.lightBlue,
                          primaryColorDark: Colors.lightBlue[50],
                        ),
                        child: TextFormField(
                          controller: username,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(32)),
                            hintText: "username",
                            fillColor: Colors.teal[200].withOpacity(0.3),
                            filled: true,
                            labelText: 'Email',
                          ),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please enter email';
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => this._email = input,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Theme(
                        data: ThemeData(
                          hintColor: Colors.lightBlue[50],
                          //color border
                          primaryColor: Colors.lightBlue[50],
                          // click form color
                          accentColor: Colors.lightBlue[50],
                          // color |
                          scaffoldBackgroundColor: Colors.lightBlue,
                          primaryColorDark: Colors.lightBlue[50],
                        ),
                        child: TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            hintText: "password",
                            fillColor: Colors.teal[200].withOpacity(0.3),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: BorderSide(
                                width: 5,
                                color: Colors.black,
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: _toggle,
                              icon: (_obscureText
                                  ? Icon(Icons.visibility, color: Colors.grey)
                                  : Icon(Icons.visibility, color: Colors.red)),
                            ),
                            labelText: 'Password',
                          ),
                          onSaved: (input) => _password = input,
                          obscureText: _obscureText,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      ButtonTheme(
                        minWidth: double.infinity,
                        height: 48.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  width: 1, color: Color(0xffd50000))),
                          color: Color(0xffd50000),
                          onPressed: () //{
                              async {
                                crudObj.addUserData({
                                  'email': username.text,
                                  'isAdmin': false,
                                  'Name' : 'Please enter Name',
                                  'photo': 'https://firebasestorage.googleapis.com/v0/b/massive-current-230014.appspot.com/o/person.jpg?alt=media&token=e6375cac-8cc0-4ccb-8fe1-d76610f7a939',
                                }).catchError((e) {
                                  print(e);
                                });
                            sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                "username", username.text);
                                sharedPreferences.setBool(
                                    "isAdmin", false);
                            signUp();
                          },
                          child: Text(
                            'Sign in with Email',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ]),
      ),
    );
  }

  void signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Forgot password")), body: Text('Go back!'));
  }
}
