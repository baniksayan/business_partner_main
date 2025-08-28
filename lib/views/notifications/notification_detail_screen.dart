import 'package:flutter/material.dart';
import '../../resources/styles/text_styles.dart';
import '../../models/notification_model.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock recipients data
  final List<Recipient> _recipients = [
    Recipient(
      name: 'Priya Mitra',
      status: RecipientStatus.delivered,
      avatar: 'assets/images/avatar1.png',
    ),
    Recipient(
      name: 'Sayan Banik',
      status: RecipientStatus.delivered,
      avatar: 'assets/images/avatar2.png',
    ),
    Recipient(
      name: 'Divya Kapoor',
      status: RecipientStatus.failed,
      avatar: 'assets/images/avatar3.png',
    ),
    Recipient(
      name: 'Rahul Sharma',
      status: RecipientStatus.pending,
      avatar: 'assets/images/avatar4.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Notification Info
                        _buildNotificationInfo(),
                        
                        const SizedBox(height: 24),
                        
                        // Message Content
                        _buildMessageContent(),
                        
                        const SizedBox(height: 24),
                        
                        // Recipients
                        _buildRecipients(),
                        
                        const SizedBox(height: 100), // Space for buttons
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
      // Action Buttons
      bottomNavigationBar: _buildActionButtons(),
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
            'Notification Details',
            style: AppTextStyles.heading3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const Spacer(),
          
          // More Actions
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF4FC3F7)),
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  _deleteNotification();
                  break;
                case 'share':
                  _shareNotification();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share_outlined, color: Color(0xFF4FC3F7)),
                    SizedBox(width: 12),
                    Text('Share'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationInfo() {
    return Container(
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTypeColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(),
                  color: _getTypeColor(),
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notification.title,
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sent ${widget.notification.formattedTime}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Status indicators
          Row(
            children: [
              _buildStatusChip('Type', widget.notification.type.toString().split('.').last.toUpperCase(), _getTypeColor()),
              const SizedBox(width: 8),
              if (widget.notification.isImportant)
                _buildStatusChip('Priority', 'HIGH', const Color(0xFFE91E63)),
              const SizedBox(width: 8),
              _buildStatusChip('Status', widget.notification.isRead ? 'READ' : 'UNREAD', 
                widget.notification.isRead ? const Color(0xFF4CAF50) : const Color(0xFFFF9800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF81C784).withOpacity(0.8),
            const Color(0xFF66BB6A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF66BB6A).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exciting News! We\'re thrilled to announce the launch of our latest product, designed to revolutionize your experience. Check it out now!',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    height: 1.6,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Action Button
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Opening product details...'),
                            backgroundColor: const Color(0xFF4FC3F7),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF66BB6A),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                      child: Text(
                        'View Product',
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: const Color(0xFF66BB6A),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipients() {
    return Container(
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
          Row(
            children: [
              Text(
                'Recipients',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_recipients.length} recipients',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF4FC3F7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Recipients List
          ...List.generate(_recipients.length, (index) {
            final recipient = _recipients[index];
            return _buildRecipientTile(recipient);
          }),
        ],
      ),
    );
  }

  Widget _buildRecipientTile(Recipient recipient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(recipient.status).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF4FC3F7).withOpacity(0.1),
            child: Text(
              recipient.name.substring(0, 1).toUpperCase(),
              style: AppTextStyles.labelLarge.copyWith(
                color: const Color(0xFF4FC3F7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Name and Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipient.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(recipient.status),
                      color: _getStatusColor(recipient.status),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      recipient.status.toString().split('.').last.toUpperCase(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _getStatusColor(recipient.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildActionButtons() {
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
          // Back to Log
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[600],
                side: BorderSide(color: Colors.grey[300]!),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Back to Log',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Resend Notification
          Expanded(
            child: ElevatedButton(
              onPressed: _resendNotification,
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
                'Resend Notification',
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

  Color _getTypeColor() {
    switch (widget.notification.type) {
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

  IconData _getTypeIcon() {
    switch (widget.notification.type) {
      case NotificationType.sms:
        return Icons.sms_outlined;
      case NotificationType.email:
        return Icons.email_outlined;
      case NotificationType.app:
        return Icons.notifications_outlined;
      case NotificationType.push:
        return Icons.push_pin_outlined;
    }
  }

  Color _getStatusColor(RecipientStatus status) {
    switch (status) {
      case RecipientStatus.delivered:
        return const Color(0xFF4CAF50);
      case RecipientStatus.failed:
        return const Color(0xFFE91E63);
      case RecipientStatus.pending:
        return const Color(0xFFFF9800);
    }
  }

  IconData _getStatusIcon(RecipientStatus status) {
    switch (status) {
      case RecipientStatus.delivered:
        return Icons.check_circle_outline;
      case RecipientStatus.failed:
        return Icons.error_outline;
      case RecipientStatus.pending:
        return Icons.schedule;
    }
  }

  void _deleteNotification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text('Are you sure you want to delete this notification?'),
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
                  content: const Text('Notification deleted'),
                  backgroundColor: const Color(0xFF4CAF50),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _shareNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sharing notification...'),
        backgroundColor: const Color(0xFF4FC3F7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _resendNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Resending notification to failed recipients...'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

enum RecipientStatus { delivered, failed, pending }

class Recipient {
  final String name;
  final RecipientStatus status;
  final String avatar;

  Recipient({
    required this.name,
    required this.status,
    required this.avatar,
  });
}
