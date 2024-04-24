import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  var webClientId = dotenv.env['WEB_CLIENT_ID']!;
  var iosClientId = dotenv.env['IOS_CLIENT_ID']!;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );
  return googleSignIn;
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);

  Future<void> signInWithGoogle() async {
    var webClientId = dotenv.env['WEB_CLIENT_ID']!;
    var iosClientId = dotenv.env['IOS_CLIENT_ID']!;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
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
      print("Logging in!!!!!!!");
      final res = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      state = res.user;
    } catch (error) {
      print('Error while login :: $error');
    }
  }

  void signOut() async {
    print("Logging out!!!!!!!");
    await Supabase.instance.client.auth.signOut();
    state = null; // Clear the user state
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});
