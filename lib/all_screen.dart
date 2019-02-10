import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_program/loginScreen.dart';
import 'package:login_program/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  CircleAvatar(
                      backgroundImage: ExactAssetImage(
                        'images/person.jpg',
                      ),
                      radius: 100),
                  Theme(
                    data: ThemeData(
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
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => _email = input,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Theme(
                    data: ThemeData(
                      primaryColor: Colors.redAccent,
                    ),
                    child: TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                        hintText: "password",
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
                  SizedBox(height: 5.0),
                  ButtonTheme(
                    minWidth: double.infinity,
                    height: 55.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(width: 1, color: Colors.black)),
                      color: Colors.white,
                      onPressed: () //{
                          async {
                        sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString("username", username.text);
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
          ),
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
