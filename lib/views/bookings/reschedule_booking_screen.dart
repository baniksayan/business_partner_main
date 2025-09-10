import 'package:flutter/material.dart';
import '../../resources/colors/app_colors.dart';
import '../../resources/styles/text_styles.dart';

class RescheduleBookingScreen extends StatefulWidget {
  final Map<String, dynamic> booking;

  const RescheduleBookingScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<RescheduleBookingScreen> createState() => _RescheduleBookingScreenState();
}

class _RescheduleBookingScreenState extends State<RescheduleBookingScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '2:00 PM';
  
  final List<String> availableTimes = [
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.splashText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Reschedule Booking', style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Booking Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Original Booking',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date: ${widget.booking['date']}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Service: Men\'s Haircut',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Duration: 1 hour',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time: ${widget.booking['time']}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Select New Date
            Text(
              'Select New Date',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Calendar Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month - 1,
                                1,
                              );
                            });
                          },
                          icon: Icon(Icons.chevron_left, color: AppColors.splashText),
                        ),
                        Text(
                          '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month + 1,
                                1,
                              );
                            });
                          },
                          icon: Icon(Icons.chevron_right, color: AppColors.splashText),
                        ),
                      ],
                    ),
                  ),
                  
                  // Calendar Grid
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Week days header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                              .map((day) => Container(
                                    width: 32,
                                    height: 32,
                                    alignment: Alignment.center,
                                    child: Text(
                                      day,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        
                        // Calendar days
                        ..._buildCalendarRows(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Select New Time
            Text(
              'Select New Time',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: availableTimes.map((time) {
                  final isSelected = time == selectedTime;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.splashDots.withOpacity(0.1) : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.splashDots : Colors.grey[200]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            time,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: isSelected ? AppColors.splashDots : AppColors.splashText,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Booking rescheduled successfully'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.splashDots,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Confirm Reschedule',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCalendarRows() {
    List<Widget> rows = [];
    DateTime firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    DateTime lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    
    int startingWeekday = firstDayOfMonth.weekday % 7;
    int daysInMonth = lastDayOfMonth.day;
    
    List<Widget> currentWeek = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 0; i < startingWeekday; i++) {
      currentWeek.add(Container(width: 32, height: 32));
    }
    
    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime dayDate = DateTime(selectedDate.year, selectedDate.month, day);
      bool isSelected = selectedDate.day == day;
      bool isToday = DateTime.now().day == day && 
                   DateTime.now().month == selectedDate.month && 
                   DateTime.now().year == selectedDate.year;
      
      currentWeek.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = dayDate;
            });
          },
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.splashDots : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday ? Border.all(color: AppColors.splashDots, width: 1) : null,
            ),
            child: Text(
              day.toString(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.splashText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
      
      if (currentWeek.length == 7) {
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: currentWeek,
            ),
          ),
        );
        currentWeek = [];
      }
    }
    
    // Add the last incomplete week if it exists
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(Container(width: 32, height: 32));
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: currentWeek,
        ),
      );
    }
    
    return rows;
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}