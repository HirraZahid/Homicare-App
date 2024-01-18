import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:homicare/pages/home_page_editor.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

class ConfirmDetailsSpecial extends StatefulWidget {
  final String serviceName;
  final String month;
  final int day;
  final String serviceProviderName;
  final String serviceProviderId;
  final String serviceProviderPhone;
  final String serviceProviderService;
  final String selTime;
  final String repeat;
  final DateTime time;
  final List<Map<String, dynamic>> rooms;
  final List<Map<String, dynamic>> selectedExtraServices;

  const ConfirmDetailsSpecial({
    Key? key,
    required this.serviceName,
    required this.rooms,
    required this.selectedExtraServices,
    required this.month,
    required this.day,
    required this.time,
    required this.selTime,
    required this.repeat,
    required this.serviceProviderName,
    required this.serviceProviderPhone,
    required this.serviceProviderService,
    required this.serviceProviderId,
  }) : super(key: key);

  @override
  State<ConfirmDetailsSpecial> createState() => _ConfirmDetailsState();
}

class _ConfirmDetailsState extends State<ConfirmDetailsSpecial> {
  List<Map<String, dynamic>> result = [];

  List<Map<String, dynamic>> removeNamePattern(
      List<Map<String, dynamic>> dataList) {
    for (var item in dataList) {
      String originalName = item['name'];
      String cleanedName = removeNameFromText(originalName);

      // Create a new map with the cleaned name
      Map<String, dynamic> newItem = {'name': cleanedName};
      result.add(newItem);
    }

    return result;
  }

  String removeNameFromText(String text) {
    // Remove [{name:}] from the text
    String result = text.replaceAll(RegExp(r'\[{name:.*?}\]'), '');

    // Remove additional brackets and spaces
    result = result.replaceAll('[', '').replaceAll(']', '').trim();

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    removeNamePattern(widget.rooms);
  }

  Widget buildBulletText(String text) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: '\u2022 ', // Unicode character for bullet (•)
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController addressController = TextEditingController();
    bool isAddressValid = true;

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: 4, // Set an appropriate count
        itemBuilder: (context, index) {
          if (index == 0) {
            // Header
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                    child: Text(
                      'Confirm Details',
                      style: TextStyle(
                        fontSize: 38,
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildBulletText(
                            " One of the available service providers will soon accept your request"),
                        buildBulletText(
                            " Service provider will charge amount after the completion of the task"),
                        buildBulletText(
                            " Make sure to choose a friendly behavior with the service provider"),
                        buildBulletText(
                            " Make sure to choose the right address to avoid conflicts"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (index == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(children: [
                    const Text(
                      'Service: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.serviceName,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(children: [
                    const Text(
                      'Date: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.day} ${widget.month}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ]),
                ],
              ),
            );
          } else if (index == 2) {
            // Address field and map icon
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: addressController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: const Icon(LineIcons.map),
                            labelText: 'Address',
                            errorText: isAddressValid
                                ? null
                                : 'Please enter the address',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Buttons
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 85,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const MyHomePage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 85,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            uploadRequest(context, addressController);
                          } else {
                            // The form is not valid
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Send Request',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void uploadRequest(
      BuildContext context, TextEditingController addressController) async {
    BuildContext? dialogContext;
    DocumentReference? requestRef;

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

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      String? id = user?.uid;

      // Generate a unique request ID using Uuid
      String requestId = const Uuid().v4();

      List<String> roomDescriptions =
          widget.rooms.map((room) => room['name'].toString()).toList();
      String roomsDescription = roomDescriptions.join(', ');

      List<String> extraServiceNames = widget.selectedExtraServices
          .map((extraService) => extraService['name'].toString())
          .toList();
      String extraServicesDescription = extraServiceNames.isNotEmpty
          ? extraServiceNames.join(', ')
          : 'No extra service';

      await firestore.collection('requests').doc(requestId).set({
        'requestId': requestId, // Store the custom request ID
        'serviceName': widget.serviceName,
        'userName': user?.displayName,
        'userId': id,
        'reason':'',
        'status': 'specialUnknown',
        'serviceProviderName': widget.serviceProviderName,
        'serviceProviderId': widget.serviceProviderId,
        'completeTime': '',
        'serviceProviderPhone': widget.serviceProviderPhone,
        'serviceRating': '',
        'clientComments': '',
        'serviceProviderService': widget.serviceProviderService,
        'location': addressController.text.trim(),
        'rooms': roomsDescription,
        'selectedExtraServices': extraServicesDescription,
        'month': DateFormat('MMMM y').format(widget.time),
        'day': widget.time.day,
        'repeat': widget.repeat,
        'time': DateFormat('HH:mm').format(widget.time),
        'uploadTime': FieldValue.serverTimestamp(),
      });

      // Retrieve the DocumentReference after the data is set
      requestRef = firestore.collection('requests').doc(requestId);
    } catch (e) {
      print('Error uploading request: $e');
      // Handle errors as needed
    }

    if (requestRef != null) {
      Navigator.pop(dialogContext!);
      print('Request uploaded with ID: ${requestRef.id}');
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (builder) => const MyHomePage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white,
        content: Text(
          "Request has been Submitted.",
          style: TextStyle(color: Colors.black),
        ),
      ));
    }
  }
}
