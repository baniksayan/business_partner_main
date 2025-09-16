// lib/providers/customer_provider.dart - FIXED FOR YOUR API
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../services/customer_api_service.dart';
import '../providers/auth_provider.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  List<Customer> _allCustomers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Customer> get customers => _customers;
  List<Customer> get allCustomers => _allCustomers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ✅ FIXED: Handle your API response structure
  Future<void> getAllCustomers(BuildContext context) async {
    print('👥 [CustomerProvider] Loading users from /users/ endpoint...');
    _setLoading(true);
    _setError(null);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (!authProvider.isAuthenticated || authProvider.token == null) {
        _setError('User not authenticated');
        _setLoading(false);
        return;
      }

      print('🔑 [CustomerProvider] Using token: ${authProvider.token!.substring(0, 20)}...');

      final response = await CustomerApiService.getAllCustomers(authProvider.token!);
      
      if (response.success && response.data != null) {
        print('📥 [CustomerProvider] Raw API response: ${response.data}');
        
        // ✅ Handle your API response structure
        List<dynamic> userList = [];
        
        if (response.data['status'] == 'success' && response.data['data'] != null) {
          userList = response.data['data'] as List<dynamic>;
          print('📋 [CustomerProvider] Found ${userList.length} users in API response');
        } else {
          print('❌ [CustomerProvider] Unexpected API response format');
          _setError('Invalid API response format');
          _setLoading(false);
          return;
        }

        // Parse all users
        _allCustomers = userList.map((userJson) {
          try {
            return Customer.fromJson(userJson);
          } catch (e) {
            print('❌ [CustomerProvider] Error parsing user: $e');
            print('📦 [CustomerProvider] Problem data: $userJson');
            return null;
          }
        }).where((customer) => customer != null).cast<Customer>().toList();

        print('📋 [CustomerProvider] Parsed ${_allCustomers.length} total users');

        // ✅ FILTER: Only show users with role 1
        _customers = _allCustomers.where((customer) {
          final shouldShow = customer.shouldShow;
          if (shouldShow) {
            print('✅ [CustomerProvider] Including user: ${customer.name} (roles: ${customer.roles})');
          }
          return shouldShow;
        }).toList();

        print('✅ [CustomerProvider] Filtered to ${_customers.length} users with role 1');
        
        if (_customers.isEmpty) {
          print('📝 [CustomerProvider] No users with role 1 found');
        }
      } else {
        print('⚠️ [CustomerProvider] API failed: ${response.error}');
        _setError(response.error ?? 'Failed to load users');
        _customers = [];
      }
    } catch (e) {
      print('❌ [CustomerProvider] Error: $e');
      _setError('Failed to load users: $e');
      _customers = [];
    } finally {
      _setLoading(false);
    }
  }

  // Search and filter customers
  List<Customer> getFilteredCustomers({String? searchQuery, String? sortBy}) {
    List<Customer> filtered = List.from(_customers);

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((customer) =>
          customer.name.toLowerCase().contains(query) ||
          customer.phone.contains(query) ||
          customer.email.toLowerCase().contains(query) ||
          customer.city.toLowerCase().contains(query)).toList();
    }

    // Apply sorting
    switch (sortBy) {
      case 'Name A–Z':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Most Active':
        // Sort by designation or bio length as activity indicator
        filtered.sort((a, b) => b.designation.length.compareTo(a.designation.length));
        break;
      case 'Recent':
      default:
        // Sort by ID (assuming higher ID = more recent)
        filtered.sort((a, b) => b.id.compareTo(a.id));
        break;
    }

    return filtered;
  }

  // Refresh customers
  Future<void> refreshCustomers(BuildContext context) async {
    print('🔄 [CustomerProvider] Refreshing users...');
    await getAllCustomers(context);
  }

  // Get customer by ID
  Customer? getCustomerById(String id) {
    try {
      return _customers.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get customer statistics
  Map<String, int> getCustomerStats() {
    return {
      'total': _customers.length,
      'active': _customers.where((c) => c.isActive).length,
      'with_designation': _customers.where((c) => c.designation.isNotEmpty).length,
    };
  }
}
