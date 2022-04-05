import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';
import '../shared/validators.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _opacityAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              title: Text('An error occured'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('OK'))
              ],
            ));
  }

  void _submit() async {
    if (!(_formKey.currentState!.validate())) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).signIn(_authData['email']!, _authData['password']!);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signUp(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      String errorMessage = 'Authentication failed.';
      if (error.message.contains('EMAIL_EXISTS')) {
        errorMessage = 'This email is already in use';
      } else if (error.message.contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.message.contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too week';
      } else if (error.message.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      }
      _showErrorDialog(errorMessage);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      const errorMessage = 'Could not authenticate you, please try again later.';
      _showErrorDialog(errorMessage);
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
            height: _authMode == AuthMode.Signup ? 320 : 260,
            constraints: BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
            width: deviceSize.width * 0.75,
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        String? errorMessage;
                        if (Validators.email(value)) {
                          errorMessage = 'Email is not correct!';
                        }
                        return errorMessage;
                      },
                      onSaved: (value) {
                        _authData['email'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        String? errorMessage;
                        if (Validators.minLength(value, 5)) {
                          errorMessage = 'Password is too short!';
                        }
                        return errorMessage;
                      },
                      onSaved: (value) {
                        _authData['password'] = value!;
                      },
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                          minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                          maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                      curve: Curves.easeIn,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                            enabled: _authMode == AuthMode.Signup,
                            decoration: InputDecoration(labelText: 'Confirm Password'),
                            obscureText: true,
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match!';
                                    }
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      ElevatedButton(
                        child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                          primary: Theme.of(context).primaryColor,
                          textStyle: TextStyle(color: Theme.of(context).primaryTextTheme.button?.color),
                        ),
                      ),
                    TextButton(
                      child: Text('${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                      onPressed: _switchAuthMode,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                        textStyle: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
