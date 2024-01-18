import 'dart:ui';
import 'package:flutter/material.dart';

class FullPicture extends StatelessWidget {
  final String? url;
  const FullPicture({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image (Replace with your own image)
          Image.asset(
            'assets/images/back.jpg',
            fit: BoxFit.cover,
          ),
          // Blurred Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
            ),
          ),
          Positioned(top: 40,left: 10,
            child: IconButton(
                color: Colors.white,
                onPressed: ()
                {
                  Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back_ios_new)),
          ),
          // Circular Profile Picture
          Center(
            child: ClipOval(
              child: url!.isNotEmpty ? Hero(
                tag: 'full',
                child: Image.network(
                  url!,
                  width: 400,
                  height: 300.0,
                ),
              ):const Text('No Photo',style: TextStyle(color: Colors.white,fontSize: 18),),
            ),
          ),
        ],
      ),
    );
  }
}