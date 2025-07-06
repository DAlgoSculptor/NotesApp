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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      
      home: Scaffold(
        appBar: AppBar(
          // title: const Text('NotesApp'),
          centerTitle: true,
          // backgroundColor: Colors.black54,
          elevation: 10,
        ),
        body: const NotesScreen(),
      ),
    );
  
  }
}