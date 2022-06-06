import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  AuthPage({
    required this.submitForm,
    Key? key,
  }) : super(key: key);
  @override
  State<AuthPage> createState() => _AuthPageState();

  void Function(String email, String username, String password, bool isLogin)
      submitForm;
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          !_isLogin ? 'Register' : 'Login',
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!_isLogin)
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    decoration: const InputDecoration(
                      labelText: 'UserName',
                      contentPadding: EdgeInsets.symmetric(
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
                      return;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value ?? _email;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
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
                      return '';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                  obscureText: _passwordVisible ? false : true,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    !_isLogin ? 'Register' : 'Login',
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                InkWell(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
