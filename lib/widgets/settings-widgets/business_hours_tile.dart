import 'package:flutter/material.dart';
import '../../views/styles/app_colors.dart'; 
import '../../views/styles/app_text_styles.dart';

class BusinessHoursTile extends StatelessWidget {
  final String day;
  final bool isOpen;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Function(bool) onToggle;
  final Function(TimeOfDay) onStartTimeChanged;
  final Function(TimeOfDay) onEndTimeChanged;

  const BusinessHoursTile({
    Key? key,
    required this.day,
    required this.isOpen,
    required this.startTime,
    required this.endTime,
    required this.onToggle,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Switch(
                  value: isOpen,
                  onChanged: onToggle,
                  activeColor: AppColors.primaryColor,
                ),
              ],
            ),
            if (isOpen) ...[
              SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeSelector(
                      context,
                      'Start Time',
                      startTime,
                      onStartTimeChanged,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: _buildTimeSelector(
                      context,
                      'End Time',
                      endTime,
                      onEndTimeChanged,
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Closed',
                  style: AppTextStyles.captionText,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(
    BuildContext context,
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.captionText,
        ),
        SizedBox(height: 4.0),
        GestureDetector(
          onTap: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (selectedTime != null) {
              onChanged(selectedTime);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColors.dividerColor),
            ),
            child: Text(
              time.format(context),
              style: AppTextStyles.bodyText,
            ),
          ),
        ),
      ],
    );
  }
}
