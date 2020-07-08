import 'package:afqyapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(children: <Widget>[
            Text(
              'To reset your password, please enter the email address that you registered with.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              'If the supplied email is found, you will be sent an email with a link to reset your password.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Email",
              ),
              validator: (val) {
                if (!isEmail(val)) {
                  return "Please enter a valid email";
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  _email = val;
                });
              },
            ),
            SizedBox(height: 20.0),
            Builder(
              builder: (context) => RaisedButton(
                child: Text('Reset'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    AuthService.resetPassword(_email).then((result) {
                      final snackBar =
                          SnackBar(content: Text('Password reset email sent'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }).catchError((error) {
                      final snackBar = SnackBar(
                          content: Text('Password reset email not sent, your email may not exist.'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    });
                  }
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
