import 'package:flutter/material.dart';
import 'package:notetaking_app/database/notes_database.dart';
import 'package:notetaking_app/screens/note_card.dart';
import 'package:notetaking_app/screens/notes_dialog.dart';

StatefulWidget notesScreen() {
  return NotesScreen();
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];
  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NotesDatabase.instance.getNotes();
    setState(() {
      notes = fetchedNotes;
    });
    // Simulate fetching notes from a database or API
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      notes = [
        {'title': 'Note 1', 'description': 'Content of Note 1'},
        {'title': 'Note 2', 'description': 'Content of Note 2'},
      ];
    });
  }

  final List<Color> noteColors = [
    Color(0xFFB388FF), // Light Purple
    Color(0xFF80D8FF), // Sky Blue
    Color(0xFFCCFF90), // Mint
    Color(0xFFFFAB91), // Peach
    Color(0xFFFFF59D), // Lemon
    Color(0xFFCFD8DC), // Steel Blue Grey
    Color(0xFFE1BEE7), // Lavender Pink
    Color(0xFFB2EBF2), // Ice Blue
    Color(0xFFFFCCBC), // Light Coral
    Color(0xFFD1C4E9), // Soft Lavender
    Color(0xFFAED581), // Fresh Green
    Color(0xFFFFD180), // Mango
    Color(0xFFFFE082), // Cream Yellow
    Color(0xFFB3E5FC), // Sky Light
    Color(0xFFB2DFDB), // Aqua Soft
    Color(0xFFCE93D8), // Orchid
    Color(0xFFFFF3E0), // Eggshell
    Color(0xFFE0F7FA), // Snow Cyan
    Color(0xFFDCEDC8), // Lime White
    Color(0xFFFFCDD2), // Rosé
  ];

  void showNoteDialog({
    int? noteId,
    String? title,
    String? content,
    int colorIndex = 0,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NotesDialog(
          colorIndex: colorIndex,
          notesColors: noteColors,
          noteId: noteId,
          title: title,
          content: content,
          onNoteSaved: (
            newTitle,
            newDescription,
            selectedColorIndex,
            currentDate,
          ) async {
            if (noteId == null) {
              await NotesDatabase.instance.addNote(
                newTitle,
                newDescription,
                selectedColorIndex,
                currentDate,
              );
            } else {
              await NotesDatabase.instance.updateNote(
                noteId,
                newTitle,
                newDescription,
                selectedColorIndex,
                currentDate,
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await NotesDatabase.instance.addNote(
          //   'New Note',
          //   'Content of New Note',
          //   // Default color index
          //   '2025-07-05',
          //   0, // Current date
          // );
          // Navigate to the note creation screen
          showNoteDialog();
        },
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.add, color: Colors.black87, size: 30),
      ),
      body:
          notes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      size: 50,
                      color: Colors.grey[600],
                    ),
                    SizedBox(height: 10),

                    Text(
                      'No Notes Available',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      onDelete: () async {
                        await NotesDatabase.instance.deleteNote(note['id']);
                        fetchNotes();
                      },
                      onTap: () {
                        showNoteDialog(
                          noteId: note['id'],
                          title: note['title'],
                          content: note['description'],
                          colorIndex: note['colorIndex'] ?? 0,
                        );
                      },
                      noteColors: noteColors,
                    );
                  },
                ),
              ),
    );
  }
}
