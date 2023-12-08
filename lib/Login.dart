import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_tomatogame/Credentials/supabase_authentication.dart';
import 'package:project_tomatogame/homeScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Register.dart';

//Login Page Class..............................................................Class
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginPage();
}

class LoginPage extends State<LoginScreen> {
  late AuthenticationService _authenticationService;
  bool _loading = false;
  final _emailController = TextEditingController(text:'bigyan.shrestha@patancollege.edu.np');
  final _passwordController = TextEditingController(text:'games123');

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
                Color(0xFF424242),
                Color(0xff9C27B0),
                Color(0xFF303030),
              ],
              stops: [0.05, 0.25, 0.7],
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
                'Neon',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 40,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(100, 1, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A Gamers Paradise',
                      style: TextStyle(
                          color: Colors.purple[300],
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ],
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
                      'Sign in into your Neon account.',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Container(
                      height: 45,
                      width: 250,
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address.',
                          filled: true,
                          fillColor: Colors.black26,
                          suffixIcon: Icon(FontAwesomeIcons.envelope, size: 17),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 45,
                      width: 250,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password.',
                          filled: true,
                          fillColor: Colors.black26,
                          suffixIcon: Icon(FontAwesomeIcons.eyeSlash, size: 17),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(50, 1, 30, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Text('Forget Password?'),
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.purple[300],
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black38,
                            foregroundColor: Colors.white70,
                          ),
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });
                            try {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              await Supabase.instance.client.auth
                                  .signInWithPassword(
                                email: email,
                                password: password,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login Success'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  MyHomeScreen(),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login failed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(
                                () {
                                  _loading = false;
                                },
                              );
                            }
                          },
                          child: const Text('Sign in to Neon'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New on Neon?',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          child: Text('Register.'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyRegisterPage(),
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
                      height: 10,
                    ),
                    Text(
                      'Or',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Login Using.',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black38,
                            foregroundColor: Colors.white70,
                          ),
                          onPressed: () async {},
                          icon: const Icon(
                            FontAwesomeIcons.google,
                          ),
                          label: const Text('Sign in with Google'),
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
