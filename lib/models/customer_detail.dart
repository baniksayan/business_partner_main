// lib/models/customer_detail.dart - CREATE THIS FILE
class CustomerDetail {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String avatar;
  final List<dynamic> roles;
  final bool isActive;
  final String designation;
  final String bio;
  final String city;
  final String address;
  final int totalBookings;
  final double totalSpend;
  final DateTime? lastSeen;
  final List<String> tags;
  final List<BookingHistory> bookingHistory;

  CustomerDetail({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.avatar = '',
    this.roles = const [],
    this.isActive = true,
    this.designation = '',
    this.bio = '',
    this.city = '',
    this.address = '',
    this.totalBookings = 0,
    this.totalSpend = 0.0,
    this.lastSeen,
    this.tags = const [],
    this.bookingHistory = const [],
  });

  // Create from API response with bookings
  factory CustomerDetail.fromJson(Map<String, dynamic> json) {
    print('🔍 [CustomerDetail] Parsing customer detail: ${json['id']}');
    
    // Parse booking history
    List<BookingHistory> bookings = [];
    double totalSpend = 0.0;
    
    if (json['bookings'] != null && json['bookings'] is List) {
      bookings = (json['bookings'] as List).map((booking) {
        try {
          final bookingHistory = BookingHistory.fromJson(booking);
          totalSpend += bookingHistory.amount;
          return bookingHistory;
        } catch (e) {
          print('⚠️ [CustomerDetail] Error parsing booking: $e');
          return null;
        }
      }).where((b) => b != null).cast<BookingHistory>().toList();
    }
    
    return CustomerDetail(
      id: json['id']?.toString() ?? '',
      name: _extractName(json),
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatar: json['image_url']?.toString() ?? '',
      roles: json['roles'] ?? [],
      isActive: json['is_active'] ?? true,
      designation: json['designation']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      totalBookings: bookings.length,
      totalSpend: totalSpend,
      lastSeen: _parseDateTime(json['last_login']),
      tags: _generateTags(bookings.length, totalSpend),
      bookingHistory: bookings,
    );
  }

  // Extract name helper
  static String _extractName(Map<String, dynamic> json) {
    final firstName = json['first_name']?.toString().trim() ?? '';
    final lastName = json['last_name']?.toString().trim() ?? '';
    
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    }
    
    return 'Customer ${json['id'] ?? 'Unknown'}';
  }

  // Parse DateTime helper
  static DateTime? _parseDateTime(dynamic dateTimeString) {
    if (dateTimeString == null) return null;
    try {
      return DateTime.parse(dateTimeString.toString());
    } catch (e) {
      return null;
    }
  }

  // Generate customer tags based on activity
  static List<String> _generateTags(int bookingCount, double totalSpend) {
    List<String> tags = [];
    
    if (bookingCount >= 10) {
      tags.add('Frequent');
    } else if (bookingCount >= 5) {
      tags.add('Regular');
    } else if (bookingCount > 0) {
      tags.add('New');
    }
    
    if (totalSpend >= 5000) {
      tags.add('VIP');
    } else if (totalSpend >= 2000) {
      tags.add('Premium');
    }
    
    return tags;
  }

  // Format last seen
  String get lastSeenFormatted {
    if (lastSeen == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastSeen!);
    
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() != 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} ago';
    } else {
      return 'Recently';
    }
  }

  // Format total spend
  String get totalSpendFormatted {
    return '₹${totalSpend.toStringAsFixed(0)}';
  }

  // Format tags
  String get tagsFormatted {
    return tags.isEmpty ? 'Standard' : tags.join(', ');
  }
}

// Booking History Model
class BookingHistory {
  final String id;
  final String title;
  final String date;
  final String status;
  final double amount;
  final String serviceName;

  BookingHistory({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.amount,
    required this.serviceName,
  });

  factory BookingHistory.fromJson(Map<String, dynamic> json) {
    final bookingTime = DateTime.tryParse(json['booking_time']?.toString() ?? '');
    final formattedDate = bookingTime?.toString().split(' ')[0] ?? json['created_at']?.toString().split('T')[0] ?? '';
    
    return BookingHistory(
      id: json['id']?.toString() ?? '',
      title: json['service_name']?.toString() ?? 'Service Booking',
      date: formattedDate,
      status: json['status'] ?? (json['is_active'] == true ? 'Active' : 'Cancelled'),
      amount: double.tryParse(json['booking_charge']?.toString() ?? '0') ?? 0.0,
      serviceName: json['service_name']?.toString() ?? 'Service',
    );
  }
}
