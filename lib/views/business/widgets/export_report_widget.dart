// lib/views/business/widgets/export_report_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExportReportWidget extends StatefulWidget {
  final String period;
  final DateTime startDate;
  final DateTime endDate;

  const ExportReportWidget({
    Key? key,
    required this.period,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<ExportReportWidget> createState() => _ExportReportWidgetState();
}

class _ExportReportWidgetState extends State<ExportReportWidget> {
  String _selectedFormat = 'PDF';
  final List<String> _formats = ['PDF', 'Excel', 'CSV'];
  
  final List<String> _reportTypes = [
    'Complete Business Report',
    'Financial Summary',
    'Customer Analytics',
    'Service Performance',
    'Revenue Analysis',
    'Custom Report'
  ];
  
  final List<bool> _selectedReports = [true, false, false, false, false, false];
  final TextEditingController _emailController = TextEditingController();
  bool _includeCharts = true;
  bool _includeRawData = false;
  bool _sendToEmail = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.file_download, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Export Business Report',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Period Info
                    _buildPeriodInfo(),
                    
                    const SizedBox(height: 20),
                    
                    // Format Selection
                    _buildFormatSelection(),
                    
                    const SizedBox(height: 20),
                    
                    // Report Type Selection
                    _buildReportTypeSelection(),
                    
                    const SizedBox(height: 20),
                    
                    // Export Options
                    _buildExportOptions(),
                    
                    const SizedBox(height: 20),
                    
                    // Email Option
                    _buildEmailOption(),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _exportReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Export Report',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.date_range, color: const Color(0xFF2E7D32), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Report Period',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.period == 'Custom Range' 
                ? '${widget.startDate.day}/${widget.startDate.month}/${widget.startDate.year} - ${widget.endDate.day}/${widget.endDate.month}/${widget.endDate.year}'
                : widget.period,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Export Format',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: _formats.map((format) {
            final isSelected = _selectedFormat == format;
            final icons = {
              'PDF': Icons.picture_as_pdf,
              'Excel': Icons.table_chart,
              'CSV': Icons.description,
            };
            
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFormat = format),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected 
                          ? const Color(0xFF2E7D32).withOpacity(0.1)
                          : Colors.grey[100],
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFF2E7D32)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          icons[format],
                          color: isSelected 
                              ? const Color(0xFF2E7D32)
                              : Colors.grey[600],
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          format,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? const Color(0xFF2E7D32)
                                : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReportTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Report Sections',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: _reportTypes.asMap().entries.map((entry) {
              final index = entry.key;
              final reportType = entry.value;
              final isSelected = _selectedReports[index];
              
              return Container(
                decoration: BoxDecoration(
                  border: index > 0 
                      ? Border(top: BorderSide(color: Colors.grey[300]!))
                      : null,
                ),
                child: CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      _selectedReports[index] = value ?? false;
                    });
                  },
                  title: Text(
                    reportType,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  activeColor: const Color(0xFF2E7D32),
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExportOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Export Options',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              CheckboxListTile(
                value: _includeCharts,
                onChanged: (value) => setState(() => _includeCharts = value ?? false),
                title: const Text(
                  'Include Charts & Graphs',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Visual representations of data',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                activeColor: const Color(0xFF2E7D32),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              Divider(height: 1, color: Colors.grey[300]),
              CheckboxListTile(
                value: _includeRawData,
                onChanged: (value) => setState(() => _includeRawData = value ?? false),
                title: const Text(
                  'Include Raw Data',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Detailed transaction records',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                activeColor: const Color(0xFF2E7D32),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: _sendToEmail,
          onChanged: (value) => setState(() => _sendToEmail = value ?? false),
          title: const Text(
            'Send to Email',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'Email the report instead of downloading',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          activeColor: const Color(0xFF2E7D32),
          contentPadding: EdgeInsets.zero,
        ),
        
        if (_sendToEmail) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter email address',
              prefixIcon: const Icon(Icons.email, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _exportReport() {
    // Validate selections
    final hasSelectedReports = _selectedReports.any((selected) => selected);
    
    if (!hasSelectedReports) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one report section'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_sendToEmail && _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simulate export process
    Navigator.of(context).pop();
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 16),
            Text(
              _sendToEmail ? 'Sending report to email...' : 'Generating report...',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );

    // Simulate processing time
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close loading dialog
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _sendToEmail 
                ? 'Report sent to ${_emailController.text} successfully!'
                : 'Report downloaded successfully!',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Vibrate for feedback
      HapticFeedback.lightImpact();
    });
  }
}
