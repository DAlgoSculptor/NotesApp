import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final Function onTap;
  final Function onDelete;
  final List<Color> noteColors;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.noteColors,
  });

  @override
  Widget build(BuildContext context) {
    final colorIndex = note['colorIndex'] as int; // Default to 0 if not set

    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: noteColors[colorIndex],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note['date'],
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 8.0),
            Text(
              note['title'],
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            Expanded(
              child: Text(
                note['description'],
                style: const TextStyle(
                  // fontSize: 14.0,
                  color: Colors.black54,
                  height: 1.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.black54,
                    size: 20,
                  ),
                  onPressed: () => onDelete(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
