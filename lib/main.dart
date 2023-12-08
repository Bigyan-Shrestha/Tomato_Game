import 'dart:convert';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_tomatogame/Credentials/supabase_credentials.dart';
import 'package:project_tomatogame/Login.dart';
import 'package:project_tomatogame/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: SupabaseCredentials.APIURL, anonKey: SupabaseCredentials.APIKEY);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //URL of the Tomato API.......................................................API Connection Using URL
  final String apiUrl = ('https://marcconrad.com/uob/tomato/api.php');
  TextEditingController _textFieldController = TextEditingController();

  // Function to make a GET request to the Tomato API...........................Function
  Future<Map<String, dynamic>> fetchTomatoData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return jsonData;
    } else {
      // If the server did not return a 200 OK response,
      throw Exception(
          'Failed to load data from Tomato API'); // Throwing exception.
    }
  }

  int myVar = 0; // Initialize with the desired default value
  final supabase = Supabase.instance.client; //Initialize the Supabase instance.

  Future<void> insertCurrentUser() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null) {
      print(myVar);
      final response = await supabase.from('high_scores').upsert(
        {
          'score': myVar,
          'email': currentUser.email,
          'username': currentUser.userMetadata?['display_name'],
        },
        onConflict: currentUser.userMetadata?['email'],
      );
      if (response.error != null) {
        print('Error inserting user data: ${response.error!.message}');
      } else {
        print('User data inserted successfully');
      }
    } else {
      print('No current user authenticated');
    }
  }

  @override
  void initState() {
    super.initState();
    loadMyVar();
    // Additional code can be placed here
  }

  // Function to load myVar from SharedPreferences..............................LOAD FUNCTION ...HIGHSCORE
  Future<void> loadMyVar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myVar = prefs.getInt('myVar') ??
          0; // Use the default value if 'myVar' is not found
    });
  }

  // Function to save myVar to SharedPreferences................................SAVE FUNCTION ...HIGHSCORE
  Future<void> saveMyVar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('myVar', myVar);
  }

  //Function to insert the high score data......................................STORE FUNCTION ...HIGH SCORE
  /*Future<void> insertData() async {
    final currentUser = supabase.auth.currentUser;
    final response = await supabase
        .from('high_scores')
        .upsert([
      {
        'id': currentUser?.id,
        'name': userData.username,
        'email': userData.email,
        // Add other fields as needed
      },
    ]);
    if (response.error != null) {
      print('Error inserting data: ${response.error!.message}');
    } else {
      print('Data inserted successfully');
    }
  }*/

  //Function to Get the high score data.........................................GET VALUE FUNCTION ...HIGH SCORE
  Future<void> fetchData() async {
    final response = await supabase.from('high_score').select();

    if (response.error != null) {
      print('Error fetching data: ${response.error!.message}');
    } else {
      final data = response.data as List<dynamic>;
      print('Fetched data: $data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchTomatoData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Display the data from the Tomato API
              final tomatoData = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Text('Tomato Name =${tomatoData?['question']}'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Play Tomato Game',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  tomatoData?['question'] != null
                      ? Image.network(tomatoData?['question'])
                      : Container(
                          color: Colors.purple,
                        ),
                  Container(
                    height: 45,
                    width: 250,
                    child: TextField(
                      controller: _textFieldController,
                      decoration: InputDecoration(
                        labelText: 'Enter Correct Answer',
                        filled: true,
                        fillColor: Colors.black26,
                      ),
                    ),
                  ),
                  Text(
                      '10 Points for each Correct answer. Any wrong answer will restart the game.'),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      String textValue = _textFieldController.text;
                      print(textValue);
                      print(tomatoData?['solution']);
                      if (tomatoData?['solution'].toString() ==
                          textValue.toString()) {
                        // Perform actions if validation succeeds
                        print('Correct');
                        AwesomeDialog(
                          context: context,
                          keyboardAware: true,
                          dismissOnBackKeyPress: false,
                          dialogType: DialogType.success,
                          animType: AnimType.bottomSlide,
                          btnCancelText: "QUIT GAME",
                          btnOkText: "NEXT LEVEL",
                          title: 'CONTINUE TO PLAY?',
                          // padding: const EdgeInsets.all(5.0),
                          desc: 'Correct Answer.',
                          btnCancelOnPress: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomeScreen(),
                              ),
                            );
                          },
                          btnOkOnPress: () {
                            setState(() {
                              myVar = myVar + 10; // Update myVar value
                            });
                            saveMyVar();

                            print('You have scored $myVar points');
                          },
                        ).show();
                        /* } else if (tomatoData?['solution'].toString() ==
                          null.toString()) {
                        // Validation failed, show an error message or handle accordingly
                        print('Please Enter Solution.');*/
                      } else {
                        // Validation failed, show an error message or handle accordingly
                        print('Incorrect');
                        AwesomeDialog(
                          context: context,
                          keyboardAware: true,
                          dismissOnBackKeyPress: false,
                          dialogType: DialogType.error,
                          animType: AnimType.bottomSlide,
                          btnCancelText: "RETURN TO HOME",
                          title: 'GAME OVER',
                          // padding: const EdgeInsets.all(5.0),
                          desc: 'Wrong Answer.',
                          btnCancelOnPress: () async {
                            //insertCurrentUser();

                            final currentUser = supabase.auth.currentUser;
                            if (currentUser != null) {
                              print(myVar);
                              final fetchResponse = await supabase
                                  .from('high_scores')
                                  .select('score')
                                  .eq('email', currentUser.email)
                                  .single()
                                  .execute();
                              final updatedScore = fetchResponse.data['score'];
                              final storedScore =
                                  int.tryParse(updatedScore.toString());
                              print(' Stored Score: $storedScore');
                              if (myVar <= storedScore! && storedScore == 0) {
                                Text('Score: $myVar');
                                myVar = 0;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomeScreen(),
                                  ),
                                );
                              } else if (myVar > storedScore) {
                                insertCurrentUser();
                                myVar = 0;
                              } else {
                                myVar = 0;
                                Text('Something went wrong');
                              }
                              ;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHomeScreen(),
                                ),
                              );
                            }
                            ;
                          },
                        ).show();
                      }
                    },
                    child: Text('Submit'),
                  ),

                  //To GET the solution of the API..............................Getting API Value
                  tomatoData?['solution'] != null
                      ? Text('Solution = ${tomatoData?['solution']}')
                      : Container(
                          color: Colors.purple,
                        ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
