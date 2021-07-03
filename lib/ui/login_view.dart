import 'package:flutter/material.dart';
import 'package:project_android/components/text_fields.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),

        // height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 500,
                child: Center(
                  child: Container(
                    color: Colors.black,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              LoginForm()
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends InputDec {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: inputDec(label: "Email"),
          ),
          TextFormField(
            decoration: inputDec(label: "Password"),
            obscureText: true,
          ),
          SizedBox(height: 50),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.black),
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text("Don't have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
