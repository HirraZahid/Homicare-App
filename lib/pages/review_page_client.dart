import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage(
      {Key? key,
      required this.requestId,
      required this.clientId,
      required this.serviceProviderId,
      required this.serviceName,
      required this.serviceProviderName,
      required this.clientName, required this.function})
      : super(key: key);
  final String requestId;
  final String clientId;
  final String serviceProviderId;
  final String serviceName;
  final String serviceProviderName;
  final String clientName;
  final VoidCallback function;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late GlobalKey<FormState> formKey;
  TextEditingController reviewController = TextEditingController();
  double rateValue = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Text(
                'Review Service',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    "How was your service?",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RatingBar.builder(
                    initialRating: 1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      rateValue = rating;
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 220,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        maxLines: 10,
                        controller: reviewController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter something';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          alignLabelWithHint: true,
                          // Align label with the hint text
                          labelText: 'Your review',
                          labelStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.black,
                          ),
                          prefixIcon: const Column(children: [
                            Padding(
                                padding: EdgeInsets.all(18),
                                child: Icon(Icons.reviews_outlined))
                          ]),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .18,
                  ),
                  InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        submitReview(
                            widget.requestId,
                            rateValue,
                            widget.clientId,
                            widget.serviceProviderId,
                            widget.serviceName,
                            widget.serviceProviderName,
                            widget.clientName,reviewController.text.trim());
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width * 0.15,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "S U B M I T",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.054,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
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
      resizeToAvoidBottomInset: true,
    );
  }

  Future<void> submitReview(
    String requestId,
    double rateValue,
    String clientId,
    String serviceProviderId,
    String serviceName,
    String serviceProviderName,
    String clientName,
    String review,
  ) async {
    try {
      // Show a CupertinoDialog for confirmation
      bool confirm = await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Confirm Submission"),
            content:const Text("Are you sure you want to submit this review?"),
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
        DocumentReference requestDoc = firestore.collection('requests').doc(requestId);
        await requestDoc.update({
          'serviceRating': rateValue.toString(),
          'clientComments':review,
        });
        print('Submission Completed Successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.white,
            content: Text(
              "Review Completed Successfully",
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
        calculateAndStoreAverageRating(serviceProviderId);
        widget.function();
        Navigator.pop(context);
      } else {
        print('Request completion canceled by user');
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      print('Error: $e');
    }
  }


  //update the rating
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
}
