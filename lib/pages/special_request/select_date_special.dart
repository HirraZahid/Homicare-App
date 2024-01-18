import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homicare/pages/special_request/confirm_details_special.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DateTimeSpecial extends StatefulWidget {
  const DateTimeSpecial(
      {Key? key, required this.selectedRoomsData, required this.serviceName, required this.serviceProviderName, required this.serviceProviderPhone, required this.serviceProviderId})
      : super(key: key);
  final List<Map<String, dynamic>> selectedRoomsData;
  final String serviceName;
  final String serviceProviderName;
  final String serviceProviderPhone;
  final String serviceProviderId;

  @override
  State<DateTimeSpecial> createState() => _DateAndTimeState();
}

class _DateAndTimeState extends State<DateTimeSpecial> {
  int _selectedDay = DateTime.now().day;
  int _selectedRepeat = 0;
  String _selectedHour = DateFormat('HH:mm').format(DateTime.now());
  final List<int> _selectedExtraCleaning = [];
  final DateTime now = DateTime.now();
  late String formattedDate;
  final ItemScrollController _scrollController = ItemScrollController();

  final List<dynamic> _days = List.generate(7, (index) {
    final day = DateTime.now().add(Duration(days: index));
    return [day.day, DateFormat('E').format(day)];
  });

  final List<String> _hours = List.generate(48, (index) {
    final time = DateTime.now().add(Duration(minutes: index * 30));
    return DateFormat('HH:mm').format(time);
  });

  final List<String> _repeat = [
    'No repeat',
    'Every day',
    'Every week',
    'Every month'
  ];

  final List<dynamic> _extraCleaning = [
    ['Washing', 'assets/images/washing.png', '10'],
    ['Fridge', 'assets/images/fridge.png', '8'],
    ['Oven', 'assets/images/oven.png', '8'],
    ['Vehicle', 'assets/images/vehicle.png', '20'],
    ['Windows', 'assets/images/window.png', '20'],
  ];

  @override
  void initState() {
    formattedDate = DateFormat('MMMM y').format(now);
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.scrollTo(
        index: _hours.indexOf(_selectedHour),
        duration: const Duration(seconds: 3),
        curve: Curves.easeInOut,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(widget.selectedRoomsData);
          List<Map<String, dynamic>> selectedExtraServices =
              _selectedExtraCleaning
                  .map((index) => {
                        'name': _extraCleaning[index][0],
                        'price': _extraCleaning[index][2],
                      })
                  .toList();

          print(selectedExtraServices);
          print(formattedDate);
          print(_selectedDay);
          print(now);
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ConfirmDetailsSpecial(
                serviceName: widget.serviceName,
                repeat: _repeat[_selectedRepeat],
                rooms: widget.selectedRoomsData,
                selectedExtraServices: selectedExtraServices,
                day: _selectedDay,
                month: formattedDate,
                time: now,
                selTime: _selectedHour,
                serviceProviderName: widget.serviceProviderName,
                serviceProviderPhone: widget.serviceProviderPhone,
                serviceProviderService: widget.serviceName,
                serviceProviderId: widget.serviceProviderId,
              ),
            ),
          );
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0),
                child: Text(
                  'Select Date \nand Time',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(formattedDate),
                  const Spacer(),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Colors.grey.shade700,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: Colors.grey.shade200),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (_days[index][0] >= DateTime.now().day) {
                          setState(() {
                            _selectedDay = _days[index][0];
                            print(_selectedDay);
                          });
                        } else {}
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 62,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _selectedDay == _days[index][0]
                              ? Colors.blue.shade100.withOpacity(0.5)
                              : Colors.blue.withOpacity(0),
                          border: Border.all(
                            color: _selectedDay == _days[index][0]
                                ? Colors.blue
                                : Colors.white.withOpacity(0),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _days[index][0].toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              _days[index][1],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: Colors.grey.shade200),
                ),
                child: ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _hours.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        final selectedTime =
                            DateTime.now().add(Duration(minutes: index * 30));
                        if (selectedTime.isAfter(DateTime.now())) {
                          setState(() {
                            _selectedHour = _hours[index];
                          });
                        } else {
                          // Handle the case where the user selects a past time
                          // You may show a message or take appropriate action
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _selectedHour == _hours[index]
                              ? Colors.orange.shade100.withOpacity(0.5)
                              : Colors.orange.withOpacity(0),
                          border: Border.all(
                            color: _selectedHour == _hours[index]
                                ? Colors.orange
                                : Colors.white.withOpacity(0),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _hours[index],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Repeat",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _repeat.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRepeat = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: _selectedRepeat == index
                              ? Colors.grey.shade800
                              : Colors.grey.shade100,
                        ),
                        margin: const EdgeInsets.only(right: 20),
                        child: Center(
                          child: Text(
                            _repeat[index],
                            style: TextStyle(
                              fontSize: 18,
                              color: _selectedRepeat == index
                                  ? Colors.white
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Additional Service",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _extraCleaning.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedExtraCleaning.contains(index)) {
                              _selectedExtraCleaning.remove(index);
                            } else {
                              _selectedExtraCleaning.add(index);
                            }
                          });
                        },
                        child: Container(
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: _selectedExtraCleaning.contains(index)
                                ? Colors.blue.shade400
                                : Colors.transparent,
                          ),
                          margin: const EdgeInsets.only(right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                _extraCleaning[index][1],
                                height: 40,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _extraCleaning[index][0],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _selectedExtraCleaning.contains(index)
                                      ? Colors.white
                                      : Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "+${_extraCleaning[index][2]}\$",
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
