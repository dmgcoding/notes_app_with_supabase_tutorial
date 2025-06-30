import 'package:supabase_flutter/supabase_flutter.dart';

class NotesRepo {
  final Supabase supabase;
  const NotesRepo(this.supabase);

  Future<void> addNote(String title, String content) async {
    try {
      final note = {
        "title": title,
        "content": content,
        "user_id": supabase.client.auth.currentUser?.id,
      };
      await supabase.client.from('notes').insert(note);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateNote(
    int id,
    String updatedTitle,
    String updatedContent,
  ) async {
    try {
      final updatedNote = {"title": updatedTitle, "content": updatedContent};
      await supabase.client.from('notes').update(updatedNote).eq('id', id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await supabase.client.from('notes').delete().eq('id', id);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getNoteStream() {
    return supabase.client.from('notes').stream(primaryKey: ['id']);
  }
}
