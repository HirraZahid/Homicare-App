class CompletedModel {
  late String serviceName;
  late int day;
  late String serviceProviderId;
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
  late String userName;
  late String rating;
  late String comments;

  CompletedModel({
    required this.userName,
    required this.comments,
    required this.rating,
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
    required this.serviceProviderId,
  });
}
