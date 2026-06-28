import express from 'express';
import { getMongoDb } from '../config/mongodb_client';
import { Note } from '../models/note_model';
import appLogger from '../middleware/app_logger';
import { ObjectId } from 'mongodb';

export class NoteController {

    static async addNote(request: express.Request, response: express.Response) {

        let db = getMongoDb();

        let notesCollection = db.collection('notes');

        const note: Note = request.body;

        note.createAt = Date.now();

        const data = await notesCollection.insertOne(note);

        if (data.acknowledged) {
            response.status(200).json({
                "status": "success",
                "message": "Add note successfully",
                "response": data,
            });
        } else {
            response.status(500).json({
                "status": "error",
                "message": "Add note failed",
                "response": data,
            });
        }
    }

    static async getMyNotes(request: express.Request, response: express.Response) {

        let db = getMongoDb();

        let notesCollection = db.collection('notes');

        const uid = request.query.uid;

        console.log("uid: ", uid);

        const data = await notesCollection.find({ creatorId: uid?.toString() }).toArray();

        if (data.length > 0) {
            response.status(200).json({
                "status": "success",
                "message": "Get notes successfully",
                "response": data,
            });
        } else {
            response.status(404).json({
                "status": "error",
                "message": "No notes found",

            });
        }
    }

    static async updateNote(request: express.Request, response: express.Response) {

        let db = getMongoDb();

        let notesCollection = db.collection('notes');

        const note: Note = request.body;

        const updateNoteObject = {
            title: note.title,
            content: note.description,
            createAt: note.createAt,
        }

        const data = await notesCollection.updateOne({ _id: new ObjectId(note.noteId), },
            { $set: updateNoteObject },);


        if (data.acknowledged) {
            response.status(200).json({
                "status": "success",
                "message": "Update note successfully",
                "response": data,
            });
        } else {
            response.status(500).json({
                "status": "error",
                "message": "Update note failed",
                "response": data,
            });
        }
    }

    static async deleteNote(request: express.Request, response: express.Response) {

        let db = getMongoDb();

        let notesCollection = db.collection('notes');

        const note: Note = request.body;
        const data = await notesCollection.deleteOne({ _id: new ObjectId(note.noteId) });

        if (data.acknowledged) {
            response.status(200).json({
                "status": "success",
                "message": "Delete note successfully",
                "response": data,
            });
        } else {
            response.status(500).json({
                "status": "error",
                "message": "Delete note failed",
                "response": data,
            });
        }
    }
}