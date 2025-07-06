import 'package:flutter/material.dart';
import 'package:notetaking_app/database/notes_database.dart';
import 'package:notetaking_app/screens/note_card.dart';
import 'package:notetaking_app/screens/notes_dialog.dart';

StatefulWidget notesScreen() {
  return const NotesScreen();
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
  }

  final List<Color> noteColors = [
  // Your existing colors
  Color(0xFFB388FF),
  Color(0xFF80D8FF),
  Color(0xFFCCFF90),
  Color(0xFFFFAB91),
  Color(0xFFFFF59D),
  Color(0xFFCFD8DC),
  Color(0xFFE1BEE7),
  Color(0xFFB2EBF2),
  Color(0xFFFFCCBC),
  Color(0xFFD1C4E9),
  Color(0xFFAED581),
  Color(0xFFFFD180),
  Color(0xFFFFE082),
  Color(0xFFB3E5FC),
  Color(0xFFB2DFDB),
  Color(0xFFCE93D8),
  Color(0xFFFFF3E0),
  Color(0xFFE0F7FA),
  Color(0xFFDCEDC8),
  Color(0xFFFFCDD2),
  Color(0xFFB2DFDB),
  Color(0xFFE1F5FE),
  Color(0xFFFFF9C4),

  // ✨ Fancy & Popular Additions
  Color(0xFFFAFAFA),   // Very soft white
  Color(0xFFEEF2F3),   // Frosted look
  Color(0xFFF5F7FA),   // Apple-like background
  Color(0xFFD0E6FF),   // Baby blue modern
  Color(0xFFE0BBE4),   // Light lavender
  Color(0xFFB5F5EC),   // Soft mint blue
  Color(0xFFFEF9EF),   // Cream white
  Color(0xFFB3C8CF),   // Muted ocean gray-blue
  Color(0xFFFCF1F1),   // Faint pink glass
  Color(0xFFD2EBE6),   // Calm teal tone
  Color(0xFFFFE4E1),   // Soft peach pink
  Color(0xFFE6E6FA),   // Lavender mist
  Color(0xFFF1F8E9),   // Calm leafy green
  Color(0xFFFFF0F5),   // Lavender blush
  Color(0xFFF3F4F6),   // Neutral light (grayish white)
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
          noteId: noteId,
          title: title,
          content: content,
          colorIndex: colorIndex,
          notesColors: noteColors,
          onNoteSaved: ({
            required int colorIndex,
            required String title,
            required String content,
            int? noteId,
          }) async {
            final date = DateTime.now().toIso8601String();

            if (noteId == null) {
              await NotesDatabase.instance.addNote(
                title,
                content,
                date,
                colorIndex,
              );
            } else {
              await NotesDatabase.instance.updateNote(
                noteId,
                title,
                content,
                date,
                colorIndex,
              );
            }

            fetchNotes();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
        onPressed: () => showNoteDialog(),
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add, color: Colors.black87, size: 30),
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add_outlined, size: 50, color: Colors.grey[600]),
                  const SizedBox(height: 10),
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
                  final id = note['id'];
                  final colorIndex = note['color'] ?? 0;
                  final title = note['title'] ?? '';
                  final description = note['description'] ?? '';
                  final date = note['date'] ?? '';

                  return NoteCard(
                    note: {
                      'id': id,
                      'title': title,
                      'description': description,
                      'date': date,
                      'colorIndex': colorIndex,
                    },
                    noteColors: noteColors,
                    onDelete: () async {
                      if (id != null && id is int) {
                        await NotesDatabase.instance.deleteNote(id);
                        fetchNotes();
                      }
                    },
                    onTap: () {
                      showNoteDialog(
                        noteId: id,
                        title: title,
                        content: description,
                        colorIndex: colorIndex,
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
