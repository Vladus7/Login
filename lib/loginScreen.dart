import 'package:flutter/material.dart';
import 'package:login_program/widgets/loading_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_program/home_screen.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/crud.dart';
import 'dart:io';



GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController password = TextEditingController();

  bool _obscureText = true;
  FacebookLogin fbLogin = new FacebookLogin();

  TextEditingController username = TextEditingController();
  SharedPreferences sharedPreferences;
  crudMedthods crudObj = crudMedthods();
  var user;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (error) {
      print(error);
    }
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: username.text, password: password.text);
      try {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (e) {
        print(e.message);
      }
    }
  }

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
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 40.0, bottom: 40.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //SizedBox(height: 40.0),
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
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue[50], width: 10),
                                    borderRadius: BorderRadius.circular(26.0)),
                                contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                                hintText: "username",
                                fillColor: Colors.teal[200].withOpacity(0.3),
                                filled: true,
                                labelText: 'Email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Theme(
                            data: ThemeData(
                              hintColor: Colors.lightBlue[50], //color border
                              primaryColor: Colors.lightBlue[50],
                            ),
                            child: TextFormField(
                              controller: password,
                              decoration: InputDecoration(
                                hintText: "password",
                                contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                                fillColor: Colors.teal[200].withOpacity(0.3),
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: _toggle,
                                  icon: (_obscureText
                                      ? Icon(Icons.visibility,
                                          color: Colors.teal[50])
                                      : Icon(Icons.visibility,
                                          color: Colors.red)),
                                ),
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(26.0),
                                  borderSide: BorderSide(
                                    width: 10.0,
                                    color: Colors.lightBlue[50],
                                  ),
                                ),
                                //suffixStyle: Color()
                              ),
                              obscureText: _obscureText,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          ButtonTheme(
                            minWidth: double.infinity,
                            height: 48.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(
                                      width: 1, color: Color(0xffd50000))),
                              color: Color(0xffd50000),
                              onPressed: () async {
//                                crudObj.getDataUser(username.text).then((results) {
//                                  setState(() {
//                                    user = results;
//                                  });
//                                });
                                signIn();
                                sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.setString(
                                    "username", username.text);
                                sharedPreferences.setBool(
                                    "isAdmin", false);
                              },
                              child: Text(
                                'Sign in with Email',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Row(children: <Widget>[
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5, color: Colors.white),
                                  color: Colors.white),
                            )),
                            Text(
                              'OR',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.all(
                                8.0,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5, color: Colors.white),
                                  color: Colors.white),
                            )),
                          ]),
                          Row(children: <Widget>[
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.all(8.0),
                            )),
                            IconButton(
                              iconSize: 50.0,
                              icon: Image.asset(
                                'images/google_logo2.png',
                              ),
                              onPressed: () {
                                _handleSignIn();
                              },
                            ),
                            IconButton(
                              iconSize: 50.0,
                              icon: Image.asset(
                                'images/facebook_logo.png',
                              ),
                              onPressed: () {
//                                fbLogin.logInWithReadPermissions(
//                                    ['email', 'public_profile']).then((result) {
//                                  switch (result.status) {
//                                    case FacebookLoginStatus.loggedIn:
//                                      FirebaseAuth.instance.signInWithFacebook(
//                                              accessToken:
//                                                  result.accessToken.token)
//                                          .then((signedInUser) {
//                                        print(
//                                            'Signed in as ${signedInUser.displayName}');
//                                        Navigator.of(context)
//                                            .pushReplacementNamed(
//                                                '/home_screen');
//                                      }).catchError((e) {
//                                        print(e);
//                                      });
//                                      break;
//                                    case FacebookLoginStatus.cancelledByUser:
//                                      print('Cancelled by you');
//                                      break;
//                                    case FacebookLoginStatus.error:
//                                      print('Error');
//                                      break;
//                                  }
//                                }).catchError((e) {
//                                  print(e);
//                                });
                              },
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.all(8.0),
                            )),
                          ]),
                          SizedBox(height: 5.0),
                          FlatButton(
                              child: const Text('Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                              splashColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/register_screen');
                              }),
                          FlatButton(
                              child: const Text('Forgot password?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                              splashColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/forgot_password_screen');
                              }),
                         // SizedBox(height: 40.0),
                        ]))),
          )
        ]),
      ),
    );
  }
}

