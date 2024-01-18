import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homicare/pages/admin/home_editor_admin.dart';
import 'package:homicare/pages/reset.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({
    super.key,
  });

  @override
  State<LoginAdmin> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginAdmin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _obscureText = true;
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
        centerTitle: true,
        title: const Text(
          "Service Provider",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: CupertinoColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mediaQuerySize.height * 0.25,
              child: Lottie.asset('assets/images/login.json'),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Row(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Please sign in to continue',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: mediaQuerySize.width * 0.91,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              prefixIcon: const Icon(Icons.email),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontSize: mediaQuerySize.width * 0.04,
                                color: Colors.black,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: mediaQuerySize.width * 0.03),
                        SizedBox(
                          height: 90,
                          child: TextFormField(
                            controller: passController,
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: mediaQuerySize.width * 0.04,
                                color: Colors.black,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (c) =>
                                            const ResetPasswordPage()));
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuerySize.height * 0.035,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      loginUserAdmin(context, emailController, passController);
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "LOGIN",
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
                SizedBox(height: mediaQuerySize.width * 0.035),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: SizedBox(
                        height: mediaQuerySize.width * 0.12,
                        width: 50,
                        child: SizedBox.square(
                          child: Image.asset(
                            'assets/images/google.png',
                            // Replace with the path to your Google icon
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mediaQuerySize.height * .014,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void loginUserAdmin(context, emailController, passController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BuildContext? dialogContext;

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return SizedBox(
            height: 30,
            child: Lottie.asset('assets/images/loading.json', repeat: true),
          );
        },
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      User? userData = userCredential.user;

      if (!context.mounted) return;

      if (userData != null) {
        // Check if the user's email is verified
        if (userData.emailVerified) {
          // Fetch user role based on uid
          String userUid = userData.uid;
          String userRole = await fetchUserRoleFromBackend(userUid);
          // Get FCM token
          String? fcmToken = await FirebaseMessaging.instance.getToken();

          // Store FCM token in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userData.uid)
              .update({
            'fcmToken': fcmToken,
          });

          Navigator.pop(dialogContext!);

          if (userRole == "admin") {
            // User is an admin, navigate to home page
            prefs.setBool("loggedIn", true);
            prefs.setBool("isAdmin", true);
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => const MyHomePageAdmin()),
              (route) => false,
            );
          } else {
            // User is not an admin, show Cupertino dialog
            await showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text('Login as a client!'),
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
        } else {
          await userData.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'A verification email has been sent to your account',
              style: TextStyle(color: CupertinoColors.white),
            ),
          ));
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      print(e.toString());
      Navigator.pop(dialogContext!); // Dismiss the dialog
      String errorMessage = "An undefined error occurred";
      if (e.code == 'user-disabled') {
        errorMessage = 'User has been disabled';
      } else if (e.code == 'too-many-requests') {
        errorMessage =
            'Too many unsuccessful login attempts. Please try again later.';
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        errorMessage = 'Invalid email or password';
      } else {
        print('here is error');
        print(e);
        errorMessage = 'Invalid email or password';
      }
      await showCupertinoDialog(
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


  // Function to sign in with Google
  Future<void> signInWithGoogle() async {
    BuildContext? dialogContext;

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return SizedBox(
            height: 30,
            child: Lottie.asset('assets/images/loading.json', repeat: true),
          );
        },
      );

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Navigator.pop(dialogContext!);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? userData = userCredential.user;

      if (userData != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("loggedIn", true);
        prefs.setBool('isAdmin', true);

        String userRole = await fetchUserRoleFromBackend(userData.uid);

        Navigator.pop(dialogContext!);

        if (userRole == "admin" || userRole.isEmpty) {
          // Get FCM token
          String? fcmToken = await FirebaseMessaging.instance.getToken();

          // Store FCM token in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userData.uid)
              .set({
            'name': userData.displayName,
            'email': userData.email,
            'id': userData.uid,
            'role': 'admin',
            'fcmToken': fcmToken,
          },SetOptions(merge: true));

          // User is an admin, navigate to admin home page
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => const MyHomePageAdmin()),
                (route) => false,
          );
        } else {
          // User is not an admin, show Cupertino dialog
          await showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Login as a Client'),
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
    } catch (e) {
      print(e.toString());
    }
  }


  Future<String> fetchUserRoleFromBackend(String uid) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      DocumentSnapshot userSnapshot = await users.doc(uid).get();

      // Check if the user exists
      if (userSnapshot.exists) {
        // Retrieve the 'role' field from the user document
        String userRole = userSnapshot['role'];

        // Return the user role
        return userRole;
      } else {
        // User document not found
        print("User document not found for UID: $uid");
        return "client"; // Default role for non-existent user (replace with appropriate default)
      }
    } catch (e) {
      print("Error fetching user role: $e");
      return "client"; // Default role in case of an error (replace with appropriate default)
    }
  }
}
