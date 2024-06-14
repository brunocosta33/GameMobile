import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'end_game_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _score = 0;
  int _questionIndex = 0;
  bool _isAnswered = false;
  String _selectedAnswer = '';
  final List<Map<String, Object>> _questions = [
    {
      'questionText': 'Qual é o Network ID do endereço IP 192.168.1.10 com máscara de sub-rede /24?',
      'answers': ['192.168.1.0', '192.168.1.1', '192.168.1.10', '192.168.0.0'],
      'correctAnswer': '192.168.1.0'
    },
    {
      'questionText': 'Qual é o Broadcast do endereço IP 10.0.0.5 com máscara de sub-rede /8?',
      'answers': ['10.255.255.255', '10.0.0.255', '10.255.0.0', '10.0.0.5'],
      'correctAnswer': '10.255.255.255'
    },
    // Adicione mais perguntas conforme necessário
  ];

  void _answerQuestion(String answer) {
    setState(() {
      _isAnswered = true;
      _selectedAnswer = answer;
      if (answer == _questions[_questionIndex]['correctAnswer']) {
        _score += 10; // Adiciona pontos ao score
      }
    });
  }

  Future<void> _saveScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('scores').add({
        'email': user.email,
        'score': _score,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void _nextQuestion() {
    setState(() {
      _isAnswered = false;
      _selectedAnswer = '';
      _questionIndex++;
      if (_questionIndex >= _questions.length) {
        _saveScore();
        _questionIndex = 0; // Reinicia o jogo ou pode exibir uma mensagem de conclusão
      }
    });
  }

  void _stopGame() {
    _saveScore();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => EndGameScreen(score: _score)),
    );
  }

  Color _getButtonColor(String answer) {
    if (!_isAnswered) {
      return Colors.blue; // Default button color
    } else if (answer == _questions[_questionIndex]['correctAnswer']) {
      return Colors.green;
    } else if (answer == _selectedAnswer) {
      return Colors.red;
    } else {
      return Colors.blue; // Default button color for other answers
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game"),
      ),
      body: _questionIndex < _questions.length
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _questions[_questionIndex]['questionText'] as String,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                ...(_questions[_questionIndex]['answers'] as List<String>).map((answer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(answer), // Define a cor do botão
                      ),
                      onPressed: _isAnswered ? null : () => _answerQuestion(answer),
                      child: Text(answer),
                    ),
                  );
                }).toList(),
                if (_isAnswered)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: const Text('Próxima Pergunta'),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Score: $_score',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: _stopGame,
                  child: const Text('Parar de Jogar'),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Game Over! Your Score: $_score',
                    style: const TextStyle(fontSize: 24),
                  ),
                  ElevatedButton(
                    onPressed: _stopGame,
                    child: const Text('Voltar ao Login'),
                  ),
                ],
              ),
            ),
    );
  }
}
