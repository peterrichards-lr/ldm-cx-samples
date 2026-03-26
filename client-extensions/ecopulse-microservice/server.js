const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
	res.send('Hello from Sample Node Extension!');
});

app.listen(port, () => {
	console.log(`Sample node extension listening at http://localhost:${port}`);
});
