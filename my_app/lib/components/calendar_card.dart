import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  const CalendarCard({super.key, required this.selectedDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CalendarDatePicker(
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateChanged: onDateChanged,
        ),
      ),
    );
  }
}