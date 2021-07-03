import 'package:flutter/material.dart';
import 'package:project_android/components/text_fields.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

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
                height: 300,
                child: Center(
                  child: Container(
                    color: Colors.black,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              SignUpForm()
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends InputDec {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: inputDec(label: "Name"),
          ),
          TextFormField(
            decoration: inputDec(label: "Email"),
          ),
          TextFormField(
            decoration: inputDec(label: "Password"),
            obscureText: true,
          ),
          TextFormField(
            decoration: inputDec(label: "Confirm Password"),
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
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text("Already have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  "Login",
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
