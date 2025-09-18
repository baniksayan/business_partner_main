// lib/views/business/widgets/business_hours_card.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class BusinessHoursCard extends StatefulWidget {
  final BusinessHours businessHours;
  final bool isEditing;
  final Function(BusinessHours) onHoursUpdated;

  const BusinessHoursCard({
    Key? key,
    required this.businessHours,
    required this.isEditing,
    required this.onHoursUpdated,
  }) : super(key: key);

  @override
  State<BusinessHoursCard> createState() => _BusinessHoursCardState();
}

class _BusinessHoursCardState extends State<BusinessHoursCard> {
  late Map<String, DayHours> _schedule;

  final List<String> _weekDays = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  final Map<String, String> _dayNames = {
    'monday': 'Monday',
    'tuesday': 'Tuesday',
    'wednesday': 'Wednesday',
    'thursday': 'Thursday',
    'friday': 'Friday',
    'saturday': 'Saturday',
    'sunday': 'Sunday',
  };

  @override
  void initState() {
    super.initState();
    _schedule = Map.from(widget.businessHours.schedule);
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
                  Icons.access_time,
                  color: const Color(0xFF2E7D32),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Business Hours',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Week Days Schedule
            Column(
              children: _weekDays.map((day) => _buildDayScheduleRow(day)).toList(),
            ),
            
            if (widget.isEditing) ...[
              const SizedBox(height: 16),
              _buildQuickActions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDayScheduleRow(String day) {
    final dayHours = _schedule[day] ?? DayHours(isOpen: false, openTime: '09:00', closeTime: '18:00');
    final isToday = _isToday(day);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isToday 
            ? const Color(0xFF2E7D32).withOpacity(0.1)
            : Colors.grey[50],
        border: Border.all(
          color: isToday 
              ? const Color(0xFF2E7D32).withOpacity(0.3)
              : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          // Day Name
          Container(
            width: 80,
            child: Text(
              _dayNames[day]!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                color: isToday ? const Color(0xFF2E7D32) : Colors.black87,
              ),
            ),
          ),
          
          // Status Switch
          if (widget.isEditing) ...[
            Switch(
              value: dayHours.isOpen,
              onChanged: (value) {
                setState(() {
                  _schedule[day] = DayHours(
                    isOpen: value,
                    openTime: dayHours.openTime,
                    closeTime: dayHours.closeTime,
                  );
                });
              },
              activeColor: const Color(0xFF2E7D32),
            ),
            const SizedBox(width: 16),
          ] else ...[
            const SizedBox(width: 16),
          ],
          
          // Hours Display/Edit
          Expanded(
            child: dayHours.isOpen
                ? _buildHoursDisplay(day, dayHours)
                : Text(
                    'Closed',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
          
          // Status Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: dayHours.isOpen 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              dayHours.isOpen ? 'Open' : 'Closed',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: dayHours.isOpen ? Colors.green : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursDisplay(String day, DayHours dayHours) {
    if (!widget.isEditing) {
      return Text(
        '${_formatTime(dayHours.openTime)} - ${_formatTime(dayHours.closeTime)}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      );
    }

    return Row(
      children: [
        // Open Time
        Expanded(
          child: GestureDetector(
            onTap: () => _selectTime(day, true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2E7D32)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatTime(dayHours.openTime),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('-'),
        ),
        
        // Close Time
        Expanded(
          child: GestureDetector(
            onTap: () => _selectTime(day, false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2E7D32)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatTime(dayHours.closeTime),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
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
              child: ElevatedButton.icon(
                onPressed: _setStandardHours,
                icon: const Icon(Icons.work_outline),
                label: const Text('Standard Hours'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _closeAllDays,
                icon: const Icon(Icons.close),
                label: const Text('Close All'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _selectTime(String day, bool isOpenTime) async {
    final dayHours = _schedule[day]!;
    final currentTime = isOpenTime ? dayHours.openTime : dayHours.closeTime;
    
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _parseTime(currentTime),
    );

    if (time != null) {
      final timeString = _timeOfDayToString(time);
      setState(() {
        _schedule[day] = DayHours(
          isOpen: dayHours.isOpen,
          openTime: isOpenTime ? timeString : dayHours.openTime,
          closeTime: isOpenTime ? dayHours.closeTime : timeString,
        );
      });
    }
  }

  void _setStandardHours() {
    setState(() {
      for (String day in ['monday', 'tuesday', 'wednesday', 'thursday', 'friday']) {
        _schedule[day] =  DayHours(
          isOpen: true,
          openTime: '09:00',
          closeTime: '18:00',
        );
      }
      _schedule['saturday'] =  DayHours(
        isOpen: true,
        openTime: '10:00',
        closeTime: '16:00',
      );
      _schedule['sunday'] =  DayHours(
        isOpen: false,
        openTime: '10:00',
        closeTime: '16:00',
      );
    });
  }

  void _closeAllDays() {
    setState(() {
      for (String day in _weekDays) {
        final currentHours = _schedule[day]!;
        _schedule[day] = DayHours(
          isOpen: false,
          openTime: currentHours.openTime,
          closeTime: currentHours.closeTime,
        );
      }
    });
  }

  bool _isToday(String day) {
    final today = DateTime.now().weekday;
    final dayIndex = _weekDays.indexOf(day) + 1;
    return today == dayIndex;
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    
    if (hour == 0) return '12:$minute AM';
    if (hour < 12) return '$hour:$minute AM';
    if (hour == 12) return '12:$minute PM';
    return '${hour - 12}:$minute PM';
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
