import 'package:flutter/material.dart';
import 'memorygame_screen.dart';
import 'music/guess_song_screen.dart';
import 'rock_paper_scissors.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        "title": "Juego de Memoria",
        "screen": const MemoryGameScreen(),
      },
      {
        "title": "Adivina la Canción",
        "screen": const GuessSongScreen(),
      },
      {
        "title": "Piedra, Papel o Tijera",
        "screen": RockPaperScissors(),
      },
      {
        "title": "Puzzle (Próximamente)",
        "screen": null,
      },
      {
        "title": "Otros Juegos (Próximamente)",
        "screen": null,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text('Selección de Juegos'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: games.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final game = games[index];
          return Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              title: Text(
                game["title"] as String,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                if (game["screen"] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => game["screen"] as Widget),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('¡${game["title"]} estará disponible pronto!'),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
