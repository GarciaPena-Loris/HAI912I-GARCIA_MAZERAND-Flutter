import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Question1/presentation/widgets/ThemeSwitcher.dart';
import '../../business_logic/blocs/QuizBLoC.dart';
import '../../business_logic/events/QuizEvent.dart';
import '../../business_logic/states/QuizState.dart';
import '../../../Question1/presentation/pages/ResultPage.dart';

class QuizAppBLoC extends StatelessWidget {
  final Map<String, dynamic> theme;

  const QuizAppBLoC({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc()..add(LoadQuestions(theme)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(theme['theme']),
          centerTitle: true,
          backgroundColor: Colors.purpleAccent,
          actions: [ThemeSwitcher()],
        ),
        body: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is QuizLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuizLoaded) {
              final currentQuestion = state.questions[state.currentQuestionIndex];
              final userAnswer = state.answers[state.currentQuestionIndex];
              final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Image.asset(
                    'assets/images/${theme['theme']}.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      currentQuestion['questionText'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: userAnswer == null
                                ? null
                                : (userAnswer == "Vrai" && currentQuestion['isCorrect'] == true)
                                    ? Colors.green
                                    : (userAnswer == "Vrai" && currentQuestion['isCorrect'] == false)
                                        ? Colors.red
                                        : null,
                            minimumSize: const Size(130, 50),
                            side: userAnswer == null
                                ? const BorderSide(color: Colors.purpleAccent)
                                : BorderSide.none,
                          ),
                          onPressed: userAnswer == null
                              ? () {
                                  context.read<QuizBloc>().add(SubmitAnswer(true));
                                }
                              : null,
                          child: Text("Vrai", style: TextStyle(color: textColor)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: userAnswer == null
                                ? null
                                : (userAnswer == "Faux" && currentQuestion['isCorrect'] == false)
                                    ? Colors.green
                                    : (userAnswer == "Faux" && currentQuestion['isCorrect'] == true)
                                        ? Colors.red
                                        : null,
                            minimumSize: const Size(130, 50),
                            side: userAnswer == null
                                ? const BorderSide(color: Colors.purpleAccent)
                                : BorderSide.none,
                          ),
                          onPressed: userAnswer == null
                              ? () {
                                  context.read<QuizBloc>().add(SubmitAnswer(false));
                                }
                              : null,
                          child: Text("Faux", style: TextStyle(color: textColor)),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 100,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: state.questions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context.read<QuizBloc>().add(GoToQuestion(index));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: state.answers[index] == null
                                  ? Colors.grey
                                  : state.answers[index] == "Vrai" &&
                                          state.questions[index]['isCorrect'] == true
                                      ? Colors.green
                                      : state.answers[index] == "Faux" &&
                                              state.questions[index]['isCorrect'] == false
                                          ? Colors.green
                                          : Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              border: index == state.currentQuestionIndex
                                  ? Border.all(color: textColor, width: 2)
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${index + 1}",
                              style: index == state.currentQuestionIndex
                                  ? TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)
                                  : TextStyle(color: textColor),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: state.currentQuestionIndex > 0
                            ? () {
                                context.read<QuizBloc>().add(PreviousQuestion());
                              }
                            : null,
                        icon: Icon(Icons.arrow_back, color: textColor),
                        label: Text("Précédent", style: TextStyle(color: textColor)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          minimumSize: const Size(140, 40),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: state.currentQuestionIndex < state.questions.length - 1
                            ? () {
                                context.read<QuizBloc>().add(NextQuestion());
                              }
                            : null,
                        label: Text("Suivant", style: TextStyle(color: textColor)),
                        icon: Icon(Icons.arrow_forward, color: textColor),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          minimumSize: const Size(140, 40),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is QuizCompleted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(score: state.score),
                  ),
                );
              });
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }
}