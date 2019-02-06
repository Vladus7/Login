import 'package:flutter/material.dart';
import 'package:login_program/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_program/home_screen.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  SharedPreferences sharedPreferences;
  bool _obscureText = true;

//  @override
//  void initState() {
//    super.initState();
//    getCredential();
//  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

//  getCredential() async {
//    sharedPreferences = await SharedPreferences.getInstance();
//    setState(() {
//      checkValue = sharedPreferences.getBool("check");
//      if (checkValue != null) {
//        if (checkValue) {
//          username.text = sharedPreferences.getString("username");
//          password.text = sharedPreferences.getString("password");
//
//        } else {
//          username.clear();
//          password.clear();
//          sharedPreferences.clear();
//        }
//      } else {
//        checkValue = false;
//      }
//    });
//  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
    } catch (error) {
      print(error);
    }
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeScreen()));
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
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                          backgroundImage: ExactAssetImage(
                            'images/person.jpg',
                          ),
                          radius: 100),
          Theme(
              data: new ThemeData(
                primaryColor: Colors.redAccent,
              ),
                  child: TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(32)),
                      hintText: "username",
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Email',
                    ),
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please enter email';
                      }
                    },
                    //controller: myController,
                    keyboardType: TextInputType.emailAddress,
                  ),),
                  SizedBox(height: 5.0),
          Theme(
              data: new ThemeData(
                primaryColor: Colors.redAccent,
              ),
              child:
              TextFormField(
                     controller: password,
                      decoration: InputDecoration(
                        hintText: "password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide(
                            width: 5, color: Colors.black,),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _toggle,
                          icon: (_obscureText
                              ? Icon(Icons.visibility, color: Colors.grey)
                              : Icon(Icons.visibility, color: Colors.red)),
                        ),
                        labelText: 'Password',
                        //suffixStyle: Color()
                      ),
                      obscureText: _obscureText,
                    ),),
                  SizedBox(height: 5.0),
                  ButtonTheme(
                    minWidth: double.infinity,
                    height: 55.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          side: BorderSide(width: 1, color: Colors.black)),
                      color: Colors.white,
                      onPressed: () async {
                        signIn();
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("username", username.text);},
                      child: Text(
                        'Sign in with Email',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ButtonTheme(
                    minWidth: double.infinity,
                    height: 55.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          side: BorderSide(width: 1, color: Colors.red)),
                      color: Colors.white,
    onPressed:
    _handleSignIn,
//        (){ _signInGoogle().then((FirebaseUser user){
//    print(user);
//    }).catchError((onError){
//    print(onError);
//    });}
                    //    Navigator.of(context).pushReplacementNamed('/home_screen');
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  FlatButton(
                      child: const Text(
                        'Register',
                      ),
                      splashColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/register_screen');
                      }),
                  FlatButton(
                      child: const Text(
                        'Forgot password?',
                      ),
                      splashColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/forgot_password_screen');
                      }),
                ])),
          )
        ]),
      ),
    );
  }
}
