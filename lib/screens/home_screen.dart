import 'package:flutter/material.dart';
import 'package:omniarcadia/screens/music_screen.dart'; // Cambia por tu nombre de proyecto real


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      const MusicScreen()), // Aquí se navega a la pantalla de música
            );
          },
          child: const Text('Ir a Música'),
        ),
      ),
    );
  }
}
