import 'package:flutter/material.dart';

class PriorityDropdown extends StatelessWidget {
  final Function(String?) onChanged;

  const PriorityDropdown({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: 'Medium',
      items: ['Low', 'Medium', 'High'].map((String priority) {
        return DropdownMenuItem<String>(
          value: priority,
          child: Text(priority),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: 'Priority'),
    );
  }
}
