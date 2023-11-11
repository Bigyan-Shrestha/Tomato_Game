import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Replace this URL with the actual URL of the Tomato API
  final String apiUrl = ('https://marcconrad.com/uob/tomato/api.php');

  // Function to make a GET request to the Tomato API
  Future<Map<String, dynamic>> fetchTomatoData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return jsonData;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data from Tomato API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tomato API Demo'),
      ),
      body: Center(
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
                  Text('Tomato Name =${tomatoData?['question']}'),
                  SizedBox(
                    height: 10,
                  ),
                  tomatoData?['question'] != null
                      ? Image.network(tomatoData?['question'])
                      : Container(
                          color: Colors.purple,
                        ),
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
