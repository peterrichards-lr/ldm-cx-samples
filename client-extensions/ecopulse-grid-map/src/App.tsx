import React, { useEffect, useState } from 'react';
import { Liferay } from './services/liferay';

type Sector = {
	externalReferenceCode: string;
	sectorName: string;
	operationalStatus: 'operational' | 'maintenance' | 'warning';
	load: number;
};

const DEFAULT_SECTORS: Sector[] = [
	{
		externalReferenceCode: 'N-1',
		load: 64,
		operationalStatus: 'operational',
		sectorName: 'Veridian North',
	},
	{
		externalReferenceCode: 'E-2',
		load: 12,
		operationalStatus: 'maintenance',
		sectorName: 'East Harbor',
	},
	{
		externalReferenceCode: 'S-3',
		load: 88,
		operationalStatus: 'operational',
		sectorName: 'Industrial South',
	},
	{
		externalReferenceCode: 'W-4',
		load: 92,
		operationalStatus: 'warning',
		sectorName: 'West Residential',
	},
	{
		externalReferenceCode: 'C-0',
		load: 45,
		operationalStatus: 'operational',
		sectorName: 'City Center',
	},
];

function App() {
	const [sectors, setSectors] = useState<Sector[]>(DEFAULT_SECTORS);
	const [isLive, setIsLive] = useState(false);
	const [selectedSector, setSelectedSector] = useState<string | null>(null);
	const [metrics, setMetrics] = useState<any>(null);

	// Fetch Advanced Metrics from Microservice when a sector is clicked
	useEffect(() => {
		if (!selectedSector) return;

		const fetchMetrics = async () => {
			try {
				// In a real LDM environment, this would resolve to the microservice internal/external URL
				const response = await fetch(
					`http://localhost:3001/api/metrics/grid-efficiency?sectorId=${selectedSector}`
				);
				const data = await response.json();
				setMetrics(data.metrics);
			} catch (error) {
				console.error('Error fetching advanced metrics:', error);
				// Mock metrics for demo resilience
				setMetrics({
					carbonIntensity: '240g/kWh',
					efficiency: 82.4,
					renewableRatio: '68.4%',
					timestamp: new Date().toISOString(),
				});
			}
		};

		fetchMetrics();
	}, [selectedSector]);

	// Fetch live data from Liferay Object API if available
	useEffect(() => {
		const fetchSectors = async () => {
			if (!window.Liferay || !window.Liferay.authToken) return;

			try {
				const response = await Liferay.Util.fetch('/o/c/energysectors');
				const data = await response.json();

				if (data.items && data.items.length > 0) {
					setSectors(data.items);
					setIsLive(true);
				}
			} catch (error) {
				console.error('Error fetching energy sectors:', error);
			}
		};

		fetchSectors();
	}, []);

	// Simulate "live" data pulses for visual feedback
	useEffect(() => {
		const interval = setInterval(() => {
			setSectors((prev) =>
				prev.map((s) => ({
					...s,
					load: Math.min(
						100,
						Math.max(0, s.load + (Math.random() * 4 - 2))
					),
				}))
			);
		}, 3000);
		return () => clearInterval(interval);
	}, []);

	return (
		<div className="ecopulse-grid-monitor p-4 rounded bg-white shadow-sm border border-light">
			<div className="d-flex justify-content-between align-items-center mb-4">
				<h2 className="h4 mb-0 text-navy font-weight-bold">
					<span className="innovation-pulse mr-2"></span>
					Energy Grid Monitor
				</h2>
				<div
					className={`badge badge-soft-${isLive ? 'emerald' : 'secondary'} px-3 py-2`}
				>
					{isLive ? 'LIVE' : 'SIMULATED'}: 98.2% HEALTH
				</div>
			</div>

			<div className="grid-container">
				{sectors.map((sector) => (
					<div
						className={`grid-node status-${sector.operationalStatus} ${selectedSector === sector.externalReferenceCode ? 'border-primary shadow-sm' : ''}`}
						key={sector.externalReferenceCode}
						onClick={() =>
							setSelectedSector(sector.externalReferenceCode)
						}
					>
						<div className="node-header d-flex justify-content-between">
							<span className="node-id">
								{sector.externalReferenceCode}
							</span>
							<span
								className={`status-dot dot-${sector.operationalStatus}`}
							></span>
						</div>
						<div className="node-body py-2">
							<div className="node-name small font-weight-bold text-navy">
								{sector.sectorName}
							</div>
							<div className="node-load mt-2">
								<div className="progress">
									<div
										className={`progress-bar ${sector.load > 90 ? 'bg-danger' : 'bg-innovation'}`}
										style={{ width: `${sector.load}%` }}
									></div>
								</div>
								<div className="d-flex justify-content-between mt-1 tiny-text text-muted">
									<span>LOAD</span>
									<span>{Math.round(sector.load)}%</span>
								</div>
							</div>
						</div>
					</div>
				))}
			</div>

			{selectedSector && metrics && (
				<div className="mt-4 p-3 bg-light rounded border border-primary animate-in shadow-sm">
					<div className="d-flex justify-content-between align-items-center mb-2">
						<h3 className="h6 mb-0 text-navy font-weight-bold text-uppercase letter-spacing-1">
							Advanced Sector Metrics: {selectedSector}
						</h3>
						<button
							className="btn btn-sm p-0 text-muted"
							onClick={(e) => {
								e.stopPropagation();
								setSelectedSector(null);
							}}
						>
							&times; Close
						</button>
					</div>
					<div className="row tiny-text text-center mt-3">
						<div className="col-4 border-right">
							<div className="text-muted mb-1 text-uppercase">
								Efficiency
							</div>
							<div className="text-navy font-weight-bold h6 mb-0">
								{metrics.efficiency}%
							</div>
						</div>
						<div className="col-4 border-right">
							<div className="text-muted mb-1 text-uppercase">
								Renewable
							</div>
							<div className="text-navy font-weight-bold h6 mb-0">
								{metrics.renewableRatio}
							</div>
						</div>
						<div className="col-4">
							<div className="text-muted mb-1 text-uppercase">
								Intensity
							</div>
							<div className="text-navy font-weight-bold h6 mb-0">
								{metrics.carbonIntensity}
							</div>
						</div>
					</div>
				</div>
			)}

			<div className="mt-4 pt-3 border-top d-flex justify-content-between align-items-center tiny-text text-muted">
				<span>VERIDIAN SMART CITY SYSTEMS</span>
				<div className="d-flex gap-3">
					<span className="d-flex align-items-center">
						<span className="status-dot dot-operational mr-1"></span>{' '}
						Operational
					</span>
					<span className="d-flex align-items-center">
						<span className="status-dot dot-maintenance mr-1"></span>{' '}
						Maintenance
					</span>
					<span className="d-flex align-items-center">
						<span className="status-dot dot-warning mr-1"></span>{' '}
						Warning
					</span>
				</div>
			</div>
		</div>
	);
}

export default App;
