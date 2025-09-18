// lib/views/business/widgets/business_services_card.dart
import 'package:flutter/material.dart';

class BusinessServicesCard extends StatefulWidget {
  final List<String> services;
  final bool isEditing;
  final Function(List<String>) onServicesUpdated;

  const BusinessServicesCard({
    Key? key,
    required this.services,
    required this.isEditing,
    required this.onServicesUpdated,
  }) : super(key: key);

  @override
  State<BusinessServicesCard> createState() => _BusinessServicesCardState();
}

class _BusinessServicesCardState extends State<BusinessServicesCard> {
  late List<String> _services;
  final TextEditingController _newServiceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _services = List.from(widget.services);
  }

  @override
  void dispose() {
    _newServiceController.dispose();
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
                  Icons.design_services,
                  color: const Color(0xFF2E7D32),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Services Offered',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_services.length} services',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Services Grid
            _buildServicesGrid(),
            
            if (widget.isEditing) ...[
              const SizedBox(height: 16),
              _buildAddServiceSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid() {
    if (_services.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.design_services_outlined,
                size: 40,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'No services added yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _services.asMap().entries.map((entry) {
        final index = entry.key;
        final service = entry.value;
        return _buildServiceChip(service, index);
      }).toList(),
    );
  }

  Widget _buildServiceChip(String service, int index) {
    final serviceIcons = {
      'Hair Cut & Styling': Icons.content_cut,
      'Hair Coloring': Icons.palette,
      'Manicure & Pedicure': Icons.back_hand,
      'Facial Treatments': Icons.face,
      'Eyebrow Threading': Icons.visibility,
      'Hair Extensions': Icons.extension,
      'Bridal Makeup': Icons.face_retouching_natural,
      'Massage Therapy': Icons.spa,
    };

    final colors = [
      const Color(0xFF1976D2),
      const Color(0xFF388E3C),
      const Color(0xFF7B1FA2),
      const Color(0xFFFF9800),
      const Color(0xFFE91E63),
      const Color(0xFF00796B),
      const Color(0xFFD32F2F),
      const Color(0xFF455A64),
    ];

    final color = colors[index % colors.length];
    final icon = serviceIcons[service] ?? Icons.miscellaneous_services;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            service,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          if (widget.isEditing) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _removeService(index),
              child: Icon(
                Icons.close,
                size: 16,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 12),
        const Text(
          'Add New Service',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newServiceController,
                decoration: InputDecoration(
                  hintText: 'Enter service name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _addService(),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addService,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSuggestedServices(),
      ],
    );
  }

  Widget _buildSuggestedServices() {
    final suggestedServices = [
      'Deep Cleansing Facial',
      'Hair Wash & Blow Dry',
      'Waxing Services',
      'Nail Art',
      'Anti-Aging Treatment',
      'Scalp Treatment',
    ];

    final availableServices = suggestedServices
        .where((service) => !_services.contains(service))
        .toList();

    if (availableServices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Services:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: availableServices.map((service) {
            return GestureDetector(
              onTap: () => _addSuggestedService(service),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      service,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.add,
                      size: 14,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _addService() {
    final service = _newServiceController.text.trim();
    if (service.isNotEmpty && !_services.contains(service)) {
      setState(() {
        _services.add(service);
        _newServiceController.clear();
      });
      widget.onServicesUpdated(_services);
    }
  }

  void _addSuggestedService(String service) {
    setState(() {
      _services.add(service);
    });
    widget.onServicesUpdated(_services);
  }

  void _removeService(int index) {
    setState(() {
      _services.removeAt(index);
    });
    widget.onServicesUpdated(_services);
  }
}
