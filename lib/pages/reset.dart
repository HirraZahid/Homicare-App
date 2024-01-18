import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mediaQuerySize.height * 0.5,
              child: Lottie.asset('assets/images/reset.json'),
            ),
            SizedBox(
              width: mediaQuerySize.width * 0.9,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 100,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Invalid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: mediaQuerySize.width * 0.04,
                            color: Colors.black,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: mediaQuerySize.height * 0.1),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          resetPassword(emailController.text.trim());
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 2, color: Colors.black),
                        ),
                        alignment: Alignment.center,
                        height: mediaQuerySize.width * 0.15,
                        width: mediaQuerySize.width * 0.9,
                        child: Text(
                          "RESET PASSWORD",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: mediaQuerySize.width * 0.054,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Password Reset Email Sent"),
            content: const Text(
                "A password reset email has been sent to your email address. Please follow the instructions in the email to reset your password."),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Pop twice to go back to the login page
                },
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An undefined error occurred";
      if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found with that email address';
      }
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(errorMessage),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
