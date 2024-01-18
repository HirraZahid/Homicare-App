import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewReviewPage extends StatefulWidget {
  const ViewReviewPage({
    Key? key, required this.rating, required this.review,
  }) : super(key: key);
final String rating;
final String review;
  @override
  State<ViewReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ViewReviewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                'Service Rating',
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
                    initialRating:double.parse(widget.rating),
                    minRating: double.parse(widget.rating),
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
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 220,
                    width: MediaQuery.of(context).size.width - 50,
                    child: TextField(
                      controller: TextEditingController(text: widget.review),
                      readOnly: true,
                      maxLines: 10,
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
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
