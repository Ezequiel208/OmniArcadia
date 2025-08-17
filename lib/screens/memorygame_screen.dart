import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final AudioPlayer player = AudioPlayer();

  List<String> cards = [
    'assets/images/A.png',
    'assets/images/A.png',
    'assets/images/B.png',
    'assets/images/B.png',
    'assets/images/C.png',
    'assets/images/C.png',
    'assets/images/D.png',
    'assets/images/D.png',
  ];

  List<bool> cardFlipped = List.filled(8, false);
  List<bool> cardMatched = List.filled(8, false);
  int? lastFlippedIndex;

  @override
  void initState() {
    super.initState();
    cards.shuffle();
  }

  void flipCard(int index) {
    if (cardFlipped[index] || cardMatched[index]) return;

    // Sonido al voltear carta
    player.play('assets/sounds/flip_card.mp3');

    setState(() {
      cardFlipped[index] = true;

      if (lastFlippedIndex == null) {
        lastFlippedIndex = index;
      } else {
        if (cards[lastFlippedIndex!] == cards[index]) {
          cardMatched[lastFlippedIndex!] = true;
          cardMatched[index] = true;

          // Sonido al coincidir
          player.play('assets/sounds/correct_match.mp3');

          lastFlippedIndex = null;

          if (cardMatched.every((matched) => matched)) {
            // Sonido al ganar
            player.play('assets/sounds/win_game.mp3');
            Future.delayed(const Duration(milliseconds: 300), () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("¡Ganaste!"),
                  content: const Text("Encontraste todas las parejas."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        resetGame();
                      },
                      child: const Text("Jugar otra vez"),
                    )
                  ],
                ),
              );
            });
          }
        } else {
          int previousIndex = lastFlippedIndex!;
          lastFlippedIndex = null;
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              cardFlipped[previousIndex] = false;
              cardFlipped[index] = false;
            });
          });
        }
      }
    });
  }

  void resetGame() {
    setState(() {
      cardFlipped = List.filled(8, false);
      cardMatched = List.filled(8, false);
      lastFlippedIndex = null;
      cards.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Juego de Memoria')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => flipCard(index),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: 0,
                    end: cardFlipped[index] || cardMatched[index] ? pi : 0),
                duration: const Duration(milliseconds: 400),
                builder: (context, angle, child) {
                  bool isUnder = angle > pi / 2;
                  return Transform(
                    transform: Matrix4.rotationY(angle),
                    alignment: Alignment.center,
                    child: isUnder
                        ? Transform(
                            transform: Matrix4.rotationY(pi),
                            alignment: Alignment.center,
                            child: buildCardFront(index),
                          )
                        : buildCardBack(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildCardFront(int index) {
    return Card(
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(cards[index], fit: BoxFit.cover),
      ),
    );
  }

  Widget buildCardBack() {
    return Card(
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset('assets/images/OmniArcadia.png', fit: BoxFit.cover),
      ),
    );
  }
}
