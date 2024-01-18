import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homicare/pages/select_rooms.dart';
import 'package:homicare/pages/select_service.dart';
import 'package:homicare/pages/start.dart';
import 'package:homicare/pages/view_service_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/high_rating.dart';
import '../models/recent_service_provider.dart';
import '../models/service.dart';
import 'full_picture.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName = '';
  String? photoUrl = '';
  String? userId = '';
  List<RecentServiceProvider> model = [];
  List<MostRateServiceProvider> mostRatedUsers = [];

  Future<void> fetchMostRecentCompletedServiceProvider() async {
    try {
      CollectionReference requestsCollection =
          FirebaseFirestore.instance.collection('requests');
      User? user = FirebaseAuth.instance.currentUser;
      String? clientId = user?.uid;

      QuerySnapshot querySnapshot = await requestsCollection
          .where('userId', isEqualTo: clientId)
          .where('completeTime', isNotEqualTo: '')
          .orderBy('completeTime', descending: true)
          .limit(1)
          .get();

      // Extract the data from the query result
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic>? mostRecentRequestData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;

        setState(() {
          if (mostRecentRequestData != null &&
              mostRecentRequestData.containsKey('serviceProviderName') &&
              mostRecentRequestData.containsKey('serviceProviderPhone') &&
              mostRecentRequestData.containsKey('serviceProviderService')) {
            String servicePId = mostRecentRequestData['serviceProviderId'];
            print(servicePId);
            fetchServiceProviderRating(servicePId);

            model.add(RecentServiceProvider(
              serviceProviderName: mostRecentRequestData['serviceProviderName'],
              serviceProviderPhone:
                  mostRecentRequestData['serviceProviderPhone'],
              serviceProviderService:
                  mostRecentRequestData['serviceProviderService'],
              serviceProviderId: mostRecentRequestData['serviceProviderId'],
            ));
            print(model.first.serviceProviderName);
          } else {
            print('Required fields are missing in the document.');
            return;
          }
        });
      } else {
        print('No documents found for the specified clientId.');
        return;
      }
    } catch (e) {
      print('Error fetching most recent completed service provider: $e');
      return;
    }
  }

  Future<void> fetchServiceProviderRating(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() ?? {};
        print(userId);
        // Check if the 'averageRating' field exists in the user document
        if (userData.containsKey('averageRating')) {
          String averageRating = userData['averageRating'] ?? '0.0';

          // Update the model with the fetched rating as a string
          setState(() {
            model.first.serviceProviderRating = averageRating;
          });

          print('Fetched and updated rating for user $userId: $averageRating');
        } else {
          print('Average rating field not found in user document for $userId');
        }
      } else {
        print(
            'User document does not exist in the users collection for $userId');
      }
    } catch (e) {
      print('Error fetching service provider rating: $e');
    }
  }

  Future<void> calculateAndStoreAverageRating(String serviceProviderId) async {
    try {
      // Query completed requests for the specified service provider
      var completedRequestsQuery = await FirebaseFirestore.instance
          .collection('requests')
          .where('serviceProviderId', isEqualTo: serviceProviderId)
          .where('status', isEqualTo: 'completed')
          .where('serviceRating', isNotEqualTo: null)
          .get();

      if (completedRequestsQuery.docs.isNotEmpty) {
        double totalRating = 0.0;
        int numberOfRatings = completedRequestsQuery.docs.length;

        // Calculate the total rating
        for (var completedRequestDoc in completedRequestsQuery.docs) {
          // Convert serviceRating from string to double
          var rating =
              double.tryParse(completedRequestDoc['serviceRating'] ?? '0.0') ??
                  0.0;
          totalRating += rating;
        }

        // Calculate the average rating
        double averageRating = totalRating / numberOfRatings;

        // Convert averageRating to string with two decimal places
        String averageRatingString = averageRating.toStringAsFixed(1);

        // Update the service provider's user document with the average rating as a string
        await FirebaseFirestore.instance
            .collection('users')
            .doc(serviceProviderId)
            .set({
          'averageRating': averageRatingString,
        }, SetOptions(merge: true));

        print('Average Rating for $serviceProviderId: $averageRatingString');
      } else {
        // No completed requests with ratings
        print('No completed requests with ratings for $serviceProviderId');
      }
    } catch (e) {
      print('Error calculating and storing average rating: $e');
    }
  }

  Future<void> fetchMostRatedUsers() async {
    try {
      // Query most rated users globally
      var mostRatedQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .orderBy('averageRating', descending: true)
          .limit(3)
          .get();

      setState(() {
        for (var mostRatedDoc in mostRatedQuery.docs) {
          print(mostRatedDoc);
          String serviceProviderId = mostRatedDoc.id;
          String serviceProviderName = mostRatedDoc['name'];
          String serviceProviderPhone = mostRatedDoc['phone'];
          String serviceProviderService = mostRatedDoc['service'];
          String serviceProviderRating = mostRatedDoc['averageRating'];

          mostRatedUsers.add(MostRateServiceProvider(
            serviceProviderId: serviceProviderId,
            serviceProviderName: serviceProviderName,
            serviceProviderPhone: serviceProviderPhone,
            serviceProviderService: serviceProviderService,
            rating: serviceProviderRating,
          ));
        }
      });
    } catch (e) {
      print('Error fetching most rated users: $e');
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the logout
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm the logout
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      try {
        await FirebaseAuth.instance.signOut();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("loggedIn", false);
        prefs.setBool("isAdmin", false);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
          (route) => false,
        );
      } catch (e) {
        print(e.toString());
      }
    }
  }

  List<Services> services = [
    Services('Cleaning', 'assets/images/cleaning.png'),
    Services('Plumber', 'assets/images/plumber.png'),
    Services('Electrician', 'assets/images/electrician.png'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserName();
    fetchMostRecentCompletedServiceProvider();
    fetchMostRatedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Hi, $userName',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                logoutUser(context);
              },
              icon: Hero(
                tag: 'full',
                child: Icon(
                  Icons.login_outlined,
                  color: Colors.grey.shade700,
                  size: 30,
                ),
              ),
            )
          ],
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (c) => FullPicture(url: photoUrl!)));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: photoUrl!.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(photoUrl!),
                    )
                  : const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(0, 4),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: '-1+ok',
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: const CircleAvatar(
                              child: Icon(CupertinoIcons.person),
                            )),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(
                              model.isNotEmpty
                                  ? model.first.serviceProviderName
                                  : '',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 260,
                            ),
                            model.isNotEmpty
                                ? Row(children: [
                                    Text(
                                      model.first.serviceProviderRating,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    )
                                  ])
                                : const Text("")
                          ]),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            model.isNotEmpty
                                ? model.first.serviceProviderService
                                : '',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  model.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (c) => ViewServiceProfile(
                                          serviceProviderName:
                                              model.first.serviceProviderName,
                                          serviceProviderPhone:
                                              model.first.serviceProviderPhone,
                                          serviceName: model
                                              .first.serviceProviderService,
                                          serviceProviderId:
                                              model.first.serviceProviderId,
                                          rating:
                                              model.first.serviceProviderRating,
                                          index: '-1',
                                        )));
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade800,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: const Center(
                                child: Text(
                              'View Profile',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                          ),
                        )
                      : const Text('No recent'),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (c) => const SelectService()));
                    },
                    child: const Text(
                      'View all',
                    ))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: MediaQuery.of(context).size.height * .2,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  return serviceContainer(
                      services[index].imageURL, services[index].name, index);
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Rated',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 120,
            child: mostRatedUsers.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mostRatedUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return workerContainer(
                          index,
                          mostRatedUsers[index].serviceProviderName,
                          mostRatedUsers[index].serviceProviderService,
                          mostRatedUsers[index].rating,
                          mostRatedUsers[index].serviceProviderPhone,
                          mostRatedUsers[index].serviceProviderId);
                    })
                : Center(
                    child:
                        // Text("Empty",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                        Image.asset('assets/images/empty.png')),
          ),
          const SizedBox(
            height: 20,
          ),
        ])));
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (c) =>
                    SelectRooms(serviceName: services[index].name)));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            color: Colors.blue.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            image.isNotEmpty
                ? Hero(
                    tag: services[index].name,
                    child: Image.asset(image, height: 45))
                : const CircleAvatar(),
            const SizedBox(
              height: 20,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 15),
            )
          ]),
        ),
      ),
    );
  }

  workerContainer(int index1, String name, String job, String rating,
      String serviceProviderPhone, String serviceProviderId) {
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 3.4,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (c) => ViewServiceProfile(
                          serviceProviderName: name,
                          serviceProviderPhone: serviceProviderPhone,
                          serviceName: job,
                          serviceProviderId: serviceProviderId,
                          rating: rating,
                          index: index1.toString(),
                        )));
          },
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade200,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CircleAvatar(
                    child: Hero(
                        tag: '$index1+ok',
                        child: const Icon(CupertinoIcons.person)),
                  )),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    job,
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    userName = user?.displayName!;
    userId = user?.uid;
    photoUrl = user?.photoURL!;
  }
}
