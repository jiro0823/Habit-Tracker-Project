//import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:my_app/components/searchbar.dart' as components;
import 'package:my_app/components/buttom_navbar.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();
  final Map<String, List<Map<String, dynamic>>> _habitData = {};

  // Example daily challenges
  final List<Map<String, String>> _challenges = [
    {'title': 'Daily challenge', 'subtitle': 'Do your plan before 09:00 AM'},
    {
      'title': 'Mindful moment',
      'subtitle': 'Take 5 minutes to relax your mind',
    },
    {'title': 'Focus boost', 'subtitle': 'Work 25 mins with full focus'},
    {'title': 'Stretch break', 'subtitle': 'Do light stretches for 3 mins'},
  ];

  late Map<String, String> _todayChallenge;

  @override
  void initState() {
    super.initState();
    // Pick a random challenge for today
    final random = Random();
    _todayChallenge = _challenges[random.nextInt(_challenges.length)];
  }

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

  void _toggleHabitByKey(String dateKey, int index) {
    final list = _habitData[dateKey]!;
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

  void _deleteHabitByKey(String dateKey, int index) {
    setState(() => _habitData[dateKey]!.removeAt(index));
  }

  double _calculateProgress() {
    if (_habitData.isEmpty) return 0;
    int totalDays = _habitData.length;
    int completedDays = _habitData.entries
        .where((entry) => entry.value.any((habit) => habit['done'] == true))
        .length;
    return completedDays / totalDays;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Guest User';
    _ensureDateHasHabits(_selectedDate);

    List<Map<String, dynamic>> displayHabits;
    if (_currentIndex == 1) {
      displayHabits = _habitData.entries.expand((entry) {
        final dateKey = entry.key;
        return entry.value.asMap().entries.map((e) {
          return {
            'title': e.value['title'],
            'done': e.value['done'],
            'dateKey': dateKey,
            'sourceIndex': e.key,
          };
        });
      }).toList();
    } else {
      final k = _keyFor(_selectedDate);
      final list = _habitData[k] ?? [];
      displayHabits = list.asMap().entries.map((e) {
        return {
          'title': e.value['title'],
          'done': e.value['done'],
          'dateKey': k,
          'sourceIndex': e.key,
        };
      }).toList();
    }

    final startOfWeek = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday - 1),
    );
    final daysOfWeek = List.generate(
      7,
      (i) => startOfWeek.add(Duration(days: i)),
    );
    final progress = _calculateProgress();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 16,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: const AssetImage('assets/images/eberni.jpg'),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello,",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  email.split('@')[0], // just the username part
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout, color: Colors.deepPurple),
            onPressed: _signUserOut,
          ),
        ],
      ),
      backgroundColor: Colors.white,
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
              // 🟣 Dynamic Daily Challenge Banner
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade400,
                        Colors.deepPurple.shade200,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _todayChallenge['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _todayChallenge['subtitle']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),

              //  Weekly Progress Panel
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.deepPurple.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Weekly Progress",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${(progress * 100).toStringAsFixed(1)}% completed",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //  Weekly Calendar
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: daysOfWeek.length,
                  itemBuilder: (context, index) {
                    final day = daysOfWeek[index];
                    final isSelected =
                        day.day == _selectedDate.day &&
                        day.month == _selectedDate.month &&
                        day.year == _selectedDate.year;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = day;
                          _ensureDateHasHabits(day);
                        });
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.deepPurple
                              : Colors.deepPurple.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('EEE').format(day),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                day.day.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.deepPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              //  Habit Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _currentIndex == 1
                            ? 'All Habits'
                            : 'Habits — ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
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

              //   Habit List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: displayHabits.isEmpty
                      ? Center(
                          child: Text(
                            _currentIndex == 1
                                ? 'No habits. Tap + to add.'
                                : 'No habits for this date. Tap + to add.',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        )
                      : ListView.separated(
                          itemCount: displayHabits.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final h = displayHabits[index];
                            final done = h['done'] as bool;
                            final dateKey = h['dateKey'] as String;
                            final sourceIndex = h['sourceIndex'] as int;

                            return Dismissible(
                              key: Key('$dateKey-$sourceIndex'),
                              direction: DismissDirection.endToStart,
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
                                _deleteHabitByKey(dateKey, sourceIndex);
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
                                  leading: Checkbox(
                                    value: done,
                                    onChanged: (_) =>
                                        _toggleHabitByKey(dateKey, sourceIndex),
                                  ),
                                  title: Text(
                                    ['title'] as String,
                                    style: TextStyle(
                                      color: done
                                          ? Colors.grey
                                          : Colors.black87,
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
                                    onPressed: () =>
                                        _deleteHabitByKey(dateKey, sourceIndex),
                                  ),
                                  onLongPress: () {
                                    if (_currentIndex == 1) {
                                      setState(() {
                                        _selectedDate = DateTime.parse(dateKey);
                                      });
                                    }
                                    _editHabitDialog(sourceIndex);
                                  },
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
      bottomNavigationBar: ButtomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          setState(() => _currentIndex = index);
          if (index == 2) await _addHabitDialog();
        },
      ),
    );
  }
}
