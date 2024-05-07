import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final supabaseAuth = Supabase.instance.client.auth;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: dotenv.env['IOS_CLIENT_ID']!,
    serverClientId: dotenv.env['WEB_CLIENT_ID']!,
  );

  Future<void> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }
    await supabaseAuth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> signOut() async {
    print("Logging out!!!!!!!");
    try {
      await supabaseAuth.signOut();
      await googleSignIn.signOut();
    } catch (error) {
      print('Error while logging out :: $error');
    }
  }

  bool isSignedIn() {
    final session = supabaseAuth.currentSession;
    return (session != null);
  }

  Session? currentSession() {
    return supabaseAuth.currentSession;
  }

  User? currentUser() {
    return supabaseAuth.currentUser;
  }
}