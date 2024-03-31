const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const http = require('http');
const authRouter = require('./routes/auth');
const documentRouter = require('./routes/document');
const PORT = process.env.PORT | 3001;

const app = express();
var server = http.createServer(app);
var io = require('socket.io')(server);
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);


const DB = "mongodb+srv://aditya:malik9818@cluster0.micpfgt.mongodb.net/";



mongoose.connect(DB).then(() => {
   //console.log("connection success");
}).catch((error) => {
   console.log(error);
});

io.on("connection", (socket) => {
   console.log("A user connected");
   socket.on("join", (documentId)=> {
      console.log("Joining room:", documentId);
      socket.join(documentId);
      console.log("joined");
   });
    
   socket.on("typing", (data)=>{
      socket.broadcast.to(data.room).emit("changes", data);
   })

});

server.listen(PORT , "0.0.0.0",function () {
   console.log('connected at port '+ PORT);
});