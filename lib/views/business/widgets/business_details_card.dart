// lib/views/business/widgets/business_details_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/business.dart';

class BusinessDetailsCard extends StatefulWidget {
  final Business business;
  final bool isEditing;
  final Function(Business) onBusinessUpdated;

  const BusinessDetailsCard({
    Key? key,
    required this.business,
    required this.isEditing,
    required this.onBusinessUpdated,
  }) : super(key: key);

  @override
  State<BusinessDetailsCard> createState() => _BusinessDetailsCardState();
}

class _BusinessDetailsCardState extends State<BusinessDetailsCard> {
  late TextEditingController _nameController;
  late TextEditingController _ownerController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _websiteController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.business.name);
    _ownerController = TextEditingController(text: widget.business.ownerName);
    _emailController = TextEditingController(text: widget.business.email);
    _phoneController = TextEditingController(text: widget.business.phone);
    _addressController = TextEditingController(text: widget.business.address);
    _cityController = TextEditingController(text: widget.business.city);
    _stateController = TextEditingController(text: widget.business.state);
    _zipController = TextEditingController(text: widget.business.zipCode);
    _websiteController = TextEditingController(text: widget.business.website);
    _descriptionController = TextEditingController(text: widget.business.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.business_center,
                  color: const Color(0xFF2E7D32),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Business Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Business Name
            _buildDetailField(
              label: 'Business Name',
              controller: _nameController,
              icon: Icons.store,
              isEditing: widget.isEditing,
            ),
            
            const SizedBox(height: 16),
            
            // Owner Name
            _buildDetailField(
              label: 'Owner Name',
              controller: _ownerController,
              icon: Icons.person,
              isEditing: widget.isEditing,
            ),
            
            const SizedBox(height: 16),
            
            // Contact Information
            Row(
              children: [
                Expanded(
                  child: _buildDetailField(
                    label: 'Email',
                    controller: _emailController,
                    icon: Icons.email,
                    isEditing: widget.isEditing,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDetailField(
                    label: 'Phone',
                    controller: _phoneController,
                    icon: Icons.phone,
                    isEditing: widget.isEditing,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Address
            _buildDetailField(
              label: 'Address',
              controller: _addressController,
              icon: Icons.location_on,
              isEditing: widget.isEditing,
              maxLines: 2,
            ),
            
            const SizedBox(height: 16),
            
            // City, State, ZIP
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDetailField(
                    label: 'City',
                    controller: _cityController,
                    icon: Icons.location_city,
                    isEditing: widget.isEditing,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _buildDetailField(
                    label: 'State',
                    controller: _stateController,
                    icon: Icons.map,
                    isEditing: widget.isEditing,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: _buildDetailField(
                    label: 'ZIP',
                    controller: _zipController,
                    icon: Icons.local_post_office,
                    isEditing: widget.isEditing,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Website
            _buildDetailField(
              label: 'Website',
              controller: _websiteController,
              icon: Icons.language,
              isEditing: widget.isEditing,
              keyboardType: TextInputType.url,
            ),
            
            const SizedBox(height: 16),
            
            // Description
            _buildDetailField(
              label: 'Description',
              controller: _descriptionController,
              icon: Icons.description,
              isEditing: widget.isEditing,
              maxLines: 3,
            ),
            
            const SizedBox(height: 20),
            
            // Social Media Links
            _buildSocialMediaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEditing,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isEditing ? const Color(0xFF2E7D32) : Colors.grey[300]!,
              width: isEditing ? 1.5 : 1,
            ),
            color: isEditing ? Colors.white : Colors.grey[50],
          ),
          child: TextField(
            controller: controller,
            enabled: isEditing,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 16,
              color: isEditing ? Colors.black87 : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              hintText: isEditing ? 'Enter $label' : null,
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.share,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              'Social Media',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSocialMediaChip(
              label: 'Instagram',
              value: widget.business.socialMedia['instagram'] ?? '',
              icon: Icons.camera_alt,
              color: const Color(0xFFE1306C),
            ),
            const SizedBox(width: 8),
            _buildSocialMediaChip(
              label: 'Facebook',
              value: widget.business.socialMedia['facebook'] ?? '',
              icon: Icons.facebook,
              color: const Color(0xFF1877F2),
            ),
            const SizedBox(width: 8),
            _buildSocialMediaChip(
              label: 'Twitter',
              value: widget.business.socialMedia['twitter'] ?? '',
              icon: Icons.alternate_email,
              color: const Color(0xFF1DA1F2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialMediaChip({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    if (value.isEmpty) return const SizedBox.shrink();
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
