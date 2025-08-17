import 'package:flutter/material.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<String> cards = ['A', 'B', 'A', 'B', 'C', 'D', 'C', 'D'];
  List<bool> cardFlipped = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  int lastFlippedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Juego de Memoria')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                cardFlipped[index] = !cardFlipped[index];
                if (lastFlippedIndex != -1 &&
                    lastFlippedIndex != index &&
                    cards[lastFlippedIndex] == cards[index]) {
                  print('¡Cartas coinciden!');
                } else if (lastFlippedIndex != -1 &&
                    lastFlippedIndex != index) {
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      cardFlipped[lastFlippedIndex] = false;
                      cardFlipped[index] = false;
                    });
                  });
                }
                lastFlippedIndex = index;
              });
            },
            child: Card(
              color: cardFlipped[index] ? Colors.blue : Colors.grey,
              child: Center(
                child: cardFlipped[index]
                    ? Text(
                        cards[index],
                        style:
                            const TextStyle(fontSize: 30, color: Colors.white),
                      )
                    : Container(),
              ),
            ),
          );
        },
      ),
    );
  }
}
