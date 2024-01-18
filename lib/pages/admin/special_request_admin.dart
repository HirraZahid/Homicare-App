import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../models/request.dart';

class SpecialRequest extends StatefulWidget {
  const SpecialRequest({super.key});

  @override
  State<SpecialRequest> createState() => _SpecialRequestState();
}

class _SpecialRequestState extends State<SpecialRequest> {
  late List<RequestModel> requests = [];
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
                doc['serviceProviderId'] == currentUserId &&
                (doc['status'] == 'specialUnknown'))
            .map((doc) {
          return RequestModel(
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
            'Inbox',
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
                                const SizedBox(width: 18.0), // Adjust spacing

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
                                              style:
                                                  DefaultTextStyle.of(context)
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
                                              style:
                                                  DefaultTextStyle.of(context)
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
                                              style:
                                                  DefaultTextStyle.of(context)
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
                                              style:
                                                  DefaultTextStyle.of(context)
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
                                              style:
                                                  DefaultTextStyle.of(context)
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
                                              style:
                                                  DefaultTextStyle.of(context)
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
                                            onPressed: () {
                                              declineRequest(context,
                                                  requests[index].requestId);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              'Decline',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .02,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              acceptUserRequest(
                                                  requests[index].requestId);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              'Accept',
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
                        'No request',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
        ),
      ],
    );
  }

  void declineRequest(BuildContext context, String requestId) async {
    try {
      // Show a CupertinoDialog for confirmation
      bool confirm = await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Confirm Decline"),
            content:
                const Text("Are you sure you want to decline this request?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, false); // User canceled
                },
                child: const Text("No"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, true); // User confirmed
                },
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference requestDoc =
            firestore.collection('requests').doc(requestId);
        DocumentSnapshot requestSnapshot = await requestDoc.get();
        await requestDoc.update({
          'status': 'decline',
          'reason': "Service Provider Decline Your Request",
          'completeTime': DateFormat('d MMMM y H:mm').format(DateTime.now()),
        });
        fetchData();
        print('Request Declined Successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.white,
            content: Text(
              "Request Declined Successfully",
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      } else {
        print('Request completion canceled by user');
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      print('Error: $e');
    }
  }

//accept Request

  void acceptUserRequest(String requestId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Handle the case where the user is not authenticated
        print('Error: User not authenticated.');
        return;
      }

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Show a confirmation dialog
      bool confirm = await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Confirm Acceptance"),
            content:
                const Text("Are you sure you want to accept this request?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, false); // User canceled
                },
                child: const Text("No"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, true); // User confirmed
                },
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        DocumentReference requestDoc =
            firestore.collection('requests').doc(requestId);

        DocumentSnapshot requestSnapshot = await requestDoc.get();
        // Update the fields in the request document
        await requestDoc.update({
          'status': 'inprogress',
        });
        fetchData();
        print('Request accepted successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.white,
            content: Text(
              "Request Accepted Successfully",
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      } else {
        print('Request acceptance canceled by user');
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      print('Error: $e');
    }
  }
}
