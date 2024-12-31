abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<dynamic> questions;
  final int currentQuestionIndex;
  final List<String?> answers;

  QuizLoaded(this.questions, this.currentQuestionIndex, this.answers);
}

class QuizCompleted extends QuizState {
  final int score;
  QuizCompleted(this.score);
}