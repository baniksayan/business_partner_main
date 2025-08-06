import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/customer-widgets/custom_app_bar.dart';
import 'customer_detail_screen.dart';

class CustomersListScreen extends StatefulWidget {
  @override
  _CustomersListScreenState createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allCustomers = [
    {
      'name': 'Priya Sharma',
      'phone': '+91 98765xxxxx',
      'email': 'priya.sharma@email.com',
      'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
      'tag': 'Frequent',
      'totalBookings': 12,
      'totalSpend': 1500,
      'lastSeen': '2 days ago',
    },
    {
      'name': 'Arjun Verma',
      'phone': '+91 87654xxxxx',
      'email': 'arjun.verma@email.com',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
      'tag': null,
      'totalBookings': 5,
      'totalSpend': 800,
      'lastSeen': '1 week ago',
    },
    {
      'name': 'Divya Kapoor',
      'phone': '+91 76543xxxxx',
      'email': 'divya.kapoor@email.com',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
      'tag': 'VIP',
      'totalBookings': 24,
      'totalSpend': 3200,
      'lastSeen': '1 day ago',
    },
    {
      'name': 'Rohan Singh',
      'phone': '+91 65432xxxxx',
      'email': 'rohan.singh@email.com',
      'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
      'tag': 'Frequent',
      'totalBookings': 8,
      'totalSpend': 1200,
      'lastSeen': '3 days ago',
    },
    {
      'name': 'Anika Patel',
      'phone': '+91 54321xxxxx',
      'email': 'anika.patel@email.com',
      'avatar': 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1119&q=80',
      'tag': null,
      'totalBookings': 3,
      'totalSpend': 450,
      'lastSeen': '1 week ago',
    },
    {
      'name': 'Vikram Joshi',
      'phone': '+91 43210xxxxx',
      'email': 'vikram.joshi@email.com',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
      'tag': 'VIP',
      'totalBookings': 18,
      'totalSpend': 2800,
      'lastSeen': '5 hours ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCustomers {
    List<Map<String, dynamic>> customers = _allCustomers;

    if (_searchQuery.isNotEmpty) {
      customers = customers.where((customer) {
        return customer['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
               customer['phone'].contains(_searchQuery) ||
               (customer['email'] != null && customer['email'].toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    switch (_tabController.index) {
      case 0: // Recent
        customers.sort((a, b) => _getLastSeenSortOrder(a['lastSeen']).compareTo(_getLastSeenSortOrder(b['lastSeen'])));
        break;
      case 1: // Most Active
        customers.sort((a, b) => (b['totalBookings'] as int).compareTo(a['totalBookings'] as int));
        break;
      case 2: // Name A-Z
        customers.sort((a, b) => a['name'].compareTo(b['name']));
        break; 
    }

    return customers;
  }

  int _getLastSeenSortOrder(String lastSeen) {
    if (lastSeen.contains('hour')) return 1;
    if (lastSeen.contains('day')) return 2;
    if (lastSeen.contains('week')) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Customers',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Display',
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'SF Pro Display',
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Search customers by name, phone...',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF Pro Display',
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(14),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                    size: 22,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Color(0xFF007AFF), width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              ),
            ),
          ),

          // Filter Tabs
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: TabBar(
              controller: _tabController, 
              indicator: BoxDecoration(),
              labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
              dividerColor: Colors.transparent,
              onTap: (index) {
                setState(() {});
              },
              tabs: [
                _buildTab('Recent', 0),
                _buildTab('Most Active', 1),
                _buildTab('Name A-Z', 2),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Customer List
          Expanded(
            child: _filteredCustomers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers[index];
                      return _buildCustomerCard(customer);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    bool isSelected = _tabController.index == index;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF007AFF) : Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Color(0xFF007AFF).withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'SF Pro Display',
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDetailScreen(
                  customerData: customer,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Profile Image
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: customer['avatar'] != null
                        ? Image.network(
                            customer['avatar'],
                            fit: BoxFit.cover,
                            width: 56,
                            height: 56,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildAvatarPlaceholder(customer['name']);
                            },
                          )
                        : _buildAvatarPlaceholder(customer['name']),
                  ),
                ),
                SizedBox(width: 16.0),
                
                // Customer Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              customer['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                fontFamily: 'SF Pro Display',
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          if (customer['tag'] != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: _getTagColor(customer['tag']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                customer['tag'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getTagColor(customer['tag']),
                                  fontFamily: 'SF Pro Display',
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        customer['phone'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      if (customer['email'] != null) ...[
                        SizedBox(height: 2.0),
                        Text(
                          customer['email'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500],
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Arrow Icon
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String name) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8C5A0),
            Color(0xFFD2A679),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(name),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return 'U';
  }

  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'frequent':
        return Color(0xFF007AFF);
      case 'vip':
        return Color(0xFFFF9500);
      default:
        return Colors.grey[600]!;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No customers found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontFamily: 'SF Pro Display',
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[500],
              fontFamily: 'SF Pro Display',
            ),
          ),
        ],
      ),
    );
  }
}