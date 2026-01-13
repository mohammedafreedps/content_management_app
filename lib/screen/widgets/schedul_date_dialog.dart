import 'package:flutter/material.dart';

class ScheduleDateDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const ScheduleDateDialog({
    super.key,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<ScheduleDateDialog> createState() => _ScheduleDateDialogState();
}

class _ScheduleDateDialogState extends State<ScheduleDateDialog> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Schedule Post'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: widget.firstDate ?? DateTime.now(),
            lastDate:
                widget.lastDate ?? DateTime.now().add(const Duration(days: 365)),
            onDateChanged: (date) {
              setState(() => selectedDate = date);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, selectedDate);
          },
          child: const Text('Schedule'),
        ),
      ],
    );
  }
}
