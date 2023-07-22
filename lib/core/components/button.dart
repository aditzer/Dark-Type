import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final Function onTap;
  const Button({required this.title,required this.onTap,super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(4),
        backgroundColor: MaterialStateProperty.all(Colors.black),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          title,
        ),
      ),
      onPressed: ()=> onTap(context),
    );
  }
}
