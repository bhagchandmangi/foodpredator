import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_predator/components/high_scores.dart';
import 'package:food_predator/resources/blank_pixels.dart';
import 'package:food_predator/screens/food_pixel.dart';
import 'package:food_predator/screens/snake_pixels.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snakeDirection { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  int totalNumberOfSquars = 100;

  List<int> snakePositions = [0, 1, 2];
  int foodPosition = 55;
  int currentScore = 0;
  bool gameHasStarted = false;
  var currentDirection = snakeDirection.RIGHT;
  final _nameController = TextEditingController();

  List<String> highScore_DocIds = [];
  late final Future? letsGetDocIds;
  bool isAdLoaded = false;
  late BannerAd adBanner;
  // final AdSize adSize = const AdSize();

  @override
  void initState() {
    letsGetDocIds = getDocIds();
    super.initState();
    _initBannerAd();
  }

  _initBannerAd() {
    adBanner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {},
      ),
    );
    adBanner.load();
  }

  Future getDocIds() async {
    FirebaseFirestore.instance
        .collection("highscores")
        .orderBy("score", descending: true)
        .limit(1)
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              highScore_DocIds.add(element.reference.id);
            },
          ),
        );
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
        // eatFood();
        if (gameOver()) {
          timer.cancel();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: ((context) {
                return AlertDialog(
                  title: const Text("Game Over"),
                  content: Column(
                    children: [
                      Text("Your Scores are: $currentScore"),
                      TextField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(hintText: "Enter Your Name"),
                      )
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        submitScore();
                        newGame();
                      },
                      color: Colors.pink,
                      child: const Text("Submit"),
                    )
                  ],
                );
              }));
        }
      });
    });
  }

  void submitScore() {
    var database = FirebaseFirestore.instance;
    database.collection('highscores').add({
      "name": _nameController.text,
      "score": currentScore,
    });
  }

  void eatFood() {
    currentScore++;
    while (snakePositions.contains(foodPosition)) {
      foodPosition = Random().nextInt(totalNumberOfSquars);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snakeDirection.RIGHT:
        {
          if (snakePositions.last % rowSize == 9) {
            snakePositions.add(snakePositions.last + 1 - rowSize);
          } else {
            snakePositions.add(snakePositions.last + 1);
          }
        }
        break;
      case snakeDirection.LEFT:
        {
          if (snakePositions.last % rowSize == 0) {
            snakePositions.add(snakePositions.last - 1 + rowSize);
          } else {
            snakePositions.add(snakePositions.last - 1);
          }
        }
        break;
      case snakeDirection.UP:
        {
          if (snakePositions.last < rowSize) {
            snakePositions
                .add(snakePositions.last - rowSize + totalNumberOfSquars);
          } else {
            snakePositions.add(snakePositions.last - rowSize);
          }
        }
        break;
      case snakeDirection.DOWN:
        {
          if (snakePositions.last + rowSize > totalNumberOfSquars) {
            snakePositions
                .add(snakePositions.last + rowSize - totalNumberOfSquars);
          } else {
            snakePositions.add(snakePositions.last + rowSize);
          }
        }
        break;
      default:
    }
    if (snakePositions.last == foodPosition) {
      eatFood();
    } else {
      snakePositions.removeAt(0);
    }
  }

  bool gameOver() {
    List<int> bodySnake = snakePositions.sublist(0, snakePositions.length - 1);
    if (bodySnake.contains(snakePositions.last)) {
      return true;
    } else {
      return false;
    }
  }

  Future newGame() async {
    highScore_DocIds = [];
    await getDocIds();

    setState(() {
      snakePositions = [0, 1, 2];
      foodPosition = 55;
      currentDirection = snakeDirection.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: width > 400 ? 400 : width,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Current Scores",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          currentScore.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 36),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: gameHasStarted
                        ? Container()
                        : FutureBuilder(
                            future: letsGetDocIds,
                            builder: ((context, snapshot) {
                              return ListView.builder(
                                itemCount: highScore_DocIds.length,
                                itemBuilder: (((context, index) {
                                  return HighScores(
                                      documentId: highScore_DocIds[index]);
                                })),
                              );
                            }),
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      currentDirection != snakeDirection.UP) {
                    currentDirection = snakeDirection.DOWN;
                  } else if (details.delta.dy < 0 &&
                      currentDirection != snakeDirection.DOWN) {
                    currentDirection = snakeDirection.UP;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      currentDirection != snakeDirection.LEFT) {
                    currentDirection = snakeDirection.RIGHT;
                  } else if (details.delta.dx < 0 &&
                      currentDirection != snakeDirection.RIGHT) {
                    currentDirection = snakeDirection.LEFT;
                  }
                },
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalNumberOfSquars,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rowSize),
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
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    FloatingActionButton(
                      // style: flatButtonStyle,
                      splashColor: Colors.grey[400],
                      hoverColor: Colors.green,
                      highlightElevation: 50,
                      elevation: 12,
                      hoverElevation: 50,
                      tooltip: 'Play',

                      onPressed: gameHasStarted ? () {} : startGame,
                      child: Column(
                        children: [
                          const Text('Play'),
                          SizedBox(
                            width: adBanner.size.width.toDouble(),
                            height: adBanner.size.height.toDouble(),
                            child: AdWidget(
                              ad: adBanner,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
