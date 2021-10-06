const express = require('express');
var bodyParser = require('body-parser')

const app = express();
app.use(express.json());

var store = []
var counter = [0, 0, 0]

const port = 3000;

app.get('/', function(req, res){
    res.sendFile(__dirname + '/index.htm');
});

app.use('/images', express.static('assets/images'))

app.get('/api/store', (_req, res) => {
    const items = { 'item1' : counter[0], 'item2' : counter[1], 'item3' : counter[2] }
    res.json(items)
    console.log(`List of items in the store requested by ${_req.ip}`)
});

app.post('/api/store', (req, res) => {
    console.log(req.body.message)
    var item = req.body.message.split("|")[1]
    counter[parseInt(item)]++
    res.status(200).send("success")
    console.log(`Received new item from ${req.ip}, content: ${JSON.stringify(req.body)}`)
});

app.listen(port, () => console.log(`Node App listening on port ${port}!`));
