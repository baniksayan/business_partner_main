import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/settings-widgets/custom_app_bar.dart';
import '../../widgets/settings-widgets/business_hours_tile.dart';

class BusinessHoursScreen extends StatefulWidget {
  @override
  _BusinessHoursScreenState createState() => _BusinessHoursScreenState();
}

class _BusinessHoursScreenState extends State<BusinessHoursScreen> {
  final List<Map<String, dynamic>> _businessHours = [
    {
      'day': 'Monday',
      'isOpen': true,
      'startTime': TimeOfDay(hour: 9, minute: 0),
      'endTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Tuesday',
      'isOpen': true,
      'startTime': TimeOfDay(hour: 9, minute: 0),
      'endTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Wednesday',
      'isOpen': true,
      'startTime': TimeOfDay(hour: 9, minute: 0),
      'endTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Thursday',
      'isOpen': true,
      'startTime': TimeOfDay(hour: 9, minute: 0),
      'endTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Friday',
      'isOpen': true,
      'startTime': TimeOfDay(hour: 9, minute: 0),
      'endTime': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Saturday',
      'isOpen': true,
      'startTime': TimeOfDay(hour: 8, minute: 0),
      'endTime': TimeOfDay(hour: 16, minute: 0),
    },
    {
      'day': 'Sunday',
      'isOpen': false,
      'startTime': TimeOfDay(hour: 9, minute: 0),
      'endTime': TimeOfDay(hour: 17, minute: 0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Business Hours',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              itemCount: _businessHours.length,
              itemBuilder: (context, index) {
                final dayData = _businessHours[index];
                return BusinessHoursTile(
                  day: dayData['day'],
                  isOpen: dayData['isOpen'],
                  startTime: dayData['startTime'],
                  endTime: dayData['endTime'],
                  onToggle: (isOpen) {
                    setState(() {
                      _businessHours[index]['isOpen'] = isOpen;
                    });
                  },
                  onStartTimeChanged: (time) {
                    setState(() {
                      _businessHours[index]['startTime'] = time;
                    });
                  },
                  onEndTimeChanged: (time) {
                    setState(() {
                      _businessHours[index]['endTime'] = time;
                    });
                  },
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      side: BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.buttonText.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Save business hours and navigate back
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Save Hours',
                      style: AppTextStyles.buttonText.copyWith(
                        color: Colors.white,
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
}
