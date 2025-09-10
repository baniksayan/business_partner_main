import 'package:flutter/material.dart';
import '../../resources/colors/app_colors.dart';
import '../settings/help_support_screen.dart';

class Customer {
  final String name;
  final String phone;
  final String avatar;
  Customer(this.name, this.phone, this.avatar);
}

class CustomersListScreen extends StatefulWidget {
  const CustomersListScreen({Key? key}) : super(key: key);

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  final List<Customer> _customers = [
    Customer('Priya Sharma', '9876xxxxxx', 'assets/images/avatar1.jpg'),
    Customer('Arjun Verma', '8765xxxxxx', 'assets/images/avatar2.jpg'),
    Customer('Divya Kapoor', '7654xxxxxx', 'assets/images/avatar3.jpg'),
    Customer('Rohan Singh', '6543xxxxxx', 'assets/images/avatar4.jpg'),
    Customer('Anika Patel', '6432xxxxxx', 'assets/images/avatar5.jpg'),
    Customer('Vikram Joshi', '9321xxxxxx', 'assets/images/avatar6.jpg'),
  ];

  String _search = '';
  String _sort = 'Recent'; // 'Recent', 'Most Active', 'Name A–Z'

  @override
  Widget build(BuildContext context) {
    List<Customer> filtered = _customers
        .where((c) =>
            c.name.toLowerCase().contains(_search.toLowerCase()) ||
            c.phone.contains(_search))
        .toList();

    if (_sort == 'Name A–Z') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
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
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No customers found.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (context, i) {
                        final customer = filtered[i];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/customer-detail',
                              arguments: customer,
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
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.splashSecondary.withOpacity(0.12),
                                  child: ClipOval(
                                    child: Image.asset(
                                      customer.avatar,
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.person,
                                        size: 28,
                                        color: AppColors.splashSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                      )
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          Text(
            "Customers",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.splashText,
            ),
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
                }
                // Handle other menu actions if needed
              },
              itemBuilder: (_) => [
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