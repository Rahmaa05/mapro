import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../model/note.dart';
import 'add_note_screen.dart';
import '../widgets/background_gradient.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  List<Note> notes = [];
  String selectedLabel = '';
  String selectedSubject = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await dbHelper.getNotes(
      subjectFilter: selectedSubject.isNotEmpty ? selectedSubject : null,
      labelFilter: selectedLabel.isNotEmpty ? selectedLabel : null,
    );
    setState(() {
      notes = data;
    });
  }

  void _navigateToAddNote() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => AddNoteScreen()));
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Catatan Mata Kuliah'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              final result = await showDialog<Map<String, String?>>(
                context: context,
                builder: (context) => FilterDialog(),
              );
              if (result != null) {
                selectedSubject = result['subject'] ?? '';
                selectedLabel = result['label'] ?? '';
                _loadNotes();
              }
            },
          )
        ],
      ),
      body: BackgroundGradient(
        child: SafeArea(
          child: notes.isEmpty
              ? Center(
            child: Text(
              'Belum ada catatan',
              style: TextStyle(color: Colors.white70),
            ),
          )
              : ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                color: Colors.white.withOpacity(0.8),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Text('${note.subject} - ${note.label}'),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF7F5539),
        onPressed: _navigateToAddNote,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final subjectController = TextEditingController();
  String selectedLabel = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFF5E6C8),
      title: Text('Filter', style: TextStyle(color: Colors.brown[800])),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: subjectController,
            decoration: InputDecoration(labelText: 'Mata Kuliah'),
          ),
          DropdownButtonFormField<String>(
            value: selectedLabel.isNotEmpty ? selectedLabel : null,
            items: ['Ujian', 'Tugas', 'Materi']
                .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                .toList(),
            hint: Text('Pilih Label'),
            onChanged: (value) {
              setState(() {
                selectedLabel = value ?? '';
              });
            },
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, {
              'subject': subjectController.text,
              'label': selectedLabel,
            });
          },
          child: Text('Terapkan', style: TextStyle(color: Colors.brown)),
        )
      ],
    );
  }
}
