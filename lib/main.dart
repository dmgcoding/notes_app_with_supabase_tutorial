import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_with_supabase/pages/auth.dart';
import 'package:notes_with_supabase/pages/notes.dart';
import 'package:notes_with_supabase/repos/auth_repo.dart';
import 'package:notes_with_supabase/repos/notes_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //make sure you read the readme.md about how to run the app
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseKey = String.fromEnvironment('SUPABASE_KEY');
  final supabase = await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  final authRepo = AuthRepo(supabase);
  final notesRepo = NotesRepo(supabase);

  runApp(MyApp(supabase: supabase, authRepo: authRepo, notesRepo: notesRepo));
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.supabase,
    required this.authRepo,
    required this.notesRepo,
    super.key,
  });
  final Supabase supabase;
  final AuthRepo authRepo;
  final NotesRepo notesRepo;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>.value(value: authRepo),
        RepositoryProvider<NotesRepo>.value(value: notesRepo),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: supabase.client.auth.onAuthStateChange,
          builder: (context, snap) {
            if (snap.data?.session != null) {
              return NotesPage();
            }

            return AuthPage();
          },
        ),
      ),
    );
  }
}
