import express from 'express';
import { NoteController } from '../controller/note_controller';

const noteRouter: express.Router = express.Router();

noteRouter.post('/addNote', NoteController.addNote);

noteRouter.get('/getMyNotes', NoteController.getMyNotes);

noteRouter.put('/updateNote', NoteController.updateNote);

noteRouter.delete('/deleteNote', NoteController.deleteNote);


export default noteRouter;