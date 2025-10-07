class Ticket {
  final int? id;
  final String ticketNumber;
  final int userId;
  final String touristPlace;
  final String touristPlaceLocation;
  final double price;
  final DateTime visitDate;
  final int numberOfPersons;
  final DateTime bookingDate;
  final String status; // 'booked', 'cancelled', 'completed'

  Ticket({
    this.id,
    required this.ticketNumber,
    required this.userId,
    required this.touristPlace,
    required this.touristPlaceLocation,
    required this.price,
    required this.visitDate,
    required this.numberOfPersons,
    required this.bookingDate,
    this.status = 'booked',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticketNumber': ticketNumber,
      'userId': userId,
      'touristPlace': touristPlace,
      'touristPlaceLocation': touristPlaceLocation,
      'price': price,
      'visitDate': visitDate.toIso8601String(),
      'numberOfPersons': numberOfPersons,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id']?.toInt(),
      ticketNumber: map['ticketNumber'] ?? '',
      userId: map['userId']?.toInt() ?? 0,
      touristPlace: map['touristPlace'] ?? '',
      touristPlaceLocation: map['touristPlaceLocation'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      visitDate: DateTime.parse(map['visitDate']),
      numberOfPersons: map['numberOfPersons']?.toInt() ?? 1,
      bookingDate: DateTime.parse(map['bookingDate']),
      status: map['status'] ?? 'booked',
    );
  }

  Ticket copyWith({
    int? id,
    String? ticketNumber,
    int? userId,
    String? touristPlace,
    String? touristPlaceLocation,
    double? price,
    DateTime? visitDate,
    int? numberOfPersons,
    DateTime? bookingDate,
    String? status,
  }) {
    return Ticket(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      userId: userId ?? this.userId,
      touristPlace: touristPlace ?? this.touristPlace,
      touristPlaceLocation: touristPlaceLocation ?? this.touristPlaceLocation,
      price: price ?? this.price,
      visitDate: visitDate ?? this.visitDate,
      numberOfPersons: numberOfPersons ?? this.numberOfPersons,
      bookingDate: bookingDate ?? this.bookingDate,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Ticket(id: $id, ticketNumber: $ticketNumber, touristPlace: $touristPlace, price: $price, visitDate: $visitDate, numberOfPersons: $numberOfPersons, status: $status)';
  }
}