import express from 'express';
import cors from 'cors';
// cors -> with this help, we will load data into our application
import { connectToMongoDb } from './config/mongodb_client';
import appLogger
    from './middleware/app_logger';
import userRouter from './router/user_router';
import { hostname } from 'node:os';
import noteRouter from './router/note_router';

const app: express.Application = express();

const hostName = '192.168.100.7';
const port = 5001;

app.use(cors());
app.use(express.json());
app.use(appLogger);
app.use(express.urlencoded({ extended: false }));
app.use("/v1/notedb/user", userRouter)
app.use("/v1/notedb/note", noteRouter)

async function startServer() {
    await connectToMongoDb();

    app.listen(port, hostName, () => {
        console.log(`Server running on port http://${hostName}:${port}`);
    });
}

startServer();