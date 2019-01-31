import 'package:flutter/material.dart';
import 'package:login_program/loading_screen.dart';

String email = '';
String password = '';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
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
                        child: CircleAvatar(
                            backgroundImage: ExactAssetImage(
                              'images/person.jpg',
                            ),
                            radius: 100)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
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
                    PasswordField(),
                    SizedBox(height: 5.0),
                    ButtonTheme(
                      minWidth: 330.0,
                      height: 50.0,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),side: BorderSide(width: 2, color: Colors.black)),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/home_screen');
                        },
                        child: Text('Sign in with Email',style: TextStyle(
    fontSize: 20,
    ),),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    ButtonTheme(
                      minWidth: 330.0,
                      height: 50.0,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),side: BorderSide(width: 2, color: Colors.red)),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/home_screen');
                        },
                        child: Text('Sign in with Google',style: TextStyle(color: Colors.red,
                            fontSize: 20,
                    ),),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    FlatButton(
                        child: const Text('Register',),
                        splashColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register_screen');
                        }),
                    FlatButton(
                        child: const Text('Forgot password?',
                        ),
                        splashColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/forgot_password_screen');
                        }),
                  ])),
        )
      ])
    ]));
  }
}

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              suffixIcon: IconButton(
                onPressed: _toggle,
                icon: (_obscureText
                    ? Icon(Icons.visibility, color: Colors.grey)
                    : Icon(Icons.visibility, color: Colors.red)),
              ),
              labelText: 'Password',
            ),
            obscureText: _obscureText,
          ),
        ),
      ],
    );
  }
}
