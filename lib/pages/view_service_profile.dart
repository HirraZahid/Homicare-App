import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homicare/pages/special_request/select_rooms_special.dart';

class ViewServiceProfile extends StatelessWidget {
  const ViewServiceProfile({
    Key? key,
    required this.serviceProviderName,
    required this.index,
    required this.serviceProviderPhone,
    required this.serviceName,
    required this.serviceProviderId, required this.rating,
  }) : super(key: key);

  final String serviceProviderName;
  final String index;
  final String rating;
  final String serviceProviderPhone;
  final String serviceName;
  final String serviceProviderId;

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
          Hero(
            tag: '$index+ok',
            child: const CircleAvatar(
              radius: 60,
              child: Icon(CupertinoIcons.person),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              serviceProviderName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              serviceName,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Contact: $serviceProviderPhone',
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
                  rating, // Replace with actual rating
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.amber,
                  ),
                ),
               const SizedBox(width: 4,),
               const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),

              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .34,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (c) => SelectRoomsSpecial(
                            serviceName: serviceName,
                            serviceProviderName: serviceProviderName,
                            serviceProviderPhone: serviceProviderPhone,
                            serviceProviderId: serviceProviderId,
                          )));
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
                  "SEND  REQUEST",
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
    );
  }
}
