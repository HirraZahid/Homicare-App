class RequestModel {
  late String serviceName; //
  late int day;
  late String userId;
  late String month;
  late String rooms; //
  late String status;
  late String address; //
  late String time; //
  late String repeat; //
  late String requestId;

  RequestModel({
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
