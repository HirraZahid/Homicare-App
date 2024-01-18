class RecentServiceProvider
{
  late String serviceProviderName;
  late String serviceProviderService;
  late String serviceProviderPhone;
  late String serviceProviderId;
  String serviceProviderRating = ' ';

  RecentServiceProvider({
    required this.serviceProviderId,
    required this.serviceProviderName,
    required this.serviceProviderPhone,
    required this.serviceProviderService,
  });
}