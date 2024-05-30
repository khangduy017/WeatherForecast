import mongoose, { Mongoose } from "mongoose";

const subscribeSchema = new mongoose.Schema({
  email: String,
  location: String,
});
const Subscribe = mongoose.model('subscribes', subscribeSchema);

export default Subscribe;