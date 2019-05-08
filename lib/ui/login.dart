import 'package:flutter/material.dart';
import 'widgets/sign_in_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0.0,0.0),
      child: SignInForm(),
    );
  }
}