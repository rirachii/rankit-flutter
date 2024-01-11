import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class LoginScreen extends StatefulWidget {
  final SupabaseClient client;

  LoginScreen({required this.client});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _submitForm() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (_isLogin) {
      final response =
          await widget.client.auth.signIn(email: email, password: password);

      if (response.error == null) {
        final user = response.data?.user;
        if (user?.emailConfirmedAt == null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Email Verification Required'),
              content: Text('Please verify your email before logging in.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          Navigator.pushNamed(context, '/home');
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Login Error!",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(response.error!.message),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      final response = await widget.client.auth.signUp(email, password);

      if (response.error == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Account Created'),
            content: Text(
                'Your account has been created successfully. Please verify your email.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "SignUp Error!",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(response.error!.message),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              ElevatedButton(
                child: Text(_isLogin ? 'Login' : 'Sign Up'),
                onPressed: _submitForm,
              ),
              TextButton(
                child: Text(_isLogin
                    ? 'Create new account'
                    : 'Already have an account?'),
                onPressed: _toggleForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
