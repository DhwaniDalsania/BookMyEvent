class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String? heroImageUrl;
  final String? status;
  final String categoryId;
  final String venueId;
  final String categoryName;
  final String locationName;
  final double startingPrice;
  final bool isTrending;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.heroImageUrl,
    this.status,
    required this.categoryId,
    required this.venueId,
    this.categoryName = 'Category',
    this.locationName = 'TBD',
    this.startingPrice = 0.0,
    this.isTrending = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Attempt to extract venue city or name
    String loc = 'TBD';
    if (json['venue'] != null) {
      loc = json['venue']['city'] ?? json['venue']['name'] ?? 'TBD';
    }

    // Attempt to extract lowest ticket tier price
    double price = 0.0;
    if (json['ticketTiers'] != null && (json['ticketTiers'] as List).isNotEmpty) {
      final tiers = json['ticketTiers'] as List;
      price = tiers
          .map((t) => double.tryParse(t['price'].toString()) ?? 0.0)
          .reduce((a, b) => a < b ? a : b);
    }

    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : DateTime.now(),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : DateTime.now(),
      heroImageUrl: json['heroImageUrl'],
      status: json['status'],
      categoryId: json['categoryId'] ?? '',
      venueId: json['venueId'] ?? '',
      categoryName: json['category'] != null ? (json['category']['name'] ?? 'Category') : 'Category',
      locationName: loc,
      startingPrice: price,
      isTrending: (json['isFeatured'] == true) ||
          (json['metrics']?['totalViews'] != null &&
              (json['metrics']['totalViews'] is int
                  ? json['metrics']['totalViews'] > 50
                  : int.tryParse(json['metrics']['totalViews'].toString()) ?? 0 > 50)),
    );
  }
}
