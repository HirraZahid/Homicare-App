import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homicare/models/decline_request.dart';
import 'package:lottie/lottie.dart';

class DeclinedServices extends StatefulWidget {
  const DeclinedServices({super.key});

  @override
  State<DeclinedServices> createState() => _DeclinedServicesState();
}

class _DeclinedServicesState extends State<DeclinedServices> {
  late List<DeclineModel> requests = [];
  late String currentUserId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  void getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      fetchData();
    } else {
      // Handle the case where the user is not logged in
    }
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('requests').get();
      setState(() {
        requests = querySnapshot.docs
            .where((doc) =>
                doc['userId'] == currentUserId && doc['status'] == 'decline')
            .map((doc) {
          return DeclineModel(
            status: doc['status'],
            repeat: doc['repeat'],
            time: doc['time'],
            address: doc['location'],
            userId: doc['userId'],
            serviceName: doc['serviceName'],
            day: doc['day'],
            month: doc['month'],
            rooms: doc['rooms'],
            requestId: doc['requestId'],
            serviceProviderName: doc['serviceProviderName'],
            serviceProviderPhone: '',
            serviceProviderService: '',
            completeTime: doc['completeTime'],
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
          child: Text(
            'Services',
            style: TextStyle(
              fontSize: 35,
              color: Colors.grey.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? Center(
                  child: SizedBox(
                  height: 300,
                  child:
                      Lottie.asset('assets/images/loading.json', repeat: true),
                ))
              : requests.isNotEmpty
                  ? ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      var request = requests[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left side - Image
                              Image.asset(
                                'assets/images/${request.serviceName.toLowerCase()}.png',
                                width: 80,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                  width: 18.0), // Adjust spacing

                              // Right side - Text details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Service Name: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request.serviceName,
                                            style: DefaultTextStyle.of(
                                                    context)
                                                .style,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Date: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${request.day} ${request.month}",
                                            style: DefaultTextStyle.of(
                                                    context)
                                                .style,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Rooms: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request.rooms,
                                            style: DefaultTextStyle.of(
                                                    context)
                                                .style,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Address: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request.address,
                                            style: DefaultTextStyle.of(
                                                    context)
                                                .style,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Time: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request.time,
                                            style: DefaultTextStyle.of(
                                                    context)
                                                .style,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Repeat: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request.repeat,
                                            style: DefaultTextStyle.of(
                                                    context)
                                                .style,
                                          ),
                                        ],
                                      ),
                                    ),

                                    //details
                                    SizedBox(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width -
                                            50,
                                        child: const Divider()),
                                    //service provider details
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Name: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request
                                                .serviceProviderName,
                                            style: DefaultTextStyle.of(
                                                    context)
                                                .style,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Time: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request.completeTime,
                                            style: DefaultTextStyle.of(
                                                    context)
                                                .style,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Service: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request.serviceName,
                                            style: DefaultTextStyle.of(
                                                    context)
                                                .style,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        Tooltip(
                                            message:
                                            'Request declined by the service provider',
                                            child: IconButton(
                                              icon: const Icon(Icons.info),
                                              onPressed: () {showCupertinoDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CupertinoAlertDialog(
                                                    title: const Text('Oops!'),
                                                    content: const Text('Request declined by the service provider'),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                        child:const Text('OK'),
                                                        onPressed: () {
                                                          Navigator.pop(context); // Close the dialog
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              },
                                            )),
                                        const SizedBox(height: 13,),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Declined',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                  : const Center(
                      child: Text(
                        'No request was declined',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
        ),
      ],
    );
  }

  Future<void> deleteService(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .delete();
      print('Service deleted successfully');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white,
        content: Text(
          "Request has been deleted.",
          style: TextStyle(color: Colors.black),
        ),
      ));
    } catch (e) {
      print('Error deleting service: $e');
      // Handle errors as needed
    }
  }
}
