import 'package:flutter/material.dart';

class MCButton extends StatefulWidget {
  final String text;
  void Function()? onPressed;

  MCButton({required this.text, required this.onPressed, super.key});

  @override
  State<MCButton> createState() => _MCButtonState();
}

class _MCButtonState extends State<MCButton> {
  bool tapDown = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: (details) => setState(() {
          tapDown = true;
        }),
        onTapUp: (details) => setState(() {
          tapDown = false;
        }),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 0),
            boxShadow: [
              BoxShadow(
                color:
                    tapDown ? const Color(0x55FFFFFF) : const Color(0x77FFFFFF),
                offset: const Offset(-1, -1),
              ),
              BoxShadow(
                color:
                    tapDown ? const Color(0x44000000) : const Color(0x66000000),
                offset: const Offset(1, 2),
              ),
            ],
            image: const DecorationImage(
              image: AssetImage("assets/images/bgbtn.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: tapDown ? const Color.fromARGB(73, 100, 100, 255) : Colors.white.withOpacity(0),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: tapDown ? const Color(0xFFFFFFA0) : Colors.white,
                shadows: const [
                  Shadow(
                    color: Color(0xAA000000),
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
