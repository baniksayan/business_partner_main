import 'package:flutter/material.dart';
import '../../resources/styles/text_styles.dart';
import '../../models/notification_model.dart';

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({Key? key}) : super(key: key);

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentStep = 0;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  NotificationTemplate? _selectedTemplate;

  final List<String> _filters = ['All', 'SMS', 'Email', 'Offers', 'Reminders'];

  // Mock templates data
  final List<NotificationTemplate> _templates = [
    NotificationTemplate(
      id: '1',
      name: 'New Customer Welcome',
      subject: 'Welcome to our community!',
      content:
          'Welcome to our community! We\'re thrilled to have you. Enjoy a special discount on your first purchase.',
      type: NotificationType.sms,
      imageUrl: 'assets/images/template1.jpg',
      variables: ['Customer Name', 'Discount Code'],
    ),
    NotificationTemplate(
      id: '2',
      name: 'Appointment Reminder',
      subject: 'Appointment Tomorrow',
      content:
          'Your appointment is scheduled for tomorrow at 2 PM. Please arrive 10 minutes early. We look forward to seeing you!',
      type: NotificationType.email,
      imageUrl: 'assets/images/template2.jpg',
      variables: ['Appointment Time', 'Service Type'],
    ),
    NotificationTemplate(
      id: '3',
      name: 'Special Offer',
      subject: 'Limited Time Offer!',
      content:
          'Flash sale! Get 20% off on all items for the next 24 hours. Don\'t miss out on this limited-time offer!',
      type: NotificationType.sms,
      imageUrl: 'assets/images/template3.jpg',
      variables: ['Discount Percentage', 'Expiry Date'],
    ),
    NotificationTemplate(
      id: '4',
      name: 'Order Confirmation',
      subject: 'Order Confirmed',
      content:
          'Your order #12345 has been confirmed and is being processed. You\'ll receive a shipping update soon.',
      type: NotificationType.email,
      imageUrl: 'assets/images/template4.jpg',
      variables: ['Order Number', 'Customer Name'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<NotificationTemplate> get _filteredTemplates {
    return _templates.where((template) {
      bool matchesSearch =
          _searchQuery.isEmpty ||
          template.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          template.subject.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesFilter =
          _selectedFilter == 'All' ||
          template.type.toString().split('.').last.toLowerCase() ==
              _selectedFilter.toLowerCase() ||
          (_selectedFilter == 'Offers' &&
              template.name.toLowerCase().contains('offer')) ||
          (_selectedFilter == 'Reminders' &&
              template.name.toLowerCase().contains('reminder'));

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Content based on current step
              Expanded(
                child:
                    _currentStep == 0
                        ? _buildTemplateSelection()
                        : _buildTemplateEditor(),
              ),

              // Bottom Button
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF2C3E50),
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          const Spacer(),

          // Title
          Text(
            'Send Notification',
            style: AppTextStyles.heading3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // Step Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4FC3F7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentStep + 1}/2',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF4FC3F7),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateSelection() {
    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: const InputDecoration(
              icon: Icon(Icons.search, color: Color(0xFF4FC3F7)),
              hintText: 'Search templates',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),

        // Filters
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = _selectedFilter == filter;

              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  selectedColor: const Color(0xFF4FC3F7).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF4FC3F7),
                  labelStyle: TextStyle(
                    color:
                        isSelected ? const Color(0xFF4FC3F7) : Colors.grey[600],
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),

        // Templates List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredTemplates.length,
            itemBuilder: (context, index) {
              final template = _filteredTemplates[index];
              return _buildTemplateCard(template);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateCard(NotificationTemplate template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Template Preview Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _getTypeColor(template.type).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  top: -10,
                  right: -10,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getTypeColor(template.type).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Template preview content
                Center(
                  child: Container(
                    width: 200,
                    height: 80,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _getTypeColor(template.type),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 4,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 4,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Type badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(template.type),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      template.type.toString().split('.').last.toUpperCase(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Template Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  template.content,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTemplate = template;
                          _currentStep = 1;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4FC3F7),
                        side: const BorderSide(color: Color(0xFF4FC3F7)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Select'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateEditor() {
    if (_selectedTemplate == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template Preview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Template Preview',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _getTypeColor(
                      _selectedTemplate!.type,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getTypeColor(
                        _selectedTemplate!.type,
                      ).withOpacity(0.3),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background decoration
                      Positioned(
                        bottom: -20,
                        right: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: _getTypeColor(
                              _selectedTemplate!.type,
                            ).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, Priya',
                              style: AppTextStyles.heading3.copyWith(
                                color: _getTypeColor(_selectedTemplate!.type),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Text(
                                _selectedTemplate!.content,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Edit Fields
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Fields',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Name Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF4FC3F7),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Offer Field (if applicable)
                if (_selectedTemplate!.name.toLowerCase().contains('offer'))
                  Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Offer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF4FC3F7),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF4FC3F7),
                              width: 2,
                            ),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // Additional fields based on template
                ...List.generate(_selectedTemplate!.variables.length - 1, (
                  index,
                ) {
                  final variable = _selectedTemplate!.variables[index + 1];
                  return Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: variable,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF4FC3F7),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep == 1) ...[
            // Previous Button
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 0;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Edit Previous Step',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Next/Send Button
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep == 0 ? null : _sendNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentStep == 0 ? 'Next: Preview' : 'Send Now',
                style: AppTextStyles.buttonMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.sms:
        return const Color(0xFF4CAF50);
      case NotificationType.email:
        return const Color(0xFF2196F3);
      case NotificationType.app:
        return const Color(0xFFFF9800);
      case NotificationType.push:
        return const Color(0xFF9C27B0);
    }
  }

  void _sendNotification() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.send, color: Color(0xFF4FC3F7)),
                SizedBox(width: 8),
                Text('Send Notification'),
              ],
            ),
            content: const Text(
              'Are you sure you want to send this notification to all selected recipients?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to notifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Notification sent successfully!'),
                      backgroundColor: const Color(0xFF4CAF50),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FC3F7),
                ),
                child: const Text('Send'),
              ),
            ],
          ),
    );
  }
}
