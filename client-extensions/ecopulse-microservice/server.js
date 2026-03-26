const express = require('express');
const app = express();
const port = 8080;

// Enable CORS for frontend interaction
app.use((req, res, next) => {
	res.header('Access-Control-Allow-Origin', '*');
	res.header(
		'Access-Control-Allow-Headers',
		'Origin, X-Requested-With, Content-Type, Accept, Authorization'
	);
	next();
});

app.get('/health', (req, res) => {
	res.json({ status: 'UP', service: 'EcoPulse Remote Intelligence' });
});

/**
 * Advanced Metrics Endpoint
 * Simulates heavy data crunching for grid efficiency
 */
app.get('/api/metrics/grid-efficiency', (req, res) => {
	const sectorId = req.query.sectorId || 'GLOBAL';

	// Mock efficiency calculation logic
	const baseEfficiency = 84.5;
	const fluctuation = Math.random() * 5 - 2.5;
	const efficiency = (baseEfficiency + fluctuation).toFixed(2);

	res.json({
		sectorId,
		metrics: {
			efficiency: parseFloat(efficiency),
			carbonIntensity: '240g/kWh',
			renewableRatio: '68.4%',
			timestamp: new Date().toISOString(),
		},
		status: 'VERIFIED',
	});
});

app.listen(port, () => {
	console.log(
		`EcoPulse Remote Intelligence listening at http://localhost:${port}`
	);
});
