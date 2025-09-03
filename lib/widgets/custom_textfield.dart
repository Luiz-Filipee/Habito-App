import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField({
    required this.hintText,
    required this.icon,
    required this.obscureText,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = const Color(0xFFFF6B6B);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(color: borderColor, width: 2),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: borderColor,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: borderColor),
          hintText: hintText,
          hintStyle: Colors.black.withOpacity(0.6).toTextStyle(),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

extension on Color {
  TextStyle toTextStyle() => TextStyle(color: this);
}
