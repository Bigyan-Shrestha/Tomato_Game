import 'package:project_tomatogame/Credentials/supabase_credentials.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService{
  late SupabaseClient client;

  AuthService(){
    client = Supabase.instance.client;
  }

  Future<void> signUpUsingEmailPassword({
    required String email,
    required String password,
    required String phone,
    required String displayName,
    required String firstName,
    required String lastName,
    required String date,
  }) async {
    AuthResponse response = await client.auth.signUp(
        password:password,
        email: email,
        phone: phone,
    );
    //print(response);
  }






  Future<void> logInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    AuthResponse response = await client.auth.signInWithPassword(
      password:password,
      email: email,
    );
    //print(response);
  }

}