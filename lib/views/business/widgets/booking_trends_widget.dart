// lib/views/business/widgets/booking_trends_widget.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class BookingTrendsWidget extends StatelessWidget {
  final Business business;
  final String selectedPeriod;

  const BookingTrendsWidget({
    Key? key,
    required this.business,
    required this.selectedPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Booking Trends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Booking Status Cards
            Row(
              children: [
                Expanded(child: _buildBookingStatusCard(
                  'Completed',
                  business.stats.completedBookings,
                  Icons.check_circle,
                  Colors.green,
                  '+5.2%',
                )),
                const SizedBox(width: 12),
                Expanded(child: _buildBookingStatusCard(
                  'Active',
                  business.stats.activeBookings,
                  Icons.schedule,
                  Colors.orange,
                  '+12.8%',
                )),
                const SizedBox(width: 12),
                Expanded(child: _buildBookingStatusCard(
                  'Cancelled',
                  business.stats.cancelledBookings,
                  Icons.cancel,
                  Colors.red,
                  '-2.1%',
                )),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Popular Time Slots
            _buildPopularTimeSlots(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingStatusCard(
    String title,
    int count,
    IconData icon,
    Color color,
    String change,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              change,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularTimeSlots() {
    final timeSlots = [
      {'time': '09:00 - 11:00', 'bookings': 45, 'percentage': 0.8},
      {'time': '11:00 - 13:00', 'bookings': 38, 'percentage': 0.68},
      {'time': '13:00 - 15:00', 'bookings': 32, 'percentage': 0.57},
      {'time': '15:00 - 17:00', 'bookings': 42, 'percentage': 0.75},
      {'time': '17:00 - 19:00', 'bookings': 28, 'percentage': 0.5},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Time Slots',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 12),
        ...timeSlots.map((slot) => _buildTimeSlotItem(
          slot['time'] as String,
          slot['bookings'] as int,
          slot['percentage'] as double,
        )).toList(),
      ],
    );
  }

  Widget _buildTimeSlotItem(String time, int bookings, double percentage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[200],
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Text(
              '$bookings',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
