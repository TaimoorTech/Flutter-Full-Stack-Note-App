import 'dart:convert';

import 'package:full_stack_flutter_note_app/models/note_model.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class ServerException implements Exception {
  final String errorMessage;

  ServerException(this.errorMessage);
}

class NetworkRepository {
  final http.Client httpClient = http.Client();

  String hostName = '192.168.100.6';
  int port = 5001;

  String _endPoint(String endPoint) {
    return "http://$hostName:$port/v1/notedb/$endPoint";
  }

  final Map<String, String> _header = {
    "Content-Type": "application/json; charset=utf-8"
  };

  Future<UserModel> signup(UserModel user) async {
    final encodedParams = json.encode(user.toJson());

    final response = await httpClient.post(
      Uri.parse(_endPoint("user/signup")),
      body: encodedParams,
      headers: _header,
    );

    if (response.statusCode == 200) {
      final userModel =
          UserModel.fromJson(json.decode(response.body)["response"]);
      return userModel;
    } else {
      throw ServerException(json.decode(response.body)["message"]);
    }
  }

  Future<UserModel> signIn(UserModel user) async {
    final encodedParams = json.encode(user.toJson());

    final response = await httpClient.post(
      Uri.parse(_endPoint("user/signin")),
      body: encodedParams,
      headers: _header,
    );

    if (response.statusCode == 200) {
      final userModel =
          UserModel.fromJson(json.decode(response.body)["response"]);
      return userModel;
    } else {
      throw ServerException(json.decode(response.body)["message"]);
    }
  }

  Future<UserModel> myProfile(String uid) async {
    final response = await httpClient.get(
      Uri.parse(_endPoint("user/myprofile?uid=$uid")),
      headers: _header,
    );

    if (response.statusCode == 200) {
      final userModel =
          UserModel.fromJson(json.decode(response.body)["response"]);
      return userModel;
    } else {
      throw ServerException(json.decode(response.body)["message"]);
    }
  }

  Future<UserModel> updateProfile(UserModel user) async {
    final encodedParams = json.encode(user.toJson());

    final response = await httpClient.put(
      Uri.parse(_endPoint("user/updateProfile")),
      body: encodedParams,
      headers: _header,
    );

    if (response.statusCode == 200) {
      final userModel =
          UserModel.fromJson(json.decode(response.body)["response"]);
      return userModel;
    } else {
      throw ServerException(json.decode(response.body)["message"]);
    }
  }

  Future<List<NoteModel>> getMyNotes(NoteModel note) async {
    final response = await httpClient.get(
      Uri.parse(_endPoint("note/getMyNotes?uid=${note.creatorId}")),
      headers: _header,
    );

    if (response.statusCode == 200) {
      final List<dynamic> notes = json.decode(response.body)["response"];
      final notesData = notes.map((note) => NoteModel.fromJson(note)).toList();
      return notesData;
    } else {
      throw ServerException(json.decode(response.body)["message"]);
    }
  }

  Future<void> addNote(NoteModel note) async {
    final encodedParams = json.encode(note.toJson());

    final response = await httpClient.post(
      Uri.parse(_endPoint("note/addNote")),
      body: encodedParams,
      headers: _header,
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw ServerException(json.decode(response.body)["message"]);
    }
  }

  Future<void> updateNote(NoteModel note) async {
    final encodedParams = json.encode(note.toJson());

    final response = await httpClient.put(
      Uri.parse(_endPoint("note/updateNote")),
      body: encodedParams,
      headers: _header,
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw ServerException(json.decode(response.body)["message"]);
    }
  }

  Future<void> deleteNote(NoteModel note) async {
    final encodedParams = json.encode(note.toJson());

    final response = await httpClient.delete(
      Uri.parse(_endPoint("note/deleteNote")),
      body: encodedParams,
      headers: _header,
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw ServerException(json.decode(response.body)["message"]);
    }
  }
}
