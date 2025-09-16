// lib/models/customer.dart - COMPLETE WITH ALL FIELDS
class Customer {
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
  final int totalBookings;      // ✅ ADDED: Missing totalBookings field
  final DateTime? lastBooking;  // ✅ ADDED: Missing lastBooking field

  Customer({
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
    this.totalBookings = 0,      // ✅ ADDED: Default to 0 bookings
    this.lastBooking,            // ✅ ADDED: Optional last booking date
  });

  // ✅ FIXED: Parse your exact API response format with all fields
  factory Customer.fromJson(Map<String, dynamic> json) {
    print('🔍 [Customer] Parsing user data: ${json['id']} - ${json['first_name']} ${json['last_name']}');
    
    return Customer(
      id: json['id']?.toString() ?? '',
      name: _extractName(json),
      phone: _formatPhone(json['phone']?.toString() ?? ''),
      email: json['email']?.toString() ?? '',
      avatar: json['image_url']?.toString() ?? '',
      roles: json['roles'] ?? [],
      isActive: json['is_active'] ?? true,
      designation: json['designation']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      totalBookings: json['total_bookings'] ?? 0,              // ✅ ADDED: From API or default to 0
      lastBooking: _parseDateTime(json['last_booking']),        // ✅ ADDED: Parse last booking date
    );
  }

  // Extract name from first_name + last_name
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
    
    // Fallback to email username
    final email = json['email']?.toString() ?? '';
    if (email.isNotEmpty && email.contains('@')) {
      return email.split('@')[0];
    }
    
    return 'User ${json['id'] ?? 'Unknown'}';
  }

  // Format phone for display
  static String _formatPhone(String phone) {
    if (phone.isEmpty) return '98xxxxxxxx';
    
    // Remove any non-digit characters
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length >= 10) {
      // Show first 4 digits, then x's
      return '${cleanPhone.substring(0, 4)}xxxxxx';
    }
    
    return phone.isNotEmpty ? phone : '98xxxxxxxx';
  }

  // ✅ ADDED: Parse DateTime from API response
  static DateTime? _parseDateTime(dynamic dateTimeString) {
    if (dateTimeString == null) return null;
    try {
      return DateTime.parse(dateTimeString.toString());
    } catch (e) {
      print('⚠️ [Customer] Invalid date format: $dateTimeString');
      return null;
    }
  }

  // ✅ Check if user should show based on roles containing 1
  bool get shouldShow {
    if (roles.isEmpty) return false;
    
    // Check if roles array contains 1
    return roles.contains(1);
  }

  // Get role names for display
  List<String> get roleNames {
    return roles.map((role) => role.toString()).toList();
  }

  // ✅ ADDED: Helper methods for UI compatibility
  Map<String, dynamic> toCompatibleFormat() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'avatar': avatar,
      'designation': designation,
      'bio': bio,
      'city': city,
      'totalBookings': totalBookings,
    };
  }

  // ✅ ADDED: Create Customer from existing data (for compatibility)
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      avatar: map['avatar']?.toString() ?? '',
      roles: map['roles'] ?? [1], // Default to role 1 for compatibility
      isActive: map['is_active'] ?? true,
      designation: map['designation']?.toString() ?? '',
      bio: map['bio']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      totalBookings: map['totalBookings'] ?? 0,
      lastBooking: map['lastBooking'],
    );
  }

  // ✅ ADDED: Copy with method for updates
  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? avatar,
    List<dynamic>? roles,
    bool? isActive,
    String? designation,
    String? bio,
    String? city,
    String? address,
    int? totalBookings,
    DateTime? lastBooking,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
      designation: designation ?? this.designation,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      address: address ?? this.address,
      totalBookings: totalBookings ?? this.totalBookings,
      lastBooking: lastBooking ?? this.lastBooking,
    );
  }

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, phone: $phone, roles: $roles, totalBookings: $totalBookings)';
  }
}
