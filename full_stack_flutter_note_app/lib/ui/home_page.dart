import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_flutter_note_app/cubit/auth/auth_cubit.dart';
import 'package:full_stack_flutter_note_app/cubit/note/cubit/note_cubit.dart';
import 'package:full_stack_flutter_note_app/models/note_model.dart';
import 'package:full_stack_flutter_note_app/ui/add_note_page.dart';
import 'package:full_stack_flutter_note_app/ui/profile_page.dart';
import 'package:full_stack_flutter_note_app/ui/update_note_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    context.read<NoteCubit>().getMyNotes(
          NoteModel(creatorId: widget.uid),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("My Notes"),
        actions: [
          InkWell(
            onTap: () => ProfilePage.push(context, uid: widget.uid),
            child: Icon(Icons.person_outline),
          ),
          SizedBox(width: 20),
          InkWell(
            child: Icon(Icons.refresh),
            onTap: () {
              context
                  .read<NoteCubit>()
                  .getMyNotes(NoteModel(creatorId: widget.uid));
            },
          ),
          SizedBox(width: 20),
          InkWell(
            onTap: () => context.read<AuthCubit>().logOut(),
            child: Icon(Icons.logout),
          ),
          SizedBox(width: 15),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AddNotePage.push(context, uid: widget.uid),
      ),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, noteState) {
          if (noteState is NoteSuccess) {
            final notes = noteState.notes;

            notes.sort(
              (a, b) => DateTime.fromMillisecondsSinceEpoch(b.createAt!.toInt())
                  .compareTo(
                DateTime.fromMillisecondsSinceEpoch(a.createAt!.toInt()),
              ),
            );

            return notes.isEmpty
                ? _addNoteMessageWidget(context)
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Card(
                        child: ListTile(
                          onTap: () => UpdateNotePage.push(context, note: note),
                          title: Text("${note.title}"),
                          subtitle: Column(
                            children: [
                              Text("${note.description}"),
                              Text(
                                DateFormat("dd MMMM yyy hh:mm a").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    note.createAt!.toInt(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: InkWell(
                            child: Icon(
                              Icons.delete_outline,
                            ),
                            onTap: () {
                              context
                                  .read<NoteCubit>()
                                  .deleteNote(
                                    NoteModel(
                                      noteId: note.noteId,
                                    ),
                                  )
                                  .then((value) => {
                                        if (context.mounted)
                                          {
                                            context
                                                .read<NoteCubit>()
                                                .getMyNotes(
                                                  NoteModel(
                                                    creatorId: widget.uid,
                                                  ),
                                                ),
                                          }
                                      });
                            },
                          ),
                        ),
                      );
                    },
                  );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _addNoteMessageWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Add Notes",
            style: TextStyle(
              fontSize: 30,
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary
                  .withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
