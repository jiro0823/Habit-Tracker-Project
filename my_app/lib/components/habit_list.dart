import 'package:flutter/material.dart';

class HabitList extends StatelessWidget {
  final List<Map<String, dynamic>> habits;
  final void Function(int index) onToggle;
  final Future<void> Function(int index) onEdit;
  final void Function(int index) onDelete;

  const HabitList({
    super.key,
    required this.habits,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return Center(child: Text('No habits for this date. Tap + to add.', style: TextStyle(color: Colors.grey.shade600)));
    }

    return ListView.separated(
      itemCount: habits.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final h = habits[index];
        final done = h['done'] as bool;
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Checkbox(value: done, onChanged: (_) => onToggle(index)),
            title: Text(h['title'] as String, style: TextStyle(decoration: done ? TextDecoration.lineThrough : null)),
            trailing: PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'edit') onEdit(index);
                if (v == 'delete') onDelete(index);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Delete', style: TextStyle(color: Colors.red)))),
              ],
            ),
          ),
        );
      },
    );
  }
}