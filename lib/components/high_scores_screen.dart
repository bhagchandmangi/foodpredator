// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:food_predator/components/high_scores.dart';

class HighScoresScreen extends StatefulWidget {
  const HighScoresScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HighScoresScreen> createState() => _HighScoresScreenState();
}

class _HighScoresScreenState extends State<HighScoresScreen> {
  List<String> highScore_DocIds = [];
  late final Future? letsGetDocIds;
  final String documentId = '';

  @override
  void initState() {
    letsGetDocIds = getDocIds();
    super.initState();
  }

  Future getDocIds() async {
    FirebaseFirestore.instance
        .collection("highscores")
        .orderBy("score", descending: true)
        .limit(10)
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              highScore_DocIds.add(element.reference.id);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: letsGetDocIds,
            builder: ((context, snapshot) {
              return ListView.builder(
                itemCount: highScore_DocIds.length,
                itemBuilder: (((context, index) {
                  return HighScores(documentId: highScore_DocIds[index]);
                })),
              );
            }),
          ),
        ),
      ],
    );
  }
}
