import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homicare/pages/login_page.dart';
import 'package:homicare/pages/sign_up_page.dart';
import '../models/service.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<Services> services = [
    Services('Cleaning', 'assets/images/cleaning.png'),
    Services('Plumber', 'assets/images/plumber.png'),
    Services('Electrician', 'assets/images/electrician.png'),
    Services('Painter', 'assets/images/painter.png'),
    Services('Carpenter', 'assets/images/carpenter.png'),
    Services('Gardener', 'assets/images/gardener.png'),
    Services('Tailor', 'assets/images/tailor.png'),
    Services('Maid', 'assets/images/maid.png'),
    Services('Driver', 'assets/images/driver.png'),
  ];

  int selectedService = 4;

  @override
  void initState() {
    // Randomly select from service list every 2 seconds
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        selectedService = Random().nextInt(services.length);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .14),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // aik row ma 3 box
                    childAspectRatio: 1.2,// the width is 1.2 times the height.
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,//set the spacing between items in the grid along the horizontal and vertical axes, respectively.
                  ),
                  physics: const NeverScrollableScrollPhysics(), //the grid view should not be scrollable.The content will not respond to any scroll gestures.
                  itemCount: services.length,
                  itemBuilder: (BuildContext context, int index) {
                    return serviceContainer(services[index].imageURL, services[index].name, index);
                  },
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Easy, reliable way to take \ncare of your home',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'We provide you with the best people to help take care of your home.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .9,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'L O G I N',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width* .9,
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0,right: 20,top: 5,bottom: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'S I G N U P',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedService = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25, // Adjust the width as needed
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedService == index ? Colors.white : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index ? Colors.blue.shade100 : Colors.grey.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(image, height: MediaQuery.of(context).size.width * 0.1), // Adjust the height as needed
              const SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03, // Adjust the font size as needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
