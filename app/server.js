const express = require('express');

const app = express();

app.use("/js",express.static('public/js'));
app.use("/css",express.static('public/css'));


app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/html/index.html');
});

app.listen(3010, () => console.log('Example app listening on port 3010!'));