import 'dart:math';
import 'package:flutter/material.dart';

class RockPaperScissors extends StatefulWidget {
  RockPaperScissors({Key? key}) : super(key: key);

  @override
  _RockPaperScissorsState createState() => _RockPaperScissorsState();
}

class _RockPaperScissorsState extends State<RockPaperScissors> {
  final List<String> options = ["piedra", "papel", "tijera"];
  String? playerChoice;
  String? botChoice;
  String result = "";

  int playerScore = 0;
  int botScore = 0;

  void playGame(String choice) {
    final random = Random();
    final bot = options[random.nextInt(options.length)];

    setState(() {
      playerChoice = choice;
      botChoice = bot;
      result = getResult(choice, bot);

      // Actualizar puntaje
      if (result == "Has ganado") playerScore++;
      if (result == "Has perdido") botScore++;

      // Revisar si alguien ganó la partida
      if (playerScore == 2 || botScore == 2) {
        String finalResult = playerScore == 2
            ? "¡Ganaste la partida!"
            : "¡El Jugador ganó la partida!";
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(finalResult),
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
      }
    });
  }

  String getResult(String player, String bot) {
    if (player == bot) return "Empate";

    if ((player == "piedra" && bot == "tijera") ||
        (player == "papel" && bot == "piedra") ||
        (player == "tijera" && bot == "papel")) {
      return "Has ganado";
    } else {
      return "Has perdido";
    }
  }

  void resetGame() {
    setState(() {
      playerChoice = null;
      botChoice = null;
      result = "";
      playerScore = 0;
      botScore = 0;
    });
  }

  Widget buildOption(String opt, {bool isPlayer = true}) {
    bool isSelected =
        (isPlayer && playerChoice == opt) || (!isPlayer && botChoice == opt);

    return Container(
      margin: const EdgeInsets.all(8),
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              isSelected ? (isPlayer ? Colors.blue : Colors.red) : Colors.black,
          width: 4,
        ),
        image: DecorationImage(
          image: AssetImage("assets/images/$opt.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Piedra, Papel o Tijera")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Puntaje
          Text(
            "Jugador $playerScore - Bot $botScore",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Bot arriba
          if (playerChoice != null && botChoice != null) ...[
            const Text("El Jugador eligió:", style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: options.map((opt) {
                return buildOption(opt, isPlayer: false);
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Jugador abajo
          const Text("Elige tu jugada:", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: options.map((opt) {
              return GestureDetector(
                onTap: () => playGame(opt),
                child: buildOption(opt, isPlayer: true),
              );
            }).toList(),
          ),

          const SizedBox(height: 40),

          // Resultado
          if (playerChoice != null && botChoice != null)
            Text(
              result,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
