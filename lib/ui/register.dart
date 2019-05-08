import '../utils/string.dart';
import 'package:flutter/material.dart';
import '../resources/login_bloc_provider.dart';
import 'home_screen.dart';



class RegisterForm extends StatefulWidget {
  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  LoginBloc _bloc;
  bool _obscureText = true;

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

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background4.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
            margin: EdgeInsets.only(
                left: 10.0, right: 10.0),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20.0),
                Image.asset(
                  'images/logo10.png',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 20.0),
                emailField(),
                Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
                passwordField(),
                Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
                submitButton()
              ],
            ))));
  }

  Widget passwordField() {
    return StreamBuilder(
        stream: _bloc.password,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Theme(
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
              child: TextField(
                onChanged: _bloc.changePassword,
                obscureText: _obscureText,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: _toggle,
                      icon: (_obscureText
                          ? Icon(Icons.visibility, color: Colors.grey)
                          : Icon(Icons.visibility, color: Colors.red)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 17.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(32)),
                    fillColor: Colors.teal[200].withOpacity(0.3),
                    filled: true,
                    hintText: StringConstant.passwordHint,
                    errorText: snapshot.error),
              ));
        });
  }

  Widget emailField() {
    return StreamBuilder(
        stream: _bloc.email,
        builder: (context, snapshot) {
          return Theme(
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
              child: TextField(

                onChanged: _bloc.changeEmail,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 17.0),
                    fillColor: Colors.teal[200].withOpacity(0.3),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(32)),
                    hintText: StringConstant.emailHint, errorText: snapshot.error),
              ));
        });
  }

  Widget submitButton() {
    return StreamBuilder(
        stream: _bloc.signInStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return button();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget button() {
    return ButtonTheme(
        minWidth: double.infinity,
        height: 48.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(
                  width: 1, color: Color(0xffd50000))),
          color: Color(0xffd50000),
          onPressed: () {
            if (_bloc.validateFields()) {
              authenticateUser();
            } else {
              showErrorMessage();
            }
          },
          child: Text(
            'Registration',
            style: TextStyle(
              fontSize: 20,
            ),
          ),));
  }

  void authenticateUser() {
    _bloc.showProgressBar(true);
    _bloc.submit().then((value) {
      if (value == 0) {
        //New User
        _bloc.registerUser();
        _bloc.registerAuthUser();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(_bloc.emailAddress)));

      } else {
        //Already registered
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(_bloc.emailAddress)));
      }
    });
  }

  void showErrorMessage() {
    final snackbar = SnackBar(
        content: Text(StringConstant.errorMessage),
        duration: new Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}