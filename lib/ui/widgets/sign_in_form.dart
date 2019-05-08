import '../../utils/string.dart';
import 'package:flutter/material.dart';
import '../../resources/login_bloc_provider.dart';
import '../home_screen.dart';
import 'package:login_program/ui/register.dart';
import 'package:login_program/ui/widgets/loading_indicator.dart';
import 'package:login_program/ui/forgot_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:login_program/models/user_model.dart';


class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  LoginBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn _gSignIn = new GoogleSignIn();
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  bool _obscureText = true;
  SharedPreferences sharedPreferences;
  bool sharedPreferenceLoginGoogle;
  bool sharedPreference;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    _onChanged();
  }

  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferenceLoginGoogle = sharedPreferences.getBool("loginGoogle");
      sharedPreference = sharedPreferences.getBool("login");
    });
  }

  Future<FirebaseUser> _signIn(BuildContext context) async {
    final FacebookLoginResult result =
    await facebookSignIn.logInWithReadPermissions(['email', 'public_profile']);

    FirebaseUser user =
    await _fAuth.signInWithFacebook(accessToken: result.accessToken.token);
    //Token: ${accessToken.token}

    ProviderDetails userInfo = new ProviderDetails(
        user.providerId, user.uid, user.displayName, user.photoUrl, user.email);

    List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(userInfo);

    UserInfoDetails userInfoDetails = new UserInfoDetails(
        user.providerId,
        user.uid,
        user.displayName,
        user.photoUrl,
        user.email,
        user.isAnonymous,
        user.isEmailVerified,
        providerData);
    if (sharedPreference == false){
    _bloc.registerUserWithFacebook(user.email, user.uid, user.displayName, user.photoUrl);}
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        "login", true);
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) =>HomeScreen(userInfoDetails.displayName),
      ),
    );

    return user;
  }

  Future<FirebaseUser> _signInGoogle(BuildContext context) async {

    GoogleSignInAccount googleSignInAccount = await _gSignIn.signIn();
    GoogleSignInAuthentication authentication =
    await googleSignInAccount.authentication;


    final FacebookLoginResult result =
    await facebookSignIn.logInWithReadPermissions(['email', 'public_profile']);

    FirebaseUser user = await _fAuth.signInWithGoogle(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);

    UserInfoGoogleDetails userInfo = new UserInfoGoogleDetails(
        user.providerId, user.displayName, user.email, user.photoUrl, user.uid);

    List<UserInfoGoogleDetails> providerData = new List<UserInfoGoogleDetails>();
    providerData.add(userInfo);

    UserGoogleDetails Googledetails = new UserGoogleDetails(
        user.providerId,
        user.uid,
        user.displayName,
        user.photoUrl,
        user.email,
        user.isAnonymous,
        user.isEmailVerified,
        providerData);
    if (sharedPreferenceLoginGoogle == false){
    _bloc.registerUserWithGoogle(user.email, user.uid, user.displayName, user.photoUrl);}
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        "loginGoogle", true);
    sharedPreferences.setBool(
        "loginFacebook", false);
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => HomeScreen(user.email,),
      ),
    );
    return user;
  }


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
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        body: Material(
        child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "images/background4.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
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
                submitButton(),
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
                    onPressed: () => _signInGoogle(context)
                          .then((FirebaseUser user) => print(user))
                          .catchError((e) => print(e)),
//                    //},
                  ),
                  IconButton(
                    iconSize: 50.0,
                    icon: Image.asset(
                      'images/facebook_logo.png',
                    ),
                    onPressed: () =>
                        _signIn(context)
                        .then((FirebaseUser user) => print(user))
//                        .catchError((e) => print(e)),
                    //login(),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => RegisterForm()));
                    }),
                FlatButton(
                    child: const Text('Forgot password?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                    splashColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()));
                    }),
              ],
            )))));
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
                  child:TextField(
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
                    hintText: StringConstant.emailHint,
                    errorText: snapshot.error),
              ));
        });
  }

  Widget submitButton() {
    return StreamBuilder(
        stream: _bloc.signInStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (showLoading == false) {
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
              side: BorderSide(width: 1, color: Color(0xffd50000))),
          color: Color(0xffd50000),
          onPressed: () {
            _scaffoldKey.currentState.showSnackBar(
                new SnackBar(duration: new Duration(seconds: 4), content:
                new Row(
                  children: <Widget>[
                    new CircularProgressIndicator(),
                    new Text("  Signing-In...")
                  ],
                ),
                ));
            if (_bloc.validateFields()) {
              authenticateUser();
            } else {
              showErrorMessage();
            }
          },
          child: Text(
            'Sign in',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ));}


  void authenticateUser() async{
    showLoading = true;
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        "loginFacebook", false);
    _bloc.submit().then((value) {
        _bloc.signIn();try {
          showLoading = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(_bloc.emailAddress)));
        } catch (e) {
          print(e.message);
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
