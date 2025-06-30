import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_with_supabase/repos/notes_repo.dart';
import 'package:notes_with_supabase/widgets/btn.dart';

class AddNotePage extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;
  final int? id;

  const AddNotePage({
    super.key,
    this.initialTitle,
    this.initialContent,
    this.id,
  });

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _titleController.text = widget.initialTitle ?? '';
      _contentController.text = widget.initialContent ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void addNote() async {
    if (_titleController.text.isEmpty | _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("title or content can't be empty")),
      );
      return;
    }

    try {
      final noteRepo = context.read<NotesRepo>();
      await noteRepo.addNote(_titleController.text, _contentController.text);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void updateNote() async {
    if (_titleController.text.isEmpty | _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("title or content can't be empty")),
      );
      return;
    }

    try {
      final noteRepo = context.read<NotesRepo>();
      await noteRepo.updateNote(
        widget.id!,
        _titleController.text,
        _contentController.text,
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? 'Edit Note' : 'Add Note'),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF667eea)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _contentController,
                          decoration: InputDecoration(
                            labelText: 'Content',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF667eea)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 8,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter content';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        Center(
                          child: CustomButton(
                            ontap: widget.id != null ? updateNote : addNote,
                            text: widget.id != null
                                ? 'Update Note'
                                : 'Save Note',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
