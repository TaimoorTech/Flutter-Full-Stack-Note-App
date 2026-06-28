import express from 'express';
import { getMongoDb } from '../config/mongodb_client';
import bcrypt from 'bcrypt';
import { ObjectId } from 'mongodb';
import { User } from '../models/user_model';
import appLogger from '../middleware/app_logger';

// handle http requests and how user flows
export class UserController {

    static async signup(request: express.Request, response: express.Response) {
        let db = getMongoDb();

        let usersCollection = db.collection('users');

        const user: User = request.body;

        const checkUserInDb = {
            email: user.email
        }

        const data = await usersCollection.find(checkUserInDb).toArray();

        if (data.length > 0) {
            response.status(403).send(
                {
                    "status": "false",
                    "message": "User with this email already exists!"
                }
            );
        } else {
            // bcypt password
            const salt = bcrypt.genSaltSync(10);

            user.password = await bcrypt.hash(user.password, salt);

            const responseData = await usersCollection.insertOne(user);

            const objId = responseData.insertedId;

            const userInfo = await usersCollection.find({ _id: new ObjectId(objId) }).toArray();

            const userResponseData = userInfo[0];

            userResponseData.password = "";

            response.status(200).send(
                {
                    "status": "true",
                    "message": "User created successfully!",
                    "response": userResponseData,
                }
            );
        }
    }

    static async signin(request: express.Request, response: express.Response) {
        let db = getMongoDb();

        let usersCollection = db.collection('users');

        console.log("User signin request body: ", request.body);

        const user: User = request.body;

        console.log("User signin request: ", user);

        const checkUserInDb = {
            email: user.email
        }

        const data = await usersCollection.find(checkUserInDb).toArray();

        if (data.length != 0) {

            const userInfo = data[0];

            const pass = await bcrypt.compare(user.password, userInfo.password);

            if (user.email === userInfo.email && pass) {
                userInfo.password = "";
                response.status(200).send(
                    {
                        "status": "true",
                        "message": "User signed in successfully!",
                        "response": userInfo,
                    }
                );
            } else {
                response.status(403).send(
                    {
                        "status": "false",
                        "message": "Invalid email or password"
                    }
                );
            }
        } else {
            response.status(403).send(
                {
                    "status": "false",
                    "message": "Invalid email or password"
                }
            );
        }

    }

    static async myProfile(request: express.Request, response: express.Response) {
        let db = getMongoDb();

        let usersCollection = db.collection('users');

        const userId = request.query.uid;

        const userInfo = await usersCollection.find({ _id: new ObjectId(userId?.toString()) }).toArray();

        response.status(200).send(
            {
                "status": "true",
                "message": "User profile fetched successfully!",
                "response": userInfo[0],
            }
        );
    }

    static async updateProfile(request: express.Request, response: express.Response) {
        let db = getMongoDb();

        let usersCollection = db.collection('users');

        const user: User = request.body;

        const updateUserObject = {
            username: user.username,
            email: user.email,
        }

        const updateUserInfo = await usersCollection.updateOne({ _id: new ObjectId(user.uid) }, { $set: updateUserObject });

        response.status(200).send(
            {
                "status": "true",
                "message": "User profile updated successfully!",
                response: updateUserInfo,
            }
        );

    }
}