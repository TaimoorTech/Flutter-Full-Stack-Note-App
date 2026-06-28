import express from 'express';
import { UserController } from '../controller/user_controller';
import { getMongoDb } from '../config/mongodb_client';

const userRouter: express.Router = express.Router();


userRouter.post('/signup', UserController.signup)

userRouter.post('/signin', UserController.signin)

userRouter.get('/myProfile', UserController.myProfile)

userRouter.put('/updateProfile', UserController.updateProfile)



export default userRouter;