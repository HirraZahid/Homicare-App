import 'package:flutter/material.dart';
import 'package:homicare/pages/declined_services.dart';
import 'completed_page.dart';
import 'home.dart';
import 'home_services.dart';
import 'in_progress_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    HomeServices(),
    DeclinedServices(),
    InProgressPage(),
    CompletedPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Services',
              icon: Icon(Icons.book_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Declined',
              icon: Icon(Icons.cancel),
            ),
            BottomNavigationBarItem(
              label: 'In Progress',
              icon: Icon(Icons.timer),
            ),
            BottomNavigationBarItem(
              label: 'Completed',
              icon: Icon(Icons.notes),
            ),
          ],
        ),
      ),
    );
  }
}
