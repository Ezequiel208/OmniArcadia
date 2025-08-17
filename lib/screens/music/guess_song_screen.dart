import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class GuessSongScreen extends StatefulWidget {
  const GuessSongScreen({super.key});

  @override
  _GuessSongScreenState createState() => _GuessSongScreenState();
}

class _GuessSongScreenState extends State<GuessSongScreen> {
  bool isPlaying = false;
  late AudioPlayer _audioPlayer;
  String currentSong = "Mr. Kitty - After Dark"; // Canción correcta
  String currentChoice = ""; // Elección del usuario
  final List<String> options = [
    "The Weeknd - Blinding Lights", // Opción incorrecta
    "Mr. Kitty - After Dark", // Opción correcta
    "Pastel Ghost Beach" // Opción incorrecta
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  void _toggleMusic() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      try {
        await _audioPlayer.setAsset('assets/music/afterdark_8bit.mp3');
        await _audioPlayer.play();
      } catch (e) {
        print('Error al cargar la música: $e');
      }
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _checkAnswer(String selectedSong) {
    setState(() {
      currentChoice = selectedSong;
    });

    if (currentChoice == currentSong) {
      _audioPlayer.pause(); // Pausa al acertar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('¡Respuesta Correcta!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('¡Respuesta Incorrecta!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Fondo con color
      appBar: AppBar(
        title: const Text('Adivina la Canción'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresa al menú
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Toca el botón para reproducir la canción:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _toggleMusic,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  isPlaying ? 'Pausar Canción' : 'Reproducir Canción',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Elige la canción correcta:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
