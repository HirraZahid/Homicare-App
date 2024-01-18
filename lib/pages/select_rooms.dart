import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'date_time.dart';

class SelectRooms extends StatefulWidget {
  const SelectRooms({Key? key, required this.serviceName}) : super(key: key);
  final String serviceName;

  @override
  State<SelectRooms> createState() => _SelectRoomsState();
}

class _SelectRoomsState extends State<SelectRooms> {
  // Rooms to clean
  final List<dynamic> _rooms = [
    ['Living Room', 'assets/images/sofa.png', Colors.red, 0],
    ['Bedroom', 'assets/images/bed.png', Colors.orange, 1],
    ['Bathroom', 'assets/images/bath.png', Colors.blue, 1],
    ['Kitchen', 'assets/images/pot.png', Colors.purple, 0],
    ['Office', 'assets/images/office.png', Colors.green, 0]
  ];
  // List to keep track of selected rooms
  final List<int> _selectedRooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      // Show FloatingActionButton only when there are selected rooms
      floatingActionButton: _selectedRooms.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                if (_selectedRooms.isNotEmpty) {
                  List<Map<String, dynamic>> selectedRoomsData = [];

                  // Iterate through selected rooms and create data
                  for (int selectedIndex in _selectedRooms) {
                    String roomName = _rooms[selectedIndex][0];
                    int roomCount = _rooms[selectedIndex][3];
// Add room data to the list
                    selectedRoomsData.add({
                      'name':
                          '$roomName $roomCount room${roomCount > 1 ? 's' : ''}',
                    });
                  }
// Navigate to the DateAndTime screen with selected room data
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => DateAndTime(
                        selectedRoomsData: selectedRoomsData,
                        serviceName: widget.serviceName,
                      ),
                    ),
                  );
                }
                print(_selectedRooms);
                print(widget.serviceName);
              },
              //button code
              backgroundColor: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //how many rooms selected apperas
                  Text('${_selectedRooms.length}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ],
              ),
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                child: Text(
                  'Where do you want \nservice?',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _rooms.length,
              itemBuilder: (BuildContext context, int index) {
                return room(_rooms[index], index);
              }),
        ),
      ),
    );
  }

  // Widget for displaying individual room
  Widget room(List room, int index) {
    return GestureDetector(
      // Update selected rooms when a room is tapped
      onTap: () {
        setState(() {
          if (_selectedRooms.contains(index)) {
            _selectedRooms.remove(index);
          } else {
            _selectedRooms.add(index);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        margin: const EdgeInsets.only(bottom: 20.0),
        // Set room color based on selection state background color 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: _selectedRooms.contains(index)
              ? room[2].shade50.withOpacity(0.5) //on selection room color
              : Colors.grey.shade100, // if not select it will be grey
        ),
        child: Column( //things in box
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Image.asset(
                      room[1],
                      width: 35,
                      height: 35,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      room[0],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Spacer(), // Display checkmark icon if room is selected
                _selectedRooms.contains(index)
                    ? Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade100.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 20,
                        ))
                    : const SizedBox()
              ],
            ),
            // Display count selection if room is selected and count is greater than or equal to 1
            (_selectedRooms.contains(index) && room[3] >= 1)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "How many ${room[0]}s?",
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 45,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    room[3] = index + 1;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  padding: const EdgeInsets.all(10.0),
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: room[3] == index + 1
                                        ? room[2].withOpacity(0.5)
                                        : room[2].shade200.withOpacity(0.5),
                                  ),
                                  child: Center(
                                      child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  )),
                                ),
                              );
                            }),
                      )
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
