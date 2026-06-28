import { MongoClient, Db } from 'mongodb';

let mongoDb: Db;

export async function connectToMongoDb() {
    try {
        const url = "mongodb://127.0.0.1:27017/";
        const client = new MongoClient(url);

        await client.connect(); // ✅ REQUIRED

        mongoDb = client.db("notedb");

        console.log("✅ Connected to Notedb MongoDB...");
    } catch (error) {
        console.error("❌ MongoDB connection failed:", error);
    }
}

export function getMongoDb(): Db {
    if (!mongoDb) {
        throw new Error("Database not initialized!");
    }
    return mongoDb;
}