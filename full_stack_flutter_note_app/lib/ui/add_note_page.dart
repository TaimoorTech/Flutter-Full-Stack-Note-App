import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_flutter_note_app/cubit/note/cubit/note_cubit.dart';
import 'package:full_stack_flutter_note_app/models/note_model.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/common/common.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/custom_button.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/custom_text_field.dart';

import '../router/on_generate_route.dart';
import '../router/page_const.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key, required this.uid});

  final String uid;

  static Future<void> push(BuildContext context, {required String uid}) {
    return pushRoute(context, route: PageConst.addNotePage, arguments: uid);
  }

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Add New Note"),
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
              title: "Add Note",
              onTap: _addNewNote,
            )
          ],
        ),
      ),
    );
  }

  void _addNewNote() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      showSnackBarMessage(
        context,
        message: "Please fill all the fields",
      );
      return;
    }

    context
        .read<NoteCubit>()
        .addNote(
          NoteModel(
            title: _titleController.text,
            description: _descriptionController.text,
            creatorId: widget.uid,
          ),
        )
        .then((_) => _clearTextFields());

    showSnackBarMessage(
      context,
      message: "New Note added successfully",
    );
  }

  void _clearTextFields() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {});
  }
}
