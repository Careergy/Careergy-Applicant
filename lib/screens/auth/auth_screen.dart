import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  canvasColor,
                  primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Image.asset('assets/images/logo.png',
                        height: 180, width: 180),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
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

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'phone': ''
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
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
        await Provider.of<AuthProvider>(context, listen: false).login(
          _authData['email'] ?? '',
          _authData['password'] ?? '',
        );
      } else {
        // Sign user up
        await Provider.of<AuthProvider>(context, listen: false).signup(
          _authData['email'] ?? '',
          _authData['password'] ?? '',
          _authData['phone'] ?? '',
          _authData['name'] ?? '',
        );
      }
    } on Exception catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      color: accentPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? deviceSize.height * 0.90 : 260,
        width: deviceSize.width * 0.90,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: _authMode == AuthMode.Signup
                  ? <Widget>[
                      TextFormField(
                        style: const TextStyle(color: white),
                        cursorColor: white,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          icon: Icon(
                            Icons.person,
                            color: white,
                          ),
                          labelStyle: TextStyle(color: Colors.white70),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white),
                          ),
                        ),
                        onSaved: (value) {
                          _authData['name'] = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.length < 2) {
                            return 'Name is too short!';
                          }
                        },
                      ),
                      TextFormField(
                        style: const TextStyle(color: white),
                        cursorColor: white,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          icon: Icon(
                            Icons.phone,
                            color: white,
                          ),
                          labelStyle: TextStyle(color: Colors.white70),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          _authData['phone'] = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.length < 10) {
                            return 'Invalid phone number!';
                          }
                        },
                      ),
                      TextFormField(
                        style: const TextStyle(color: white),
                        cursorColor: white,
                        decoration: const InputDecoration(
                          labelText: 'E-Mail',
                          icon: Icon(
                            Icons.email,
                            color: white,
                          ),
                          labelStyle: TextStyle(color: Colors.white70),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },
                      ),
                      TextFormField(
                        style: const TextStyle(color: white),
                        cursorColor: white,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          icon: Icon(
                            Icons.password,
                            color: white,
                          ),
                          labelStyle: TextStyle(color: Colors.white70),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white),
                          ),
                        ),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 2) {
                            return 'Password is too short!';
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value!;
                        },
                      ),
                      if (_authMode == AuthMode.Signup)
                        TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          style: const TextStyle(color: white),
                          cursorColor: white,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            icon: Icon(
                              Icons.password,
                              color: white,
                            ),
                            labelStyle: TextStyle(color: Colors.white70),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: white),
                            ),
                          ),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _submit,
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 8.0),
                            ),
                          ),
                          child: Text(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                            style: const TextStyle(color: white),
                          ),
                        ),
                      TextButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                            '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                            style: TextStyle(color: Colors.white70)),
                      ),
                    ]
                  : <Widget>[
                      TextFormField(
                        style: const TextStyle(color: white),
                        cursorColor: white,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          icon: Icon(
                            Icons.email,
                            color: white,
                          ),
                          labelStyle: TextStyle(color: Colors.white70),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },
                      ),
                      TextFormField(
                        style: const TextStyle(color: white),
                        cursorColor: white,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          icon: Icon(
                            Icons.password,
                            color: white,
                          ),
                          labelStyle: TextStyle(color: Colors.white70),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: white),
                          ),
                        ),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 2) {
                            return 'Password is too short!';
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value!;
                        },
                      ),
                      if (_authMode == AuthMode.Signup)
                        TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _submit,
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 8.0),
                            ),
                          ),
                          child: Text(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                            style: const TextStyle(color: white),
                          ),
                        ),
                      TextButton(
                        onPressed: _switchAuthMode,
                        style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 4))),
                        // textColor: Theme.of(context).canvasColor,
                        child: Text(
                          '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
