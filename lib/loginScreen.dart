import 'package:flutter/material.dart';

class ZeroScreen extends StatefulWidget {
  @override
  _ZeroScreenState createState() => _ZeroScreenState();
}

class _ZeroScreenState extends State<ZeroScreen> {
  bool _loading = false;
  String _email = '';
  String _password = '';

  void _onLoading() {
    setState(() {
      _loading = true;
      Future.delayed(Duration(seconds: 4), _login);
    });
  }

  Future _login() async {
    setState(() {
      _loading = false;
    });
    Navigator.of(context).pushReplacementNamed('/Home_screen');
  }

  @override
  Widget build(BuildContext context) {
    var body = ListView(children: <Widget>[
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
                      child: Image.asset('images/men.png'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
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
                    RaisedButton(
                      color: Colors.blue[200],
                      onPressed: _onLoading,
                      //tooltip: 'Loading',
                      child: Text('Login into account'),
                    ),
                    SizedBox(height: 5.0),
                    FlatButton(
                        child: const Text('Register'),
                        splashColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/RegisterScreen');
                        }),
                    FlatButton(
                        child: const Text('Forgot password?'),
                        splashColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/ForgotPasswordScreen');
                        }),
                  ])),
        )
      ])
    ]);

    var bodyProgress = Container(
      child: Stack(
        children: <Widget>[
          body,
          Container(
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              color: Colors.white70,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: Center(
                      child: Text(
                        "loading.. wait...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: _loading ? bodyProgress : body),
    );
  }
}

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  String _password;

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
                borderRadius: BorderRadius.circular(25),
              ),
              suffixIcon: IconButton(
                onPressed: _toggle,
                icon: (_obscureText
                    ? Icon(Icons.visibility, color: Colors.grey)
                    : Icon(Icons.visibility, color: Colors.blue)),
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
