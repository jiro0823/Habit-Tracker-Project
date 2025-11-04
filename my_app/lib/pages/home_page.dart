import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import 'package:my_app/components/searchbar.dart' as app_comp;
//import 'package:my_app/components/welcome_banner.dart';
import 'package:my_app/components/calendar_card.dart';
// ...existing code...

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();

  final Map<String, List<Map<String, dynamic>>> _habitData = {};

  Future<void> _signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  String _keyFor(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _ensureDateHasHabits(DateTime date) {
    final k = _keyFor(date);
    if (!_habitData.containsKey(k)) {
      _habitData[k] = [
        {'title': 'Drink water', 'done': false},
        {'title': 'Exercise 20 mins', 'done': false},
        {'title': 'Read 15 mins', 'done': false},
      ];
    }
  }

  void _toggleHabit(int index) {
    final k = _keyFor(_selectedDate);
    final list = _habitData[k]!;
    setState(() => list[index]['done'] = !(list[index]['done'] as bool));
  }

  Future<void> _addHabitDialog() async {
    final ctrl = TextEditingController();
    final res = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add habit'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Habit title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (res != null && res.isNotEmpty) {
      final k = _keyFor(_selectedDate);
      setState(() {
        _ensureDateHasHabits(_selectedDate);
        _habitData[k]!.add({'title': res, 'done': false});
      });
    }
  }

  Future<void> _editHabitDialog(int index) async {
    final k = _keyFor(_selectedDate);
    final list = _habitData[k]!;
    final ctrl = TextEditingController(text: list[index]['title'] as String);
    final res = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit habit'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (res != null && res.isNotEmpty) {
      setState(() => list[index]['title'] = res);
    }
  }

  void _deleteHabit(int index) {
    final k = _keyFor(_selectedDate);
    setState(() => _habitData[k]!.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'No email available';

    _ensureDateHasHabits(_selectedDate);
    final habits = _habitData[_keyFor(_selectedDate)]!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          onPressed: () {},
        ),
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async => await _signUserOut(),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      // ensure nav bar space
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom:
                kBottomNavigationBarHeight +
                MediaQuery.of(context).padding.bottom +
                8,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              Center(
                child: Column(
                  children: [
                    Text(
                      'Hi, $email',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'LOG IN SUCCESSFULLY!',
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // calendar - fixed height so it stays visible while list scrolls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  height: 300,
                  child: CalendarCard(
                    selectedDate: _selectedDate,
                    onDateChanged: (d) => setState(() {
                      _selectedDate = d;
                      _ensureDateHasHabits(d);
                    }),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Habits — ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _addHabitDialog,
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: habits.isEmpty
                      ? Center(
                          child: Text(
                            'No habits for this date. Tap + to add.',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        )
                      : ListView.separated(
                          itemCount: habits.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final h = habits[index];
                            final done = h['done'] as bool;
                            final keyStr =
                                '${_keyFor(_selectedDate)}-$index-${h['title']}';
                            return Dismissible(
                              key: Key(keyStr),
                              direction: DismissDirection
                                  .endToStart, // swipe left to delete
                              background: Container(
                                padding: const EdgeInsets.only(right: 20),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade600,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) {
                                _deleteHabit(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Habit deleted'),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  leading: Checkbox(
                                    value: done,
                                    onChanged: (_) => _toggleHabit(index),
                                  ),
                                  title: Text(
                                    h['title'] as String,
                                    style: TextStyle(
                                      color: done ? Colors.grey : Colors.black,
                                      decoration: done
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteHabit(index),
                                  ),
                                  onLongPress: () => _editHabitDialog(index),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.deepPurple.shade300,
        buttonBackgroundColor: Colors.deepPurple,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        items: const [
          Icon(Icons.home_outlined, size: 30, color: Colors.white),
          Icon(Icons.list_alt, size: 30, color: Colors.white),
          Icon(Icons.add, size: 30, color: Colors.white),
          Icon(Icons.person_outline, size: 30, color: Colors.white),
          Icon(Icons.settings_outlined, size: 30, color: Colors.white),
        ],
        onTap: (index) async {
          setState(() => _currentIndex = index);

          // If center '+' button (index 2) tapped, open add-habit dialog
          if (index == 2) {
            await _addHabitDialog();
            // optionally keep the selected tab on a different index (e.g. back to home)
            // setState(() => _currentIndex = 0);
          } else {
            // handle other tabs if you want navigation actions per index
            // example: navigate to different pages or update view
            // debugPrint('nav index: $index');
          }
        },
      ),
    );
  }
}
  