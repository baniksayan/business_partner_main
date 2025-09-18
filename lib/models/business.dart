// lib/models/business.dart
class Business {
  final String id;
  final String name;
  final String ownerName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String businessType;
  final String description;
  final String logo;
  final String website;
  final Map<String, dynamic> socialMedia;
  final BusinessHours businessHours;
  final List<String> services;
  final double rating;
  final int totalReviews;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BusinessStats stats;

  Business({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.businessType,
    required this.description,
    required this.logo,
    required this.website,
    required this.socialMedia,
    required this.businessHours,
    required this.services,
    required this.rating,
    required this.totalReviews,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zip_code'] ?? '',
      country: json['country'] ?? '',
      businessType: json['business_type'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      website: json['website'] ?? '',
      socialMedia: Map<String, dynamic>.from(json['social_media'] ?? {}),
      businessHours: BusinessHours.fromJson(json['business_hours'] ?? {}),
      services: List<String>.from(json['services'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      stats: BusinessStats.fromJson(json['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner_name': ownerName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'business_type': businessType,
      'description': description,
      'logo': logo,
      'website': website,
      'social_media': socialMedia,
      'business_hours': businessHours.toJson(),
      'services': services,
      'rating': rating,
      'total_reviews': totalReviews,
      'is_verified': isVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'stats': stats.toJson(),
    };
  }
}

class BusinessHours {
  final Map<String, DayHours> schedule;

  BusinessHours({required this.schedule});

  factory BusinessHours.fromJson(Map<String, dynamic> json) {
    Map<String, DayHours> schedule = {};
    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        schedule[key] = DayHours.fromJson(value);
      }
    });
    return BusinessHours(schedule: schedule);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    schedule.forEach((key, value) {
      json[key] = value.toJson();
    });
    return json;
  }
}

class DayHours {
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final bool is24Hours;

  DayHours({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
    this.is24Hours = false,
  });

  factory DayHours.fromJson(Map<String, dynamic> json) {
    return DayHours(
      isOpen: json['is_open'] ?? false,
      openTime: json['open_time'] ?? '09:00',
      closeTime: json['close_time'] ?? '18:00',
      is24Hours: json['is_24_hours'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_open': isOpen,
      'open_time': openTime,
      'close_time': closeTime,
      'is_24_hours': is24Hours,
    };
  }
}

class BusinessStats {
  final int totalBookings;
  final int activeBookings;
  final int completedBookings;
  final int cancelledBookings;
  final int totalCustomers;
  final int activeCustomers;
  final double totalRevenue;
  final double monthlyRevenue;
  final int totalProducts;
  final int activeProducts;

  BusinessStats({
    required this.totalBookings,
    required this.activeBookings,
    required this.completedBookings,
    required this.cancelledBookings,
    required this.totalCustomers,
    required this.activeCustomers,
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.totalProducts,
    required this.activeProducts,
  });

  factory BusinessStats.fromJson(Map<String, dynamic> json) {
    return BusinessStats(
      totalBookings: json['total_bookings'] ?? 0,
      activeBookings: json['active_bookings'] ?? 0,
      completedBookings: json['completed_bookings'] ?? 0,
      cancelledBookings: json['cancelled_bookings'] ?? 0,
      totalCustomers: json['total_customers'] ?? 0,
      activeCustomers: json['active_customers'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0.0).toDouble(),
      monthlyRevenue: (json['monthly_revenue'] ?? 0.0).toDouble(),
      totalProducts: json['total_products'] ?? 0,
      activeProducts: json['active_products'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_bookings': totalBookings,
      'active_bookings': activeBookings,
      'completed_bookings': completedBookings,
      'cancelled_bookings': cancelledBookings,
      'total_customers': totalCustomers,
      'active_customers': activeCustomers,
      'total_revenue': totalRevenue,
      'monthly_revenue': monthlyRevenue,
      'total_products': totalProducts,
      'active_products': activeProducts,
    };
  }
}
