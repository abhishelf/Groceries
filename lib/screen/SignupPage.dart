import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:grocery/util/String.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isObscure = true;
  bool _isLoading = false;

  String _validateEmail(String email) {
    if (!EmailValidator.validate(email)) {
      return EMAIL_ERROR;
    }

    return null;
  }

  String _validatePassword(String password) {
    if (password.length < 6) {
      return PASSWORD_ERROR;
    }

    return null;
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      Timer(Duration(seconds: 5), () {
        setState(() {
          _showSnackBar(true, "Login Failed");
          _isLoading = false;
        });
      });
    }
  }
  
  void _loadLoginPage(context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.fromLTRB(22.0, 48.0, 22.0, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              SIGNUP_TITLE,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 48.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Text(
              SIGNUP_SUBTITLE,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
              ),
            ),
            Expanded(
              flex: 1,
              child: Form(
                key: _formKey,
                child: Theme(
                  data: ThemeData(
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      filled: true,
                      fillColor: Colors.white70,
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 48.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextFormField(
                          autofocus: false,
                          decoration: InputDecoration(
                            labelText: EMAIL_HINT,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          enabled: !_isLoading,
                          validator: (value) {
                            return _validateEmail(value);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        TextFormField(
                          autofocus: false,
                          decoration: InputDecoration(
                              labelText: PASSWORD_HINT,
                              suffixIcon: GestureDetector(
                                child: !_isObscure
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                onTap: () {
                                  setState(() {
                                    _isObscure
                                        ? _isObscure = false
                                        : _isObscure = true;
                                  });
                                },
                              )),
                          keyboardType: TextInputType.visiblePassword,
                          enabled: !_isLoading,
                          obscureText: _isObscure,
                          validator: (value) {
                            return _validatePassword(value);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 48.0),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: () {
                              if (_isLoading) return null;
                              return _submitForm();
                            },
                            color: _isLoading
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12.0)),
                            ),
                            child: _isLoading
                                ? Container(
                              padding:
                              EdgeInsets.symmetric(vertical: 8.0),
                              child: CircularProgressIndicator(
                                backgroundColor:
                                Theme.of(context).primaryColor,
                                strokeWidth: 2.0,
                              ),
                            )
                                : Text(SIGNUP_BUTTON),
                            height: 48.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: LOGIN_SIGNUP_BUTTON,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: LOGIN_BUTTON,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                if (_isLoading) return null;
                return _loadLoginPage(context);
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0, left: 64.0, right: 64.0),
              child: Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(bool isError, String message){
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: isError? Colors.redAccent: Colors.blueGrey,
        duration: Duration(seconds: 3),
        content: Text(message),
      ),
    );
  }
}
