import React, { useEffect, useState } from 'react';
import { Liferay } from './services/liferay';

type Initiative = {
	impactLevel: number;
	title: string;
};

function App() {
	const [totalTons, setTotalTons] = useState(0);
	const [entryCount, setEntryCount] = useState(0);
	const [avgImpact, setAvgImpact] = useState(0);
	const [loading, setLoading] = useState(true);

	useEffect(() => {
		const fetchData = async () => {
			if (!window.Liferay || !window.Liferay.authToken) {
				// Simulated data for demo/local environment
				setTimeout(() => {
					const count = 42;
					const avg = 78;
					setEntryCount(count);
					setAvgImpact(avg);
					calculateImpact(count, avg);
					setLoading(false);
				}, 1000);
				return;
			}

			try {
				const response = await Liferay.Util.fetch(
					'/o/c/greeninitiatives/'
				);
				const data = await response.json();

				const count = data.totalCount || 0;
				const items: Initiative[] = data.items || [];
				const avg =
					items.length > 0
						? items.reduce(
								(acc, item) => acc + (item.impactLevel || 0),
								0
							) / items.length
						: 0;

				setEntryCount(count);
				setAvgImpact(Math.round(avg));
				calculateImpact(count, avg);
			} catch (error) {
				console.error('Error fetching green initiatives:', error);
			} finally {
				setLoading(false);
			}
		};

		fetchData();
	}, []);

	const calculateImpact = (count: number, avg: number) => {
		// Impact Algorithm: Total Tons = (Entry Count * 1.5) + (Average Impact Level * 0.8)
		const tons = count * 1.5 + avg * 0.8;
		setTotalTons(tons);
	};

	if (loading) {
		return <div className="p-4 text-center">Calculating Impact...</div>;
	}

	return (
		<div className="ecopulse-impact-calculator">
			<div className="d-flex justify-content-between align-items-center mb-1">
				<h2 className="h5 mb-0 text-navy font-weight-bold">
					Estimated CO2 Saved
				</h2>
				<span className="badge badge-soft-emerald px-2 py-1">
					REAL-TIME
				</span>
			</div>

			<div className="impact-display text-center">
				<span className="impact-value">
					{totalTons.toLocaleString(undefined, {
						maximumFractionDigits: 1,
					})}
					<span className="impact-unit">TONS</span>
				</span>
			</div>

			<div className="eco-scale-container">
				<div
					className="eco-scale-fill"
					style={{
						width: `${Math.min(100, (totalTons / 500) * 100)}%`,
					}}
				></div>
			</div>

			<div className="stats-grid">
				<div className="stat-item">
					<span className="stat-label">Active Initiatives</span>
					<span className="stat-value">{entryCount}</span>
				</div>
				<div className="stat-item text-right">
					<span className="stat-label">Avg. Node Impact</span>
					<span className="stat-value">{avgImpact}%</span>
				</div>
			</div>

			<div className="mt-4 text-center d-flex align-items-center justify-content-center gap-2 small text-muted font-italic">
				<img src="/documents/group/eco-pulse.svg" height="18" />
				Powered by Veridian Intelligence Layer
			</div>
		</div>
	);
}

export default App;
