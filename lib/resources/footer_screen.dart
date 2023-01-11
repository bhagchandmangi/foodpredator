import 'package:flutter/material.dart';
import 'package:food_predator/resources/button_style.dart';

class FooterArea extends StatefulWidget {
  const FooterArea({super.key});

  @override
  State<FooterArea> createState() => _FooterAreaState();
}

class _FooterAreaState extends State<FooterArea> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: TextButton(
          style: flatButtonStyle,
          onPressed: () {},
          child: const Text('Play'),
        ),
      ),
    );
  }
}
