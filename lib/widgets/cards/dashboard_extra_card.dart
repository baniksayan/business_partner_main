import 'package:flutter/material.dart';

class DashboardExtraCard extends StatelessWidget {
  final IconData icon;
  final String title, value, subtext;
  final Color background;

  const DashboardExtraCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtext,
    this.background = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 9),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.blueGrey[700]),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: const Color(0xFF2C3E50),
          ),
        ),
        subtitle: Text(
          subtext,
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: const Color(0xFF4FC3F7),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
