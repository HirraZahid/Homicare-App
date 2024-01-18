import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/service.dart';
import 'select_rooms.dart';

class SelectService extends StatefulWidget {
  const SelectService({Key? key}) : super(key: key);

  @override
  State<SelectService> createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  List<Services> services = [
    Services('Cleaning', 'assets/images/cleaning.png'),
    Services('Plumber', 'assets/images/plumber.png'),
    Services('Electrician', 'assets/images/electrician.png'),
    Services('Painter', 'assets/images/painter.png'),
    Services('Maid', 'assets/images/maid.png'),
  ];

  int selectedService = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      floatingActionButton: selectedService >= 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SelectRooms(
                      serviceName: services[selectedService].name,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.arrow_forward_ios, size: 20),
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                child: Text(
                  'Which service \ndo you need?',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  itemBuilder: (BuildContext context, int index) {
                    return serviceContainer(
                      services[index].imageURL,
                      services[index].name,
                      index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedService == index) {
            selectedService = -1;
          } else {
            selectedService = index;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selectedService == index
              ? Colors.blue.shade50
              : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index
                ? Colors.blue
                : Colors.blue.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: services[index].name,
                child: Image.asset(image, height: 80),
              ),
              const SizedBox(height: 20),
              Text(name, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
