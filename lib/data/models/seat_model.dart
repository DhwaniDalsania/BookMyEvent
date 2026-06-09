class TicketTierModel {
  final String id;
  final String name;
  final double price;
  final int availableQty;

  TicketTierModel({
    required this.id,
    required this.name,
    required this.price,
    required this.availableQty,
  });

  factory TicketTierModel.fromJson(Map<String, dynamic> json) {
    return TicketTierModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0,
      availableQty: json['availableQty'] ?? 0,
    );
  }
}

class SeatModel {
  final String id;
  final String rowName;
  final String seatNumber;
  final String label;
  final String sectionName;
  final String? ticketTierId;
  final String? ticketTierName;
  final double price;
  final String status;

  SeatModel({
    required this.id,
    required this.rowName,
    required this.seatNumber,
    required this.label,
    required this.sectionName,
    this.ticketTierId,
    this.ticketTierName,
    required this.price,
    required this.status,
  });

  bool get isAvailable => status == 'available';
  bool get isBooked => status == 'booked';
  bool get isHeld => status == 'held';

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'] ?? '',
      rowName: json['rowName'] ?? '',
      seatNumber: json['seatNumber']?.toString() ?? '',
      label: json['label'] ?? '',
      sectionName: json['sectionName'] ?? 'Main Floor',
      ticketTierId: json['ticketTierId'],
      ticketTierName: json['ticketTierName'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      status: json['status'] ?? 'available',
    );
  }
}

class SeatMapModel {
  final String eventId;
  final String venueName;
  final int rows;
  final int cols;
  final List<TicketTierModel> ticketTiers;
  final List<SeatModel> seats;

  SeatMapModel({
    required this.eventId,
    required this.venueName,
    required this.rows,
    required this.cols,
    required this.ticketTiers,
    required this.seats,
  });

  factory SeatMapModel.fromJson(Map<String, dynamic> json) {
    return SeatMapModel(
      eventId: json['eventId'] ?? '',
      venueName: json['venueName'] ?? '',
      rows: json['rows'] ?? 8,
      cols: json['cols'] ?? 8,
      ticketTiers: (json['ticketTiers'] as List? ?? [])
          .map((t) => TicketTierModel.fromJson(t as Map<String, dynamic>))
          .toList(),
      seats: (json['seats'] as List? ?? [])
          .map((s) => SeatModel.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  factory SeatMapModel.mock(String eventId, double basePrice) {
    final tiers = [
      TicketTierModel(id: 'mock-general', name: 'General', price: basePrice, availableQty: 500),
      TicketTierModel(id: 'mock-premium', name: 'Premium', price: basePrice * 2, availableQty: 100),
      TicketTierModel(id: 'mock-vip', name: 'VIP', price: basePrice * 3.5, availableQty: 30),
    ];
    final seats = <SeatModel>[];
    for (int r = 0; r < 8; r++) {
      final rowName = String.fromCharCode(65 + r);
      for (int c = 1; c <= 8; c++) {
        final label = '$rowName$c';
        final isBooked = (r * 8 + c) % 11 == 0;
        final TicketTierModel tier;
        if (r < 2) {
          tier = tiers[2];
        } else if (r < 5) {
          tier = tiers[1];
        } else {
          tier = tiers[0];
        }
        seats.add(SeatModel(
          id: 'mock-$label',
          rowName: rowName,
          seatNumber: '$c',
          label: label,
          sectionName: 'Main Floor',
          ticketTierId: tier.id,
          ticketTierName: tier.name,
          price: tier.price,
          status: isBooked ? 'booked' : 'available',
        ));
      }
    }
    return SeatMapModel(
      eventId: eventId,
      venueName: 'Venue',
      rows: 8,
      cols: 8,
      ticketTiers: tiers,
      seats: seats,
    );
  }
}

class SelectedSeat {
  final String id;
  final String label;
  final String ticketTierId;
  final double price;
  final String zoneName;

  SelectedSeat({
    required this.id,
    required this.label,
    required this.ticketTierId,
    required this.price,
    this.zoneName = 'General',
  });
}
