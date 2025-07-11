import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesDialog extends StatefulWidget {
  final int? noteId;
  final String? title;
  final String? content;
  final int colorIndex;
  final List<Color> notesColors;

  final Future<void> Function({
    required int colorIndex,
    required String title,
    required String content,
    int? noteId,
  }) onNoteSaved;

  const NotesDialog({
    super.key,
    this.noteId,
    this.title,
    this.content,
    required this.colorIndex,
    required this.notesColors,
    required this.onNoteSaved,
  });

  @override
  State<NotesDialog> createState() => _NotesDialogState();
}

class _NotesDialogState extends State<NotesDialog> {
  late int _selectedColorIndex;

  @override
  void initState() {
    super.initState();
    _selectedColorIndex = widget.colorIndex;
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.title);
    final descriptionController = TextEditingController(text: widget.content);
    final currentDate = DateFormat('E d MMM').format(DateTime.now());

    return AlertDialog(
      backgroundColor: widget.notesColors[_selectedColorIndex],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        widget.noteId == null ? 'Create Note' : 'Edit Note',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentDate, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: List.generate(widget.notesColors.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                    });
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: widget.notesColors[index],
                    child: _selectedColorIndex == index
                        ? const Icon(Icons.check, color: Colors.black54, size: 20)
                        : null,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.black54, fontSize: 16)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
            await widget.onNoteSaved(
              noteId: widget.noteId,
              title: titleController.text,
              content: descriptionController.text,
              colorIndex: _selectedColorIndex,
            );
            Navigator.of(context).pop();
          },
          child: Text(widget.noteId == null ? 'Save' : 'Update', style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
