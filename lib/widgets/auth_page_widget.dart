import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthPage extends StatefulWidget {
  AuthPage({
    required this.submitForm,
    Key? key,
  }) : super(key: key);
  @override
  State<AuthPage> createState() => _AuthPageState();

  void Function(String email, String username, String password, bool isLogin,
      BuildContext ctx) submitForm;
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = false;
  var _email = '';
  var _username = '';
  var _password = '';
  var _passwordVisible = false;

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitForm(
        _email.trim(),
        _username.trim(),
        _password.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          !_isLogin ? 'Register' : 'Login',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            margin: const EdgeInsets.only(top: 100),
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    _isLogin ? 'Welcome' : 'Welcome back',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    !_isLogin ? 'Register your account' : 'Sign in to continue',
                    style: const TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: <Widget>[
                        if (!_isLogin)
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            key: const ValueKey('username'),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'Enter valid Username please';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _username = value!;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: !_isLogin ? 'User Name' : 'Email',
                              hintStyle: const TextStyle(
                                fontSize: 13,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'User Name',
                              labelStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                            ),
                          ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          key: const ValueKey('Email'),
                          validator: (value) {
                            _email = value!;
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value ?? _email;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              fontSize: 13,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                          ),
                          // controller: !_isLogin ? _emailController : null,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          key: const ValueKey('Password'),
                          // controller: !_isLogin ? _passwordController : null,
                          validator: (value) {
                            _password = value!;
                            if (value.isEmpty || value.length < 7) {
                              return 'Enter valid password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                          obscureText: _passwordVisible ? false : true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            suffixIcon: IconButton(
                              icon: _passwordVisible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    _passwordVisible = !_passwordVisible;
                                  },
                                );
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                                !_isLogin ? Size(width, 35) : Size(width, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            !_isLogin ? 'Register' : 'Login',
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            child: Text(
                              !_isLogin ? 'Login Instead' : 'SignUp',
                            ),
                            onHover: (_) {
                              // when hover show finger
                            },
                            onTap: () {
                              setState(
                                () {
                                  _isLogin = !_isLogin;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
