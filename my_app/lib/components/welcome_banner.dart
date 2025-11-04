import 'package:flutter/material.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.rocket_launch, color: Colors.purple, size: 36),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Welcome!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 6),
                Text("Let's start your project.", style: TextStyle(color: Colors.black54)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}