import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homicare/pages/sign_up_page.dart';
import 'package:lottie/lottie.dart';
import '../verify_email.dart';

class SignupAdmin extends StatefulWidget {
  const SignupAdmin({super.key});

  @override
  State<SignupAdmin> createState() => _SignupAdminState();
}

class _SignupAdminState extends State<SignupAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController numController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  bool userPassWrong = false;

  bool obscureText = true;

  String selectOption = 'Plumber';

  bool userEmailWrong = false;

  bool userNameWrong = false;

  bool tickMark = false;

  @override
  void dispose() {
    nameController.dispose();
    numController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var mediaQuerySize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Service Provider",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: mediaQuery.size.height * 0.02,
                // child: Lottie.asset('assets/images/login.json')
              ),
              Column(
                children: [
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: mediaQuerySize.width * 0.10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: mediaQuery.size.width * 0.03),
                  SizedBox(
                    width: mediaQuery.size.width * 0.9,
                    child: SizedBox(
                      height: 90,
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          prefixIcon: const Icon(CupertinoIcons.person),
                          labelText: 'User Name',
                          labelStyle: TextStyle(
                            fontSize: mediaQuery.size.width * 0.04,
                            color: Colors.black,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.width * 0.03),
                  SizedBox(
                    width: mediaQuery.size.width * 0.9,
                    child: SizedBox(
                      height: 90,
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value!.trim().isEmpty ||
                              !value.trim().contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: mediaQuery.size.width * 0.04,
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.width * 0.03),
                  SizedBox(
                    width: mediaQuery.size.width * 0.9,
                    child: SizedBox(
                      height: 90,
                      child: TextFormField(
                        controller: passController,
                        obscureText: obscureText,
                        validator: (value) {
                          if (value!.trim().length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelText: 'Password',
                          prefixIcon: const Icon(CupertinoIcons.lock),
                          labelStyle: TextStyle(
                            fontSize: mediaQuery.size.width * 0.04,
                            color: Colors.black,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.width * 0.03),
                  SizedBox(
                    width: mediaQuery.size.width * 0.9,
                    child: SizedBox(
                      height: 90,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: numController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        maxLength: 11,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                            fontSize: mediaQuery.size.width * 0.04,
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.add_call),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: SizedBox(
                          width: mediaQuery.size.width * 0.85,
                          height: 55,
                          child: DropdownButton<String>(
                            value: selectOption,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectOption = newValue!;
                              });
                            },
                            items: <String>[
                              'Plumber',
                              'Cleaning',
                              'Electrician',
                              'Painter',
                              'Maid'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                          )),
                    ),
                  ]),
                  SizedBox(height: mediaQuery.size.width * 0.06),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            tickMark = !tickMark;
                          });
                        },
                        child: tickMark
                            ? const Icon(CupertinoIcons.check_mark)
                            : const Icon(CupertinoIcons.square,
                                color: CupertinoColors.inactiveGray),
                      ),
                      const Text(" I've read and agree to "),
                      const Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: mediaQuery.size.width * 0.07),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (!tickMark) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title:
                                    const Text("Agree to Terms and Conditions"),
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
                        } else {
                          newUser();
                        }
                      }
                    },
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        height: mediaQuery.size.width * 0.15,
                        width: mediaQuery.size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "SIGN UP",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: mediaQuerySize.width * 0.054,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: mediaQuerySize.width * 0.08,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Create Account as Client? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Create Account",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> newUser() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from being dismissed
      builder: (context) {
        return SizedBox(
          height: 30,
          child: Lottie.asset('assets/images/loading.json', repeat: true),
        );
      },
    );

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      final User? userData = userCredential.user;

      if (userData != null) {
        await userData.updateDisplayName(nameController.text.trim());

        storeUserDataInBackend();
        // Send verification email
        await userData.sendEmailVerification();
        // Dismiss the dialog
        Navigator.pop(context);

        // Navigate to VerifyEmailPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyEmailPage(
              email: userData.email!,
            ),
          ),
        );
      }
    } catch (error) {
      String newError = error
          .toString()
          .replaceAll('[firebase_auth/email-already-in-use]', '');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          newError,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ));
    }
  }

  Future<void> storeUserDataInBackend() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        Map<String, dynamic> userDataMap = {
          "id": user.uid,
          "name": nameController.text.trim(),
          "service": selectOption,
          "averageRating": "0",
          "phone": numController.text.trim(),
          "email": emailController.text.trim(),
          "password": passController.text.trim(),
          "role": "admin",
        };

        await firestore.collection('users').doc(user.uid).set(userDataMap);

        print('User data stored in Firestore');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
