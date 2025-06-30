import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_with_supabase/pages/add_note.dart';
import 'package:notes_with_supabase/repos/auth_repo.dart';
import 'package:notes_with_supabase/repos/notes_repo.dart';
import 'package:notes_with_supabase/widgets/note_card.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Sample notes data - in a real app, this would come from Supabase
  List<Map<String, String>> notes = [
    {
      'id': '1',
      'title': 'Meeting Notes',
      'content': 'Discuss project timeline and deliverables for Q1',
    },
    {
      'id': '2',
      'title': 'Shopping List',
      'content': 'Milk, bread, eggs, vegetables, fruits',
    },
    {
      'id': '3',
      'title': 'Ideas for App',
      'content': 'Feature ideas: dark mode, offline sync, sharing',
    },
  ];

  late final Stream<List<Map<String, dynamic>>> stream;

  @override
  void initState() {
    stream = context.read<NotesRepo>().getNoteStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Center(
                    child: const Text(
                      'My Notes',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => context.read<AuthRepo>().signout(),
                  icon: Icon(Icons.logout, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 0),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: stream,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return const Center(
                      child: Text(
                        'some error occured!',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if ((snap.data ?? []).isEmpty) {
                    return const Center(
                      child: Text(
                        'No notes yet. Tap the + button to add one!',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snap.data?.length,
                    itemBuilder: (context, index) {
                      final note = snap.data![index];
                      return NoteCard(note: note);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddNotePage()),
        ),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Color(0xFF667eea)),
      ),
    );
  }
}
