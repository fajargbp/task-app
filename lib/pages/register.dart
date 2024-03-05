import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:task_app/controllers/auth_controller.dart';
import 'package:task_app/pages/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;

  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Page")),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  // email = value;
                  authController.email.value = value;
                  //Do something with the user input.
                }),
            SizedBox(
              height: 8.0,
            ),
            TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  // password = value;
                  authController.password.value = value;
                  //Do something with the user input.
                }),
            SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: authController.email.string,
                      password: authController.password.string);
                  if (newUser != null) {
                    // Navigator.pushNamed(context, 'login');
                    authController.email.value = '';
                    authController.password.value = '';
                    Get.off(LoginPage());
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                  // print(e);
                }
                setState(() {
                  showSpinner = false;
                });
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
