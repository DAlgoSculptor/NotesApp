import 'package:flutter/material.dart';
import 'package:notetaking_app/screens/notes_screen.dart';
// import 'package:note_app/note_home_page.dart';

void main() {
  runApp(NoteApp());
}


class NoteApp extends StatelessWidget{
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: notesScreen()
    );
  }
}