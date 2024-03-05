import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/controllers/auth_controller.dart';
import 'package:task_app/pages/home.dart';
import 'package:task_app/pages/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

final _auth = FirebaseAuth.instance;

// Define a corresponding State class.
// This class holds data related to the form.
class _LoginPageState extends State<LoginPage> {
  final GetStorage _getStorage = GetStorage();
  AuthController authController = Get.put(AuthController());
  String email = '';
  String password = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Login Page")),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      onChanged: (value) {
                        authController.email.value = value;
                        //Do something with the user input.
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      onChanged: (value) {
                        // password = value;
                        authController.password.value = value;
                        //Do something with the user input.
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: authController.email.string,
                              password: authController.password.string);
                          if (user != null) {
                            _getStorage.write("userId", user.user?.uid);
                            // Navigator.pushNamed(context, 'register');
                            Get.off(HomePage());
                          }
                        } catch (e) {
                          // SnackBar(content: Text(e.printError()));
                          print(e);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: const Text('Login'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, 'register');
                        Get.to(RegisterPage());
                      },
                      child: const Text('Register'),
                    ),
                  ),
                ])));
  }
}
