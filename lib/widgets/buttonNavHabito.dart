// habits_bottom_nav.dart
import 'package:flutter/material.dart';

class ButtonNavHabito extends StatelessWidget {
  const ButtonNavHabito({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home_outlined, size: 28),
          Icon(Icons.check_circle_outline, size: 28),
          Icon(Icons.settings_outlined, size: 28),
        ],
      ),
    );
  }
}
