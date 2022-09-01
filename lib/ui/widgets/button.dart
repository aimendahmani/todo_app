import 'package:flutter/material.dart';
import 'package:todoapp2/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function ontap;

  const MyButton({required this.label, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryClr,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, color: white),
        ),
      ),
    );
  }
}
