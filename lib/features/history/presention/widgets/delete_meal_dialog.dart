import 'package:flutter/material.dart';

class DeleteMealDialog extends StatelessWidget {
  final Function() onDelete;

  const DeleteMealDialog({
    Key? key,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Meal'),
      content: const Text(
          'Are you sure you want to delete this meal? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            onDelete();
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
