class Question {
  final String question;
  final String correctAnswer;
  final List<String> options;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });
}

class QuestionGenerator {
  List<Question> generateQuestions(int level) {
    List<Question> questions = [];
    // Adicionar lógica para gerar perguntas com base no nível
    if (level == 1) {
      questions.add(Question(
        question: 'Qual é o Network ID do endereço IP 192.168.1.10 com máscara de sub-rede /24?',
        correctAnswer: '192.168.1.0',
        options: ['192.168.1.0', '192.168.1.1', '192.168.1.10', '192.168.0.0'],
      ));
    }
    // Adicionar mais perguntas para outros níveis
    return questions;
  }
}
