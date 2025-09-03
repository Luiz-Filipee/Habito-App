// header_habits.dart
import 'package:flutter/material.dart';
import 'package:habitoapp/views/cadastroHabito.dart';

class HeaderHabitos extends StatelessWidget {
  const HeaderHabitos({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Hábitos',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        FloatingActionButton(
          backgroundColor: const Color(0xFF3A5BFF),
          foregroundColor: Colors.white,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NovoHabitoPage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
