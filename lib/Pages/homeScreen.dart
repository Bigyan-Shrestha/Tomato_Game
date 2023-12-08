import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:project_tomatogame/Credentials/supabase_authentication.dart';
import 'package:project_tomatogame/Pages/Login.dart';
import 'package:project_tomatogame/Pages/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Login Page Class..............................................................Class
class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeScreen();
}

class HomeScreen extends State<MyHomeScreen> {
  late AuthenticationService _authenticationService;
  bool _loading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //Initializing Authentication Service.........................................Function
  void initState() {
    _authenticationService = AuthenticationService();
    super.initState();
  }

  //Cleaning Up the Controllers Values..........................................Function
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //variable for score.
  int myVar = 0;
  final supabase = Supabase.instance.client;

  //Functions to insert the high score data......................................SELECT HIGH SCORE FUNCTION
  Future<void> highScores() async {
    final response = await supabase
        .from('high_scores')
        .select('*')
        .order('score', ascending: false)
        .limit(3)
        .execute();

    // Display the top 3 scores with names
    final topScores = response.data as List;
    for (final scoreData in topScores) {
      final name = scoreData['username'];
      final score = scoreData['score'];
      final topScores = response.data as List<dynamic>;
      showHighScoresDialog(context, topScores);
    }
  }

  void showHighScoresDialog(BuildContext context, List<dynamic> topScores) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Top 3 High Scores'),
          content: Column(
            children: topScores.map((scoreData) {
              final name = scoreData['username'];
              final score = scoreData['score'];
              return ListTile(
                title: Text('$name: $score'),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomeScreen(),
                  ),
                );
              },
              child: Text('Close'),

            ),
          ],
        );
      },
    );
  }

  //Main Widget of Login Page...................................................Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFD50000),
                Color(0xFFFCE4EC),
                Color(0xFFFCE4EC),
              ],
              stops: [0.1, 0.6, 0.8],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 35,
              ),
              //Image.asset(name),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Play Tomato Game',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              Container(
                height: 480,
                width: 325,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Click Start to Play the Game.',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(
                            'Start',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.purple[300],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(
                            'High Scores',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                          onPressed: () async {
                            highScores();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.purple[300],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(
                            'How To Play',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              keyboardAware: true,
                              dismissOnBackKeyPress: false,
                              dialogType: DialogType.info,
                              animType: AnimType.bottomSlide,
                              btnOkText: "OK",
                              title: 'HOW TO PLAY?',
                              desc:
                                  'You must submit the answer of the provided equation in order to proceed to next level and update your score. Doing any other activities might lead user to restart the game. '
                                  'You get 10 points each after the correct submission and will be added to the next round if you get it correct too.',
                              btnOkOnPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomeScreen(),
                                  ),
                                );
                              },
                            ).show();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.purple[300],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.purple[300],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
