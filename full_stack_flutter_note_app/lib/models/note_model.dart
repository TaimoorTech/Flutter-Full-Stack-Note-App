import 'package:equatable/equatable.dart';

class NoteModel extends Equatable {
  final String? noteId;
  final String? title;
  final String? description;
  final num? createAt;
  final String? creatorId;

  const NoteModel({
    this.noteId,
    this.title,
    this.description,
    this.createAt,
    this.creatorId,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      noteId: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      createAt: json['createAt'] as num?,
      creatorId: json['creatorId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'title': title,
      'description': description,
      'createAt': createAt,
      'creatorId': creatorId,
    };
  }

  @override
  List<Object?> get props => [noteId, title, description, createAt, creatorId];
}
