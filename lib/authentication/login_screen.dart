import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kami_saiyo_admin_panel/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String adminEmail = '';
  String adminPassword = '';

  allowAdminToLogin() async {
    SnackBar snackBar = const SnackBar(
      content: Text(
        'Checking Credentials, Please wait...',
        style: TextStyle(
          fontSize: 36,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.yellow,
      duration: Duration(
        seconds: 6,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    User? currentAdmin;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: adminEmail,
      password: adminPassword,
    )
        .then((fAuth) {
      //success
      currentAdmin = fAuth.user;
    }).catchError((onError) {
      //in case of error
      //display error message
      final snackBar = SnackBar(
        content: Text(
          'Error Occured: ' + onError.toString(),
          style: const TextStyle(
            fontSize: 36,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow,
        duration: const Duration(
          seconds: 5,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    if (currentAdmin != null) {
      //check if that admin record also exists in the admins collection in Firestore database
      await FirebaseFirestore.instance
          .collection('admin')
          .doc(currentAdmin!.uid)
          .get()
          .then(((snap) {
        if (snap.exists) {
          Navigator.pushReplacementNamed(context, MainScreen.routeName);
        } else {
          SnackBar snackBar = const SnackBar(
            content: Text(
              'No record found, you are not an admin...',
              style: TextStyle(
                fontSize: 36,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.purpleAccent,
            duration: Duration(
              seconds: 6,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/logo_ks.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  BorderedText(
                    strokeWidth: 4.0,
                    strokeColor: Color.fromARGB(255, 188, 31, 20),
                    child: Text(
                      'LOGIN ADMIN',
                      style: GoogleFonts.aclonica(
                          textStyle: TextStyle(
                        letterSpacing: 2,
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  TextField(
                    onChanged: (value) {
                      adminEmail = value;
                    },
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 188, 31, 20),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 5, 8, 113),
                          width: 2,
                        ),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 188, 31, 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //pasword textfield
                  TextField(
                    onChanged: (value) {
                      adminPassword = value;
                    },
                    obscureText: true,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 188, 31, 20),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 5, 8, 113),
                          width: 2,
                        ),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.admin_panel_settings,
                        color: Color.fromARGB(255, 188, 31, 20),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //button login
                  ElevatedButton(
                    onPressed: () {
                      allowAdminToLogin();
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 20)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 188, 31, 20),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 188, 31, 20),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
