// lib/models/booking.dart
class Booking {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String serviceId;
  final String serviceName;
  final String serviceProviderId;
  final String serviceProviderName;
  final DateTime bookingTime;
  final String status;
  final bool isPaid;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;

  Booking({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.serviceId,
    required this.serviceName,
    required this.serviceProviderId,
    required this.serviceProviderName,
    required this.bookingTime,
    required this.status,
    required this.isPaid,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      customerId: json['user']?.toString() ?? json['customer_id']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? json['user_name']?.toString() ?? 'Unknown Customer',
      customerPhone: json['customer_phone']?.toString() ?? json['user_phone']?.toString() ?? '',
      serviceId: json['service']?.toString() ?? '',
      serviceName: json['service_name']?.toString() ?? 'Service',
      serviceProviderId: json['service_provider']?.toString() ?? '',
      serviceProviderName: json['service_provider_name']?.toString() ?? 'Service Provider',
      bookingTime: DateTime.tryParse(json['booking_time']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'Pending',
      isPaid: json['is_paid'] == true || json['paid'] == true,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': customerId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'service': serviceId,
      'service_name': serviceName,
      'service_provider': serviceProviderId,
      'service_provider_name': serviceProviderName,
      'booking_time': bookingTime.toIso8601String(),
      'status': status,
      'is_paid': isPaid,
      'amount': amount,
      'notes': notes,
    };
  }

  // Getters for your existing UI
  String get customer => customerName;
  String get phone => customerPhone;
  String get date => '${bookingTime.day} ${_getMonthName(bookingTime.month)}, ${bookingTime.year}';
  String get time => _formatTime(bookingTime);
  bool get paid => isPaid;

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String period = hour >= 12 ? 'PM' : 'AM';
    
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    
    return '$hour:$minute $period';
  }
}
