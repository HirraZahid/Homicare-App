import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  State<ProfileAdmin> createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  String? userName = '';
  String service = '';
  String rating = '';
  String? userId = '';
  String? phone='';

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        print(user.uid);
        userId = user.uid;
        userName = user.displayName;
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference documentReference =
            firestore.collection('users').doc(user.uid);
        DocumentSnapshot docs = await documentReference.get();
        if (docs.exists) {
          setState(() {
            service = docs['service'];
            phone = docs['phone'];
          });
          print(service);
        }
      }
    } catch (error) {
      print(error.toString());
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

        setState(() {
          rating = averageRatingString;
        });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
    calculateAndStoreAverageRating(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Text(
              'Service Profile',
              style: TextStyle(
                fontSize: 35,
                color: Colors.grey.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const CircleAvatar(
            radius: 60,
            child: Icon(CupertinoIcons.person),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              userName!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              service,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Contact: $phone',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rating,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
