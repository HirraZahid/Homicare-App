class DeclineModel {
  late String serviceName;
  late int day;
  late String userId;
  late String month;
  late String rooms;
  late String status;
  late String address;
  late String time;
  late String repeat;
  late String requestId;
  late String serviceProviderName;
  late String serviceProviderPhone;
  late String serviceProviderService;
  late String completeTime;

  DeclineModel({
    required this.completeTime,
    required this.serviceProviderName,
    required this.serviceProviderPhone,
    required this.serviceProviderService,
    required this.status,
    required this.requestId,
    required this.repeat,
    required this.serviceName,
    required this.time,
    required this.day,
    required this.userId,
    required this.address,
    required this.month,
    required this.rooms,
  });
}
