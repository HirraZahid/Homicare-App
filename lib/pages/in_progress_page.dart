import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homicare/models/in_progress_request.dart';
import 'package:lottie/lottie.dart';

class InProgressPage extends StatefulWidget {
  const InProgressPage({super.key});

  @override
  State<InProgressPage> createState() => _InProgressPageState();
}

class _InProgressPageState extends State<InProgressPage> {
  late List<InProgressModel> requests = [];
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
                doc['userId'] == currentUserId && doc['status'] == 'inprogress')
            .map((doc) {
          return InProgressModel(
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
            serviceProviderPhone: doc['serviceProviderPhone'],
            serviceProviderService: doc['serviceProviderService'],
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
            'In Progress Services',
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
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width -50,
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
                                            text: request.serviceProviderName,
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
                                            text: 'Phone: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request.serviceProviderPhone,
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
                                            text: 'Speciality: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request.serviceProviderService,
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
                                            'In Progress',
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
                        'No request in progress',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
        ),
      ],
    );
  }
}
