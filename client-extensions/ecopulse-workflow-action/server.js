const express = require('express');
const app = express();
const port = 3004;

app.use(express.json());

app.get('/ready', (req, res) => {
	res.json({ status: 'READY' });
});

app.post('/workflow-action', (req, res) => {
	console.log('Received Workflow Action payload:');
	console.log(JSON.stringify(req.body, null, 2));

	res.status(200).send({
		message: 'Workflow Action processed successfully',
	});
});

app.listen(port, () => {
	console.log(
		`EcoPulse Workflow Action extension listening at http://localhost:${port}`
	);
});
