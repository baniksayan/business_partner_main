// lib/providers/business_provider.dart
import 'package:flutter/foundation.dart';
import '../models/business.dart';
import '../services/business_service.dart';

class BusinessProvider extends ChangeNotifier {
  Business? _business;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEditing = false;

  // Getters
  Business? get business => _business;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditing => _isEditing;
  bool get hasData => _business != null;

  final BusinessService _businessService = BusinessService();

  BusinessProvider() {
    print('🏢 [BusinessProvider] Initializing...');
    loadBusinessData();
  }

  // Load business data
  Future<void> loadBusinessData() async {
    print('📊 [BusinessProvider] Loading business data...');
    _setLoading(true);
    _clearError();

    try {
      _business = await _businessService.getBusinessInfo();
      print('✅ [BusinessProvider] Business data loaded successfully');
    } catch (e) {
      print('❌ [BusinessProvider] Error loading business data: $e');
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update business information
  Future<bool> updateBusinessInfo(Business updatedBusiness) async {
    print('📝 [BusinessProvider] Updating business info...');
    _setLoading(true);
    _clearError();

    try {
      final result = await _businessService.updateBusinessInfo(updatedBusiness);
      if (result) {
        _business = updatedBusiness;
        print('✅ [BusinessProvider] Business info updated successfully');
      }
      return result;
    } catch (e) {
      print('❌ [BusinessProvider] Error updating business info: $e');
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update business hours
  Future<bool> updateBusinessHours(BusinessHours businessHours) async {
    print('⏰ [BusinessProvider] Updating business hours...');
    _setLoading(true);
    _clearError();

    try {
      final result = await _businessService.updateBusinessHours(businessHours);
      if (result && _business != null) {
        _business = Business(
          id: _business!.id,
          name: _business!.name,
          ownerName: _business!.ownerName,
          email: _business!.email,
          phone: _business!.phone,
          address: _business!.address,
          city: _business!.city,
          state: _business!.state,
          zipCode: _business!.zipCode,
          country: _business!.country,
          businessType: _business!.businessType,
          description: _business!.description,
          logo: _business!.logo,
          website: _business!.website,
          socialMedia: _business!.socialMedia,
          businessHours: businessHours,
          services: _business!.services,
          rating: _business!.rating,
          totalReviews: _business!.totalReviews,
          isVerified: _business!.isVerified,
          isActive: _business!.isActive,
          createdAt: _business!.createdAt,
          updatedAt: DateTime.now(),
          stats: _business!.stats,
        );
        print('✅ [BusinessProvider] Business hours updated successfully');
      }
      return result;
    } catch (e) {
      print('❌ [BusinessProvider] Error updating business hours: $e');
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh business data
  Future<void> refreshBusinessData() async {
    print('🔄 [BusinessProvider] Refreshing business data...');
    await loadBusinessData();
  }

  // Toggle editing mode
  void toggleEditMode() {
    _isEditing = !_isEditing;
    print('✂️ [BusinessProvider] Edit mode: $_isEditing');
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear all data
  void clearData() {
    print('🗑️ [BusinessProvider] Clearing business data...');
    _business = null;
    _isLoading = false;
    _errorMessage = null;
    _isEditing = false;
    notifyListeners();
  }
}
