import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_flutter_note_app/cubit/note/cubit/note_cubit.dart';
import 'package:full_stack_flutter_note_app/models/note_model.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/common/common.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/custom_button.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/custom_text_field.dart';

import '../router/on_generate_route.dart';
import '../router/page_const.dart';

class UpdateNotePage extends StatefulWidget {
  const UpdateNotePage({super.key, required this.note});

  final NoteModel note;

  static Future<void> push(BuildContext context, {required NoteModel note}) {
    return pushRoute(context, route: PageConst.updateNotePage, arguments: note);
  }

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _titleController.value = TextEditingValue(
      text: widget.note.title!,
    );
    _descriptionController.value = TextEditingValue(
      text: widget.note.description!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Update Note"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          spacing: 20,
          children: [
            CustomTextField(
              hint: "Title",
              controller: _titleController,
            ),
            CustomTextField(
              maxLines: 10,
              hint: "Description",
              controller: _descriptionController,
            ),
            CustomGradientButton(
              title: "Update Note",
              onTap: _updateNote,
            )
          ],
        ),
      ),
    );
  }

  void _updateNote() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      showSnackBarMessage(
        context,
        message: "Please fill all the fields",
      );
      return;
    }

    context.read<NoteCubit>().updateNote(
          NoteModel(
            noteId: widget.note.noteId,
            title: _titleController.text,
            description: _descriptionController.text,
            createAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );

    showSnackBarMessage(
      context,
      message: "Note updated successfully",
    );
  }
}
