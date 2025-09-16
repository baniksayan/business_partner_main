// lib/views/customers/customers_list_screen.dart - NO DUMMY DATA VERSION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../resources/colors/app_colors.dart';
import '../../providers/customer_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/customer.dart';
import '../settings/help_support_screen.dart';

class CustomersListScreen extends StatefulWidget {
  const CustomersListScreen({Key? key}) : super(key: key);

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  String _search = '';
  String _sort = 'Recent'; // 'Recent', 'Most Active', 'Name A–Z'

  @override
  void initState() {
    super.initState();
    print('👥 [CustomersListScreen] Initializing...');
    
    // Load customers when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCustomers();
    });
  }

  Future<void> _loadCustomers() async {
    print('👥 [CustomersListScreen] Loading customers...');
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    await customerProvider.getAllCustomers(context);
  }

  Future<void> _refreshCustomers() async {
    print('🔄 [CustomersListScreen] Refreshing customers...');
    await _loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: SafeArea(
        child: Consumer<CustomerProvider>(
          builder: (context, customerProvider, child) {
            return Column(
              children: [
                _buildHeader(context, customerProvider),
                
                // ✅ Only show search if we have customers or are loading
                if (customerProvider.isLoading || customerProvider.customers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      decoration: InputDecoration(
                        hintText: "Search customers by name, phone...",
                        prefixIcon: Icon(Icons.search, color: AppColors.splashDots),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                
                // ✅ Only show sort chips if we have customers
                if (customerProvider.customers.isNotEmpty && !customerProvider.isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildSortChip('Recent'),
                          SizedBox(width: 10),
                          _buildSortChip('Most Active'),
                          SizedBox(width: 10),
                          _buildSortChip('Name A–Z'),
                        ],
                      ),
                    ),
                  ),
                
                if (customerProvider.customers.isNotEmpty && !customerProvider.isLoading)
                  const SizedBox(height: 12),
                
                Expanded(
                  child: _buildCustomersList(customerProvider),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildCustomersList(CustomerProvider customerProvider) {
    if (customerProvider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.splashDots),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading customers...',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (customerProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Failed to load customers',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              customerProvider.errorMessage!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshCustomers,
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.splashDots,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    // Get filtered customers (only role '1' customers from API)
    final filtered = customerProvider.getFilteredCustomers(
      searchQuery: _search,
      sortBy: _sort,
    );

    // ✅ Enhanced empty states
    if (customerProvider.customers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              'No Customers Found',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'No customers with the required role are available in your system.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshCustomers,
              icon: Icon(Icons.refresh),
              label: Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.splashDots,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    if (filtered.isEmpty && _search.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No customers found',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _search = ''),
              child: Text('Clear search'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshCustomers,
      color: AppColors.splashDots,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, i) {
          final customer = filtered[i];
          return InkWell(
            onTap: () {
              print('👤 [CustomersListScreen] Tapping customer: ${customer.id}');
              Navigator.pushNamed(
                context,
                '/customer-details',
                arguments: customer, // Pass the Customer object directly
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Customer Avatar (from API or fallback)
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.splashSecondary.withOpacity(0.12),
                    child: customer.avatar.isNotEmpty && customer.avatar.startsWith('http')
                        ? ClipOval(
                            child: Image.network(
                              customer.avatar,
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                              errorBuilder: (context, error, stackTrace) => 
                                _buildAvatarFallback(customer.name),
                            ),
                          )
                        : _buildAvatarFallback(customer.name),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Name (from API)
                        Text(
                          customer.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: AppColors.splashText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.phone, color: AppColors.splashDots, size: 15),
                            const SizedBox(width: 4),
                            Text(
                              customer.phone,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13.2,
                                letterSpacing: 0.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        // Show booking count if available
                        if (customer.totalBookings > 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${customer.totalBookings} booking${customer.totalBookings != 1 ? 's' : ''}',
                            style: TextStyle(
                              color: AppColors.splashDots,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.splashDots, size: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.splashDots,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CustomerProvider customerProvider) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 22, color: AppColors.splashText),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Customers",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.splashText,
                ),
              ),
              // ✅ Show customer count
              if (!customerProvider.isLoading && customerProvider.customers.isNotEmpty)
                Text(
                  '${customerProvider.customers.length} total',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.splashDots,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 25,
            height: 25,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AppColors.splashDots),
              onSelected: (val) {
                if (val == "help") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpSupportScreen(),
                    ),
                  );
                } else if (val == "refresh") {
                  _refreshCustomers();
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: "refresh", child: Text('Refresh Data')),
                PopupMenuItem(value: "import", child: Text('Import CSV')),
                PopupMenuItem(value: "export", child: Text('Export CSV')),
                PopupMenuItem(value: "help", child: Text('Customer Help')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label) {
    final isSelected = _sort == label;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.splashDots,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.splashDots,
      backgroundColor: Colors.grey[100],
      onSelected: (_) => setState(() => _sort = label),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navButton(Icons.dashboard, "Dashboard", () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }),
          _navButton(Icons.shopping_bag_outlined, "Products", () {
            Navigator.pushReplacementNamed(context, '/products');
          }),
          _navButton(Icons.book_online_outlined, "Bookings", () {
            Navigator.pushReplacementNamed(context, '/bookings');
          }),
          _navButton(Icons.person_outline, "Profile", () {
            Navigator.pushReplacementNamed(context, '/profile');
          }),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.splashDots, size: 24),
          Text(
            label,
            style: TextStyle(
              color: AppColors.splashDots,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
