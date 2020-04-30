import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/modal/Profile.dart';
import 'package:grocery/util/MyNaigator.dart';
import 'package:grocery/util/String.dart';

class LoginPage extends StatefulWidget {
  final List<Grocery> grocery;
  final Profile profile;

  LoginPage({Key key,this.grocery, this.profile}): super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKeyLocal = GlobalKey<FormState>();

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

  // TODO _forgotPassword _submitForm
  void _forgotPassword(BuildContext context) {
    Navigator.pop(context);
    setState(() {
      _isLoading = true;
    });
    Timer(Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
        _showSnackBar(false, "Check Mail For Further Process");
      });
    });
  }

  void _submitForm(context) {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      Timer(Duration(seconds: 5), () {
        setState(() {
          _showSnackBar(true, "Login Failed");
          MyNavigator.goToHomePage(context,widget.grocery,widget.profile);
          _isLoading = false;
        });
      });
    }
  }

  void _loadSignUpPage(context) {
    MyNavigator.goToSignUpPage(context);
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
              LOGIN_TITLE,
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
              LOGIN_SUB_TITLE,
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
                          padding: EdgeInsets.only(top: 12.0),
                        ),
                        GestureDetector(
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              FORGOT_PASSWORD,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16.0),
                            ),
                          ),
                          onTap: () {
                            if (_isLoading) return null;
                            return _showForgotPassword(context);
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
                              return _submitForm(context);
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
                                : Text(LOGIN_BUTTON),
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
                      text: SIGNUP_LOGIN_BUTTON,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: SIGNUP_BUTTON,
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
                return _loadSignUpPage(context);
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

  void _showForgotPassword(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0)),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        builder: (cont) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: _formKeyLocal,
                    child: Theme(
                      data: ThemeData(
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          filled: true,
                          fillColor: Colors.black12,
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 32.0),
                          ),
                          TextFormField(
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: EMAIL_HINT,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              return _validateEmail(value);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 32.0),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              if (_formKeyLocal.currentState.validate()) {
                                _forgotPassword(context);
                              }
                            },
                            child:Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
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
