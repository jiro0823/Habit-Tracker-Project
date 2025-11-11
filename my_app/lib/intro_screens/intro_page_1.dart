import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Center image
          Expanded(
            flex: 3,
            child: Image.asset(
              'assets/images/intropic.png',
              fit: BoxFit.contain,
            ),
          ),
          
          // Bottom text
          Expanded(
            flex: 1,
            child: Text(
              'Every check-in brings you one step closer to the best version of yourself',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}