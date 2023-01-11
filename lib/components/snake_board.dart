import 'package:flutter/material.dart';
import 'package:food_predator/resources/blank_pixels.dart';
import 'package:food_predator/resources/button_style.dart';
import 'package:food_predator/screens/food_pixel.dart';
import 'package:food_predator/screens/snake_pixels.dart';

class SnakeBoard extends StatefulWidget {
  const SnakeBoard({super.key});

  @override
  State<SnakeBoard> createState() => _SnakeBoardState();
}

class _SnakeBoardState extends State<SnakeBoard> {
  int totalNumberOfSquars = 100;

  List<int> snakePositions = [0, 1, 2, 3];
  int foodPosition = 55;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalNumberOfSquars,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10),
              itemBuilder: (context, index) {
                if (snakePositions.contains(index)) {
                  return const SnakePixels();
                } else if (foodPosition == index) {
                  return const FoodPixel();
                } else {
                  return const BlankPixels();
                }
              }),
        ),
        Expanded(
          child: Center(
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () {},
              child: const Text('Play'),
            ),
          ),
        ),
      ],
    );
  }
}
