'use client';

import { useState, useEffect, useMemo } from 'react';
import { getLogsByDateRange } from '@/lib/database';
import { getDateNDaysAgo, getToday } from '@/lib/utils';
import { EmptyState } from '@/components/ui/empty-state';
import { ChartSkeleton } from '@/components/ui/skeleton-loader';
import { HRDeltaChart } from './hr-delta-chart';
import { SymptomHeatmap } from './symptom-heatmap';
import { HydrationChart } from './hydration-chart';
import { ActivitySymptomChart } from './activity-symptom-chart';
import { HeartRateChart } from './heart-rate-chart';
import { BestWorstDays } from './best-worst-days';
import { TrendingUp, BarChart3 } from 'lucide-react';
import type { DailyLog } from '@/types';
import { cn } from '@/lib/utils';

const TIME_RANGES = [
  { label: '7 Days', days: 7 },
  { label: '30 Days', days: 30 },
  { label: '90 Days', days: 90 },
];

export function TrendsScreen() {
  const [selectedRange, setSelectedRange] = useState(30);
  const [logs, setLogs] = useState<DailyLog[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchLogs = async () => {
      setLoading(true);
      const startDate = getDateNDaysAgo(selectedRange);
      const endDate = getToday();
      const data = await getLogsByDateRange(startDate, endDate);
      setLogs(data);
      setLoading(false);
    };
    fetchLogs();
  }, [selectedRange]);

  if (loading) {
    return (
      <div className="px-4 py-3 space-y-3">
        <ChartSkeleton />
        <ChartSkeleton />
        <ChartSkeleton />
      </div>
    );
  }

  if (logs.length === 0) {
    return (
      <EmptyState
        icon={<TrendingUp className="w-8 h-8 text-primary" />}
        title="No Data Yet"
        description="Start logging your daily vitals to see your trends and patterns here."
      />
    );
  }

  return (
    <div className="pb-24">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-bg-light dark:bg-bg-dark px-4 py-3 border-b border-gray-100 dark:border-gray-800">
        <h1 className="text-dynamic-xl font-bold text-gray-900 dark:text-gray-100 mb-3">
          Trends
        </h1>
        {/* Time range selector */}
        <div className="flex gap-2">
          {TIME_RANGES.map(({ label, days }) => (
            <button
              key={days}
              onClick={() => setSelectedRange(days)}
              className={cn(
                'px-4 py-2 rounded-xl text-dynamic-sm font-medium min-h-tap transition-all',
                selectedRange === days
                  ? 'bg-primary text-white'
                  : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400'
              )}
              aria-label={`Show ${label} of data`}
              aria-pressed={selectedRange === days}
            >
              {label}
            </button>
          ))}
        </div>
      </div>

      {/* Charts */}
      <div className="px-4 py-3 space-y-4">
        <HRDeltaChart logs={logs} />
        <SymptomHeatmap logs={logs} />
        <HydrationChart logs={logs} />
        <ActivitySymptomChart logs={logs} />
        <HeartRateChart logs={logs} />
        <BestWorstDays logs={logs} />
      </div>
    </div>
  );
}
