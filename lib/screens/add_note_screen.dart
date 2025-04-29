import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../model/note.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final subjectController = TextEditingController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String selectedLabel = 'Ujian';

  final dbHelper = DatabaseHelper();

  void _saveNote() async {
    if (subjectController.text.isEmpty || titleController.text.isEmpty) return;

    final note = Note(
      subject: subjectController.text,
      title: titleController.text,
      content: contentController.text,
      label: selectedLabel,
    );

    await dbHelper.insertNote(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: InputDecoration(labelText: 'Mata Kuliah'),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Judul Catatan'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Isi Catatan (Opsional)'),
            ),
            DropdownButtonFormField<String>(
              value: selectedLabel,
              items: ['Ujian', 'Tugas', 'Materi']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedLabel = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Label'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
