import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Login.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && Platform.isWindows)
    await DesktopWindow.setMinWindowSize(
      const Size(550, 650),
    );
}

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({Key? key,}) : super(key: key);


  @override
  State<MyRegisterPage> createState() => RegisterPage();
}

//String to datetime conversion.................................................Datetime Function
DateTime? _dateTime(int? day, int? month, int? year) {
  if (day != null && month != null && year != null) {
    return DateTime(year, month, day);

  }
  return null;
}

class RegisterPage extends State<MyRegisterPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool _loading = false;

  final _displayNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();



  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  int _selectedDay = 14;
  int _selectedMonth = 10;
  int _selectedYear = 1993;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
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
              const Text(
                'Neon',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 1, 20, 10),
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
                      height: 20,
                    ),
                    const Text(
                      'Sign in into your Neon account.',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 45,
                      width: 400,
                      child: TextField(
                        controller: _displayNameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black54,
                            ),
                            labelText: 'Display Name  *',
                            filled: true,
                            fillColor: Colors.black26),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _firstNameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.black54,
                                ),
                                labelText: '  First Name  *',
                                filled: true,
                                fillColor: Colors.black26,
                                suffixIcon:
                                    Icon(FontAwesomeIcons.envelope, size: 17),
                                contentPadding: EdgeInsets.all(1)),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: TextField(
                            controller: _lastNameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.black54,
                                ),
                                labelText: '  Last Name  *',
                                filled: true,
                                fillColor: Colors.black26,
                                contentPadding: EdgeInsets.all(1)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 45,
                      width: 400,
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black54,
                          ),
                          labelText: 'Phone  *',
                          filled: true,
                          fillColor: Colors.black26,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 45,
                      width: 400,
                      child: TextField(
                        controller: _countryController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black54,
                          ),
                            labelText: 'Country  *',
                            filled: true,
                            fillColor: Colors.black26,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 45,
                      width: 400,
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black54,
                            ),
                            labelText: 'Email Address  *',
                            filled: true,
                            fillColor: Colors.black26,
                            suffixIcon:
                                Icon(FontAwesomeIcons.envelope, size: 17)),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 45,
                      width: 400,
                      child: TextField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black54,
                            ),
                            labelText: 'Password  *',
                            filled: true,
                            fillColor: Colors.black26,
                            suffixIcon:
                                Icon(FontAwesomeIcons.eyeSlash, size: 17)),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Form(
                      key: formKey,
                      autovalidateMode: _autovalidate,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DropdownDatePicker(
                              locale: "en",
                              inputDecoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black26,
                                contentPadding: EdgeInsets.all(1),
                              ),
                              // optional
                              isDropdownHideUnderline: true,
                              // optional
                              isFormValidator: true,
                              // optional
                              startYear: 1900,
                              // optional
                              endYear: 2020,
                              // optional
                              width: 0.5,
                              // optional
                              selectedDay: _selectedDay,
                              // optional
                              selectedMonth: _selectedMonth,
                              // optional
                              selectedYear: _selectedYear,
                              // optional
                              boxDecoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black26, width: 0.5),
                              ),
                              hintTextStyle:
                                  const TextStyle(color: Colors.black38),
                              onChangedDay: (value) {
                                _selectedDay = int.parse(value!);
                                print('onChangedDay: $value');
                              },
                              onChangedMonth: (value) {
                                _selectedMonth = int.parse(value!);
                                print('onChangedMonth: $value');
                              },
                              onChangedYear: (value) {
                                _selectedYear = int.parse(value!);
                                print('onChangedYear: $value');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      height: 2,
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
                            try {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              final firstName = _firstNameController.text;
                              final lastName = _lastNameController.text;
                              final displayName = _displayNameController.text;
                              final country = _countryController.text;
                              final phone = _phoneController.text;


                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                final DateTime? date = _dateTime(
                                    _selectedDay, _selectedMonth,
                                    _selectedYear);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    action: SnackBarAction(
                                      label: 'OK',
                                      onPressed: () {},
                                    ),
                                    content: Text('selected date is $date'),
                                    elevation: 20,
                                  ),
                                );
                              } else {
                                print('on error');
                                setState(() {
                                  _autovalidate = AutovalidateMode.always;
                                });
                              }
                              // Step 1: Register the user using Supabase authentication
                              final response =
                              await Supabase.instance.client.auth.signUp(
                                  password: password,
                                  email: email,

                                  // Step 3: Insert user's data into the user_info table
                                  data: { 'display_name':displayName,'first_name': firstName, 'last_name': lastName,'country': country,'phone': phone}
                              );
                              if (response.user == null) {
                                print('Sign up NOT successful!');
                                throw "failed to sign up";
                              } else {
                                final supabase = Supabase.instance.client;
                                await supabase
                                    .from('high_scores')
                                    .insert({'username': displayName, 'email': email});
                                print('Sign up successful!');
                              }

                              // If everything is successful, the sign-up process is complete
                              print('Signing and Saving table Successful!');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }

                            catch (error) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                              print('Error during sign-up: $error');

                            }

                          },
                          child: const Text('Create Neon Account'),
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
