import 'package:flutter/material.dart';
import 'package:login_program/ui/account_screen.dart';
import 'package:login_program/ui/about_us_screens.dart';
import 'package:login_program/ui/auth_screen.dart';
import 'package:login_program/ui/forgot_password_screen.dart';
import 'package:login_program/ui/share_screen.dart';
import 'ui/login.dart';
import 'resources/tikets_provider.dart';
import 'package:login_program/ui/register.dart';
import 'resources/login_bloc_provider.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: LoginBlocProvider(
        child: GoodsBlocProvider(
          child: MaterialApp(
            theme: ThemeData(
              accentColor: Color(0xffd50000),
              primarySwatch: Colors.red,
            ),
            home: Scaffold(
              resizeToAvoidBottomPadding: false,
              body: AuthScreen(),
            ),
          ),
        ),
      ),
      //AuthScreen(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: <String, WidgetBuilder>{
        //'/login_screen': (BuildContext context) => LoginScreen(),
        //'/home_screen': (BuildContext context) => HomeScreen(),
        '/share_screen': (BuildContext context) => ShareScreen(),
        //'/account_screen': (BuildContext context) => AccountScreen(),
        //'/register_screen': (BuildContext context) => RegisterForm(),
        '/forgot_password_screen': (BuildContext context) =>
            ForgotPasswordScreen(),
        '/us_screen': (BuildContext context) => UsScreen(),
        '/map_screen': (BuildContext context) => MapScreen(),
      },
    );
  }
}
