const express = require('express');
const app = express();
const port = 3003;

app.use(express.json());

app.get('/ready', (req, res) => {
	res.json({ status: 'READY' });
});

app.post('/object-action', (req, res) => {
	console.log('Received Object Action payload:');
	console.log(JSON.stringify(req.body, null, 2));

	res.status(200).send({
		message: 'Object Action received successfully',
	});
});

app.listen(port, () => {
	console.log(
		`EcoPulse Object Action extension listening at http://localhost:${port}`
	);
});
