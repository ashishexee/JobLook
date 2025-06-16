const express = require('express');
const port = 3000;
const app =  express();
const dotenv  =  require('dotenv');
const mongoose = require('mongoose');
const jobRouter = require('../server/routes/jobRoutes');
const admin = require('firebase-admin');
const serverAccountKey = require('./serviceAccountKey.json');
const authRouter = require('./routes/authRoute');
const bookmarkRouter  = require('./routes/bookmarkRoute');
const userRouter  = require('./routes/userRoute');



dotenv.config();
app.use(express.json());
app.use(express.urlencoded({extended : true}));
admin.initializeApp({
    credential:  admin.credential.cert(serverAccountKey),
});

mongoose.connect(process.env.MONGO_URL).then(()=>{
    console.log('Connected to Mongoose Database for the JobLook');
})

app.use('/api/jobs',jobRouter);
app.use('/api',authRouter);
app.use('/api/bookmarks',bookmarkRouter);
app.use('/api/users', userRouter);

app.listen(process.env.PORT || port,()=>{
    console.log('server started');
})

