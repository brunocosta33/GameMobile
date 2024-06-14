import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String question = '';
  String correctAnswer = '';
  String selectedAnswer = '';
  int score = 0;
  int questionNumber = 0;

  void generateQuestion() {
    // Implementar lógica para gerar perguntas e respostas
    // Por enquanto, exemplo estático
    question = 'Qual é o Network ID do endereço IP 192.168.1.10 com máscara de sub-rede /24?';
    correctAnswer = '192.168.1.0';
  }

  void checkAnswer() {
    if (selectedAnswer == correctAnswer) {
      score += 10;
    } else {
      score -= 5;
    }
    questionNumber++;
    generateQuestion();
    setState(() {});
  }

  Future<void> saveScore() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    await FirebaseFirestore.instance.collection('scores').add({
      'email': userEmail,
      'score': score,
    });
  }

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jogo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(question),
            TextField(
              onChanged: (value) {
                selectedAnswer = value;
              },
              decoration: const InputDecoration(labelText: 'Resposta'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAnswer,
              child: const Text('Verificar Resposta'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveScore,
              child: const Text('Salvar Pontuação'),
            ),
            Text('Pontuação: $score'),
          ],
        ),
      ),
    );
  }
}
