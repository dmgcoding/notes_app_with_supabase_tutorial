import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepo {
  final Supabase supabase;
  const AuthRepo(this.supabase);

  Future<void> signup(String email, String pwd) async {
    try {
      final res = await supabase.client.auth.signUp(
        password: pwd,
        email: email,
      );
      final user = res.user;
      final profile = {"id": user?.id, "email": email};
      await supabase.client.from('users').insert(profile);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signin(String email, String pwd) async {
    try {
      await supabase.client.auth.signInWithPassword(
        password: pwd,
        email: email,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signout() async {
    try {
      await supabase.client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
