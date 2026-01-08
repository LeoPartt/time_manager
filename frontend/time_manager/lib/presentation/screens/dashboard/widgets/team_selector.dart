import 'package:flutter/material.dart';

class TeamSelector extends StatelessWidget {
  final String? selectedTeam;
  final ValueChanged<String?> onChanged;

  const TeamSelector({
    super.key,
    required this.selectedTeam,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final teams = ["Team Marguerite", "Team Alpha", "Team Beta"];

    return DropdownButtonFormField<String>(
      initialValue: selectedTeam,
      decoration: InputDecoration(
        labelText: "Select Team",
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text("Personal Dashboard")),
        ...teams.map((t) => DropdownMenuItem(value: t, child: Text(t))),
      ],
      onChanged: onChanged,
      style: textTheme.bodyMedium,
    );
  }
}
