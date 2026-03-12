#!/bin/bash
set -e

cat > ~/Desktop/POTSTracker/src/components/trends/trends-screen.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/hr-delta-chart.tsx << 'ENDOFFILE'
'use client';

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ReferenceLine,
  ResponsiveContainer,
  Area,
  ComposedChart,
} from 'recharts';
import type { DailyLog } from '@/types';
import { formatDateShort } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
}

export function HRDeltaChart({ logs }: Props) {
  const data = logs
    .filter((l) => l.hr_lying != null && l.hr_standing != null)
    .map((l) => ({
      date: l.log_date,
      label: formatDateShort(l.log_date),
      delta: (l.hr_standing || 0) - (l.hr_lying || 0),
    }));

  if (data.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">HR Orthostatic Delta</h3>
        <p className="text-dynamic-sm text-gray-500">
          Log lying and standing heart rates to see your orthostatic delta trend.
        </p>
      </div>
    );
  }

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">HR Orthostatic Delta</h3>
      <ResponsiveContainer width="100%" height={220}>
        <ComposedChart data={data} margin={{ top: 5, right: 5, bottom: 5, left: -10 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis
            dataKey="label"
            tick={{ fontSize: 11 }}
            stroke="#9ca3af"
          />
          <YAxis
            tick={{ fontSize: 11 }}
            stroke="#9ca3af"
            domain={[0, 'auto']}
          />
          <Tooltip
            contentStyle={{
              borderRadius: '12px',
              border: 'none',
              boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
            }}
            formatter={(value: number) => [`+${value} BPM`, 'HR Delta']}
          />
          <ReferenceLine
            y={30}
            stroke="#F39C12"
            strokeDasharray="5 5"
            label={{ value: '30 BPM', position: 'right', fontSize: 10 }}
          />
          <ReferenceLine
            y={40}
            stroke="#E74C3C"
            strokeDasharray="5 5"
            label={{ value: '40 BPM', position: 'right', fontSize: 10 }}
          />
          <Line
            type="monotone"
            dataKey="delta"
            stroke="#0D7377"
            strokeWidth={2}
            dot={{ fill: '#0D7377', r: 4 }}
            activeDot={{ r: 6 }}
          />
        </ComposedChart>
      </ResponsiveContainer>
      <div className="flex gap-4 mt-2 text-dynamic-xs">
        <span className="flex items-center gap-1">
          <span className="w-3 h-3 rounded-full bg-success inline-block" /> &lt;30
        </span>
        <span className="flex items-center gap-1">
          <span className="w-3 h-3 rounded-full bg-warning inline-block" /> 30-39
        </span>
        <span className="flex items-center gap-1">
          <span className="w-3 h-3 rounded-full bg-danger inline-block" /> {'\u2265'}40
        </span>
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/symptom-heatmap.tsx << 'ENDOFFILE'
'use client';

import type { DailyLog } from '@/types';
import { formatDateShort } from '@/lib/utils';
import { cn } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
}

function getSeverityColor(severity: number): string {
  if (severity === 0) return 'bg-gray-100 dark:bg-gray-800';
  if (severity === 1) return 'bg-green-200 dark:bg-green-900';
  if (severity === 2) return 'bg-yellow-200 dark:bg-yellow-900';
  if (severity === 3) return 'bg-orange-300 dark:bg-orange-800';
  if (severity === 4) return 'bg-red-400 dark:bg-red-700';
  return 'bg-red-600 dark:bg-red-600';
}

export function SymptomHeatmap({ logs }: Props) {
  // Collect all unique symptoms across logs
  const symptomSet = new Set<string>();
  logs.forEach((log) => {
    log.symptoms?.forEach((s) => symptomSet.add(s.name));
  });
  const symptoms = Array.from(symptomSet);

  if (symptoms.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">Symptom Frequency</h3>
        <p className="text-dynamic-sm text-gray-500">
          Log symptoms to see a frequency heatmap.
        </p>
      </div>
    );
  }

  // Take last 14 days max for display
  const displayLogs = logs.slice(-14);

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">Symptom Frequency</h3>
      <div className="overflow-x-auto scrollbar-hide">
        <table className="min-w-full" role="grid" aria-label="Symptom frequency heatmap">
          <thead>
            <tr>
              <th className="text-left text-dynamic-xs text-gray-500 pb-2 pr-2 sticky left-0 bg-card-light dark:bg-card-dark">
                Symptom
              </th>
              {displayLogs.map((log) => (
                <th
                  key={log.log_date}
                  className="text-dynamic-xs text-gray-500 pb-2 px-0.5 min-w-[28px] text-center"
                >
                  {formatDateShort(log.log_date).split(' ')[1]}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {symptoms.map((symptom) => (
              <tr key={symptom}>
                <td className="text-dynamic-xs text-gray-700 dark:text-gray-300 pr-2 py-0.5 truncate max-w-[120px] sticky left-0 bg-card-light dark:bg-card-dark">
                  {symptom.length > 15 ? symptom.slice(0, 15) + '...' : symptom}
                </td>
                {displayLogs.map((log) => {
                  const entry = log.symptoms?.find((s) => s.name === symptom);
                  const severity = entry?.severity || 0;
                  return (
                    <td key={log.log_date} className="px-0.5 py-0.5 text-center">
                      <div
                        className={cn(
                          'w-6 h-6 rounded-sm mx-auto',
                          getSeverityColor(severity)
                        )}
                        title={`${symptom}: ${severity > 0 ? `Severity ${severity}` : 'Not logged'} on ${log.log_date}`}
                        aria-label={`${symptom} severity ${severity} on ${log.log_date}`}
                      />
                    </td>
                  );
                })}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Legend */}
      <div className="flex items-center gap-1 mt-3 text-dynamic-xs text-gray-500">
        <span>Less</span>
        {[0, 1, 2, 3, 4, 5].map((s) => (
          <div key={s} className={cn('w-4 h-4 rounded-sm', getSeverityColor(s))} />
        ))}
        <span>More</span>
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/hydration-chart.tsx << 'ENDOFFILE'
'use client';

import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ReferenceLine,
  ResponsiveContainer,
} from 'recharts';
import type { DailyLog } from '@/types';
import { formatDateShort } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
  goal?: number;
}

export function HydrationChart({ logs, goal = 64 }: Props) {
  const data = logs
    .filter((l) => l.water_intake != null)
    .map((l) => ({
      date: l.log_date,
      label: formatDateShort(l.log_date),
      water: l.water_intake || 0,
    }));

  if (data.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">Hydration</h3>
        <p className="text-dynamic-sm text-gray-500">
          Log your water intake to track hydration trends.
        </p>
      </div>
    );
  }

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">Hydration</h3>
      <ResponsiveContainer width="100%" height={200}>
        <BarChart data={data} margin={{ top: 5, right: 5, bottom: 5, left: -10 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis dataKey="label" tick={{ fontSize: 11 }} stroke="#9ca3af" />
          <YAxis tick={{ fontSize: 11 }} stroke="#9ca3af" />
          <Tooltip
            contentStyle={{
              borderRadius: '12px',
              border: 'none',
              boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
            }}
            formatter={(value: number) => [`${value} oz`, 'Water']}
          />
          <ReferenceLine
            y={goal}
            stroke="#2ECC71"
            strokeDasharray="5 5"
            label={{ value: `Goal: ${goal}oz`, position: 'right', fontSize: 10 }}
          />
          <Bar
            dataKey="water"
            fill="#0D7377"
            radius={[4, 4, 0, 0]}
            maxBarSize={30}
          />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/activity-symptom-chart.tsx << 'ENDOFFILE'
'use client';

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from 'recharts';
import type { DailyLog } from '@/types';
import { formatDateShort } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
}

const activityToNumber: Record<string, number> = {
  'Bedbound': 1,
  'Mostly Resting': 2,
  'Light Activity': 3,
  'Moderate': 4,
  'Active': 5,
};

export function ActivitySymptomChart({ logs }: Props) {
  const data = logs
    .filter((l) => l.activity_level || l.overall_rating)
    .map((l) => ({
      date: l.log_date,
      label: formatDateShort(l.log_date),
      activity: l.activity_level ? activityToNumber[l.activity_level] || 0 : undefined,
      rating: l.overall_rating,
    }));

  if (data.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">Activity vs. Day Rating</h3>
        <p className="text-dynamic-sm text-gray-500">
          Log activity and day ratings to see correlations.
        </p>
      </div>
    );
  }

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">Activity vs. Day Rating</h3>
      <ResponsiveContainer width="100%" height={220}>
        <LineChart data={data} margin={{ top: 5, right: 5, bottom: 5, left: -10 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis dataKey="label" tick={{ fontSize: 11 }} stroke="#9ca3af" />
          <YAxis yAxisId="left" tick={{ fontSize: 11 }} stroke="#9ca3af" domain={[1, 5]} />
          <YAxis yAxisId="right" orientation="right" tick={{ fontSize: 11 }} stroke="#9ca3af" domain={[1, 10]} />
          <Tooltip
            contentStyle={{
              borderRadius: '12px',
              border: 'none',
              boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
            }}
          />
          <Legend />
          <Line
            yAxisId="left"
            type="monotone"
            dataKey="activity"
            stroke="#F4845F"
            strokeWidth={2}
            name="Activity (1-5)"
            dot={{ r: 3 }}
          />
          <Line
            yAxisId="right"
            type="monotone"
            dataKey="rating"
            stroke="#0D7377"
            strokeWidth={2}
            name="Day Rating (1-10)"
            dot={{ r: 3 }}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/heart-rate-chart.tsx << 'ENDOFFILE'
'use client';

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from 'recharts';
import type { DailyLog } from '@/types';
import { formatDateShort } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
}

export function HeartRateChart({ logs }: Props) {
  const data = logs
    .filter((l) => l.hr_lying != null || l.hr_sitting != null || l.hr_standing != null)
    .map((l) => ({
      date: l.log_date,
      label: formatDateShort(l.log_date),
      lying: l.hr_lying,
      sitting: l.hr_sitting,
      standing: l.hr_standing,
    }));

  if (data.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">Heart Rate Over Time</h3>
        <p className="text-dynamic-sm text-gray-500">
          Log heart rates to see positional trends.
        </p>
      </div>
    );
  }

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">Heart Rate Over Time</h3>
      <ResponsiveContainer width="100%" height={220}>
        <LineChart data={data} margin={{ top: 5, right: 5, bottom: 5, left: -10 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis dataKey="label" tick={{ fontSize: 11 }} stroke="#9ca3af" />
          <YAxis tick={{ fontSize: 11 }} stroke="#9ca3af" />
          <Tooltip
            contentStyle={{
              borderRadius: '12px',
              border: 'none',
              boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
            }}
            formatter={(value: number) => [`${value} BPM`]}
          />
          <Legend />
          <Line
            type="monotone"
            dataKey="lying"
            stroke="#2ECC71"
            strokeWidth={2}
            name="Lying"
            dot={{ r: 3 }}
            connectNulls
          />
          <Line
            type="monotone"
            dataKey="sitting"
            stroke="#F39C12"
            strokeWidth={2}
            name="Sitting"
            dot={{ r: 3 }}
            connectNulls
          />
          <Line
            type="monotone"
            dataKey="standing"
            stroke="#E74C3C"
            strokeWidth={2}
            name="Standing"
            dot={{ r: 3 }}
            connectNulls
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/best-worst-days.tsx << 'ENDOFFILE'
'use client';

import type { DailyLog } from '@/types';
import { formatDate, getEmojiForRating } from '@/lib/utils';
import { cn } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
}

export function BestWorstDays({ logs }: Props) {
  const rated = logs.filter((l) => l.overall_rating != null);

  if (rated.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">Best & Worst Days</h3>
        <p className="text-dynamic-sm text-gray-500">
          Rate your days to see your best and worst.
        </p>
      </div>
    );
  }

  const sorted = [...rated].sort((a, b) => (b.overall_rating || 0) - (a.overall_rating || 0));
  const best = sorted.slice(0, 5);
  const worst = [...sorted].reverse().slice(0, 5);

  const DayRow = ({ log, rank }: { log: DailyLog; rank: number }) => {
    const rating = log.overall_rating || 0;
    const width = `${(rating / 10) * 100}%`;
    const topSymptom = log.symptoms?.[0]?.name;

    return (
      <div className="flex items-center gap-3 py-1.5">
        <span className="text-dynamic-xs text-gray-400 w-4">{rank}</span>
        <div className="flex-1">
          <div className="flex items-center justify-between mb-1">
            <span className="text-dynamic-sm text-gray-700 dark:text-gray-300">
              {formatDate(log.log_date)}
            </span>
            <span className="text-dynamic-sm font-semibold">
              {getEmojiForRating(rating)} {rating}/10
            </span>
          </div>
          <div className="w-full h-2 bg-gray-100 dark:bg-gray-700 rounded-full overflow-hidden">
            <div
              className={cn(
                'h-full rounded-full transition-all',
                rating >= 7 ? 'bg-success' : rating >= 4 ? 'bg-warning' : 'bg-danger'
              )}
              style={{ width }}
            />
          </div>
          {topSymptom && (
            <span className="text-dynamic-xs text-gray-400 mt-0.5 block">
              Top symptom: {topSymptom}
            </span>
          )}
        </div>
      </div>
    );
  };

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">Best & Worst Days</h3>

      <div className="space-y-4">
        <div>
          <h4 className="text-dynamic-sm font-medium text-success mb-2">Best Days</h4>
          {best.map((log, i) => (
            <DayRow key={log.log_date} log={log} rank={i + 1} />
          ))}
        </div>

        <div className="border-t border-gray-100 dark:border-gray-700 pt-3">
          <h4 className="text-dynamic-sm font-medium text-danger mb-2">Toughest Days</h4>
          {worst.map((log, i) => (
            <DayRow key={log.log_date} log={log} rank={i + 1} />
          ))}
        </div>
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/insights/insights-screen.tsx << 'ENDOFFILE'
'use client';

import { useState, useEffect } from 'react';
import { Lightbulb, FileText, ChevronRight, TrendingDown, TrendingUp, AlertTriangle, Info, CheckCircle } from 'lucide-react';
import { getLogsByDateRange } from '@/lib/database';
import { generateInsights, generateDoctorSummary } from '@/lib/insights-engine';
import { getDateNDaysAgo, getToday } from '@/lib/utils';
import { EmptyState } from '@/components/ui/empty-state';
import { CardSkeleton } from '@/components/ui/skeleton-loader';
import type { DailyLog, Insight } from '@/types';
import { cn } from '@/lib/utils';

const typeConfig = {
  positive: { icon: CheckCircle, color: 'text-success', bg: 'bg-success/10', border: 'border-success/30' },
  warning: { icon: AlertTriangle, color: 'text-warning', bg: 'bg-warning/10', border: 'border-warning/30' },
  negative: { icon: TrendingDown, color: 'text-danger', bg: 'bg-danger/10', border: 'border-danger/30' },
  info: { icon: Info, color: 'text-primary', bg: 'bg-primary/10', border: 'border-primary/30' },
};

export function InsightsScreen() {
  const [insights, setInsights] = useState<Insight[]>([]);
  const [logs, setLogs] = useState<DailyLog[]>([]);
  const [loading, setLoading] = useState(true);
  const [expandedTip, setExpandedTip] = useState<string | null>(null);
  const [showSummary, setShowSummary] = useState(false);
  const [summaryDays, setSummaryDays] = useState(30);

  useEffect(() => {
    const fetch = async () => {
      setLoading(true);
      const startDate = getDateNDaysAgo(90);
      const endDate = getToday();
      const data = await getLogsByDateRange(startDate, endDate);
      setLogs(data);
      setInsights(generateInsights(data));
      setLoading(false);
    };
    fetch();
  }, []);

  if (loading) {
    return (
      <div className="px-4 py-3 space-y-3">
        <CardSkeleton />
        <CardSkeleton />
        <CardSkeleton />
      </div>
    );
  }

  if (logs.length < 3) {
    return (
      <EmptyState
        icon={<Lightbulb className="w-8 h-8 text-primary" />}
        title="Not Enough Data"
        description="Log at least 3 days of data to start seeing insights and patterns."
      />
    );
  }

  return (
    <div className="pb-24">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-bg-light dark:bg-bg-dark px-4 py-3 border-b border-gray-100 dark:border-gray-800">
        <h1 className="text-dynamic-xl font-bold text-gray-900 dark:text-gray-100">
          Insights
        </h1>
        <p className="text-dynamic-sm text-gray-500 mt-1">
          Patterns detected from your data
        </p>
      </div>

      <div className="px-4 py-3 space-y-3">
        {/* Insight Cards */}
        {insights.length === 0 ? (
          <div className="card p-4 text-center">
            <p className="text-dynamic-sm text-gray-500">
              Keep logging to discover patterns. More data = better insights.
            </p>
          </div>
        ) : (
          insights.map((insight) => {
            const config = typeConfig[insight.type];
            const Icon = config.icon;
            const isExpanded = expandedTip === insight.id;

            return (
              <div
                key={insight.id}
                className={cn('card border', config.border)}
              >
                <div className="p-4">
                  <div className="flex items-start gap-3">
                    <div className={cn('w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0', config.bg)}>
                      <Icon className={cn('w-5 h-5', config.color)} />
                    </div>
                    <div className="flex-1">
                      <h3 className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100">
                        {insight.title}
                      </h3>
                      <p className="text-dynamic-sm text-gray-600 dark:text-gray-400 mt-1">
                        {insight.description}
                      </p>
                    </div>
                  </div>

                  {insight.tip && (
                    <>
                      <button
                        onClick={() =>
                          setExpandedTip(isExpanded ? null : insight.id)
                        }
                        className="mt-3 flex items-center gap-1 text-primary text-dynamic-sm font-medium min-h-tap"
                        aria-label={`${isExpanded ? 'Hide' : 'Show'} tips for ${insight.title}`}
                        aria-expanded={isExpanded}
                      >
                        What can I do?
                        <ChevronRight
                          className={cn(
                            'w-4 h-4 transition-transform',
                            isExpanded && 'rotate-90'
                          )}
                        />
                      </button>
                      {isExpanded && (
                        <div className="mt-2 p-3 bg-gray-50 dark:bg-gray-800 rounded-xl animate-fade-in">
                          <p className="text-dynamic-sm text-gray-700 dark:text-gray-300 leading-relaxed">
                            {insight.tip}
                          </p>
                        </div>
                      )}
                    </>
                  )}
                </div>
              </div>
            );
          })
        )}

        {/* Doctor Visit Prep */}
        <div className="card p-4 mt-6">
          <div className="flex items-center gap-3 mb-3">
            <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center">
              <FileText className="w-5 h-5 text-primary" />
            </div>
            <div>
              <h3 className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100">
                Doctor Visit Prep
              </h3>
              <p className="text-dynamic-sm text-gray-500">
                Generate a summary report for your doctor
              </p>
            </div>
          </div>

          <div className="flex gap-2 mb-3">
            {[30, 90].map((days) => (
              <button
                key={days}
                onClick={() => setSummaryDays(days)}
                className={cn(
                  'px-4 py-2 rounded-xl text-dynamic-sm font-medium min-h-tap transition-all',
                  summaryDays === days
                    ? 'bg-primary text-white'
                    : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400'
                )}
                aria-pressed={summaryDays === days}
              >
                Last {days} Days
              </button>
            ))}
          </div>

          <button
            onClick={() => setShowSummary(!showSummary)}
            className="btn-primary w-full"
            aria-label="Generate doctor visit summary"
          >
            {showSummary ? 'Hide Summary' : 'Generate Summary'}
          </button>

          {showSummary && (
            <div className="mt-4 animate-fade-in">
              <pre className="bg-gray-50 dark:bg-gray-800 rounded-xl p-4 text-dynamic-xs text-gray-700 dark:text-gray-300 overflow-x-auto whitespace-pre-wrap font-mono leading-relaxed">
                {generateDoctorSummary(
                  logs.filter(
                    (l) => l.log_date >= getDateNDaysAgo(summaryDays)
                  ),
                  summaryDays
                )}
              </pre>
              <div className="flex gap-2 mt-3">
                <button
                  className="btn-secondary flex-1 text-dynamic-sm"
                  onClick={() => {
                    const text = generateDoctorSummary(
                      logs.filter((l) => l.log_date >= getDateNDaysAgo(summaryDays)),
                      summaryDays
                    );
                    if (navigator.clipboard) {
                      navigator.clipboard.writeText(text);
                    }
                  }}
                  aria-label="Copy summary to clipboard"
                >
                  Copy Text
                </button>
                <button
                  className="btn-primary flex-1 text-dynamic-sm"
                  aria-label="Share summary"
                >
                  Share / Export PDF
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/profile/profile-screen.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import {
  User, Pill, AlertCircle, Bell, Ruler, Database,
  Shield, Info, ChevronRight, Trash2, Download,
  FileText, Cloud, Star, ExternalLink, Plus, X,
} from 'lucide-react';
import { useAppStore } from '@/stores/app-store';
import { ToggleSwitch } from '@/components/ui/toggle-switch';
import { exportAllDataAsCSV, clearAllData } from '@/lib/database';
import { DIAGNOSIS_TYPES, type DiagnosisType, type Medication } from '@/types';
import { cn } from '@/lib/utils';

export function ProfileScreen() {
  const { profile, updateProfile } = useAppStore();
  const [showClearConfirm, setShowClearConfirm] = useState(false);
  const [editingMed, setEditingMed] = useState(false);
  const [newMedName, setNewMedName] = useState('');
  const [newMedDosage, setNewMedDosage] = useState('');
  const [newCustomSymptom, setNewCustomSymptom] = useState('');
  const [showAddSymptom, setShowAddSymptom] = useState(false);

  const handleExportCSV = async () => {
    const csv = await exportAllDataAsCSV();
    if (!csv) return;
    // Create blob and download
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `POTSTracker_Export_${new Date().toISOString().split('T')[0]}.csv`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  const handleClearData = async () => {
    await clearAllData();
    setShowClearConfirm(false);
    window.location.reload();
  };

  const addMedication = () => {
    if (!newMedName.trim()) return;
    const med: Medication = {
      id: crypto.randomUUID?.() || Math.random().toString(36).slice(2),
      name: newMedName.trim(),
      dosage: newMedDosage.trim(),
      time_of_day: 'morning',
      reminder_enabled: false,
    };
    updateProfile({
      medications: [...(profile?.medications || []), med],
    });
    setNewMedName('');
    setNewMedDosage('');
    setEditingMed(false);
  };

  const removeMedication = (id: string) => {
    updateProfile({
      medications: (profile?.medications || []).filter((m) => m.id !== id),
    });
  };

  const addCustomSymptom = () => {
    if (!newCustomSymptom.trim()) return;
    updateProfile({
      custom_symptoms: [...(profile?.custom_symptoms || []), newCustomSymptom.trim()],
    });
    setNewCustomSymptom('');
    setShowAddSymptom(false);
  };

  const removeCustomSymptom = (symptom: string) => {
    updateProfile({
      custom_symptoms: (profile?.custom_symptoms || []).filter((s) => s !== symptom),
    });
  };

  return (
    <div className="pb-24">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-bg-light dark:bg-bg-dark px-4 py-3 border-b border-gray-100 dark:border-gray-800">
        <h1 className="text-dynamic-xl font-bold text-gray-900 dark:text-gray-100">
          Profile & Settings
        </h1>
      </div>

      <div className="px-4 py-3 space-y-4">
        {/* Personal Info */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <User className="w-5 h-5 text-primary" />
            <h3 className="section-title">Personal Info</h3>
          </div>
          <div className="space-y-3">
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Name</label>
              <input
                type="text"
                value={profile?.name || ''}
                onChange={(e) => updateProfile({ name: e.target.value })}
                className="input-field"
                placeholder="Your name"
                aria-label="Name"
              />
            </div>
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Date of Birth</label>
              <input
                type="date"
                value={profile?.dob || ''}
                onChange={(e) => updateProfile({ dob: e.target.value })}
                className="input-field"
                aria-label="Date of birth"
              />
            </div>
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Diagnosis</label>
              <select
                value={profile?.diagnosis_type || 'Undiagnosed'}
                onChange={(e) =>
                  updateProfile({ diagnosis_type: e.target.value as DiagnosisType })
                }
                className="input-field"
                aria-label="Diagnosis type"
              >
                {DIAGNOSIS_TYPES.map((d) => (
                  <option key={d} value={d}>{d}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Gender</label>
              <select
                value={profile?.gender || 'prefer-not-to-say'}
                onChange={(e) =>
                  updateProfile({ gender: e.target.value as Profile['gender'] })
                }
                className="input-field"
                aria-label="Gender"
              >
                <option value="female">Female</option>
                <option value="male">Male</option>
                <option value="non-binary">Non-Binary</option>
                <option value="prefer-not-to-say">Prefer not to say</option>
              </select>
            </div>
          </div>
        </div>

        {/* Medications */}
        <div className="card p-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <Pill className="w-5 h-5 text-primary" />
              <h3 className="section-title">Medications</h3>
            </div>
            <button
              onClick={() => setEditingMed(true)}
              className="text-primary text-dynamic-sm font-medium min-h-tap flex items-center gap-1"
              aria-label="Add medication"
            >
              <Plus className="w-4 h-4" /> Add
            </button>
          </div>

          {(profile?.medications || []).length === 0 && !editingMed && (
            <p className="text-dynamic-sm text-gray-500">No medications added.</p>
          )}

          {(profile?.medications || []).map((med) => (
            <div
              key={med.id}
              className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700 last:border-0"
            >
              <div>
                <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                  {med.name}
                </span>
                {med.dosage && (
                  <span className="text-dynamic-sm text-gray-500 ml-2">{med.dosage}</span>
                )}
              </div>
              <button
                onClick={() => removeMedication(med.id)}
                className="min-h-tap min-w-tap flex items-center justify-center text-danger"
                aria-label={`Remove ${med.name}`}
              >
                <X className="w-4 h-4" />
              </button>
            </div>
          ))}

          {editingMed && (
            <div className="space-y-2 mt-3 pt-3 border-t border-gray-100 dark:border-gray-700">
              <input
                type="text"
                value={newMedName}
                onChange={(e) => setNewMedName(e.target.value)}
                placeholder="Medication name"
                className="input-field"
                aria-label="New medication name"
                autoFocus
              />
              <input
                type="text"
                value={newMedDosage}
                onChange={(e) => setNewMedDosage(e.target.value)}
                placeholder="Dosage (e.g., 10mg)"
                className="input-field"
                aria-label="Medication dosage"
              />
              <div className="flex gap-2">
                <button onClick={addMedication} className="btn-primary flex-1 text-dynamic-sm">
                  Save
                </button>
                <button
                  onClick={() => setEditingMed(false)}
                  className="btn-secondary flex-1 text-dynamic-sm"
                >
                  Cancel
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Custom Symptoms */}
        <div className="card p-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <AlertCircle className="w-5 h-5 text-primary" />
              <h3 className="section-title">Custom Symptoms</h3>
            </div>
            <button
              onClick={() => setShowAddSymptom(true)}
              className="text-primary text-dynamic-sm font-medium min-h-tap flex items-center gap-1"
              aria-label="Add custom symptom"
            >
              <Plus className="w-4 h-4" /> Add
            </button>
          </div>

          {(profile?.custom_symptoms || []).length === 0 && !showAddSymptom && (
            <p className="text-dynamic-sm text-gray-500">No custom symptoms added.</p>
          )}

          <div className="flex flex-wrap gap-2">
            {(profile?.custom_symptoms || []).map((symptom) => (
              <span
                key={symptom}
                className="inline-flex items-center gap-1 px-3 py-1.5 rounded-full bg-gray-100 dark:bg-gray-800 text-dynamic-sm"
              >
                {symptom}
                <button
                  onClick={() => removeCustomSymptom(symptom)}
                  className="text-gray-400 hover:text-danger min-w-tap min-h-[28px] flex items-center"
                  aria-label={`Remove ${symptom}`}
                >
                  <X className="w-3 h-3" />
                </button>
              </span>
            ))}
          </div>

          {showAddSymptom && (
            <div className="flex gap-2 mt-3">
              <input
                type="text"
                value={newCustomSymptom}
                onChange={(e) => setNewCustomSymptom(e.target.value)}
                placeholder="Symptom name"
                className="input-field flex-1"
                onKeyDown={(e) => e.key === 'Enter' && addCustomSymptom()}
                aria-label="New custom symptom"
                autoFocus
              />
              <button onClick={addCustomSymptom} className="btn-primary px-4 text-dynamic-sm">
                Add
              </button>
            </div>
          )}
        </div>

        {/* Notifications */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Bell className="w-5 h-5 text-primary" />
            <h3 className="section-title">Notifications</h3>
          </div>
          <div className="space-y-1">
            <ToggleSwitch
              checked={!!profile?.notification_log_time}
              onChange={(v) =>
                updateProfile({ notification_log_time: v ? '20:00' : undefined })
              }
              label="Daily Log Reminder"
              description="Reminds you to log your vitals"
            />
            {profile?.notification_log_time && (
              <div className="pl-4 py-1">
                <label className="text-dynamic-xs text-gray-500 block mb-1">Reminder Time</label>
                <input
                  type="time"
                  value={profile.notification_log_time}
                  onChange={(e) => updateProfile({ notification_log_time: e.target.value })}
                  className="input-field w-40"
                  aria-label="Daily log reminder time"
                />
              </div>
            )}
            <ToggleSwitch
              checked={!!profile?.notification_hydration_interval}
              onChange={(v) =>
                updateProfile({ notification_hydration_interval: v ? 2 : undefined })
              }
              label="Hydration Reminders"
              description="Every 2 hours during the day"
            />
          </div>
        </div>

        {/* Units */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Ruler className="w-5 h-5 text-primary" />
            <h3 className="section-title">Units</h3>
          </div>
          <div className="flex gap-2">
            {(['imperial', 'metric'] as const).map((unit) => (
              <button
                key={unit}
                onClick={() => updateProfile({ units: unit })}
                className={cn(
                  'flex-1 py-3 rounded-xl text-dynamic-base font-medium min-h-tap transition-all border',
                  profile?.units === unit
                    ? 'bg-primary text-white border-primary'
                    : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
                )}
                aria-pressed={profile?.units === unit}
              >
                {unit === 'imperial' ? 'Imperial (oz, lbs)' : 'Metric (mL, kg)'}
              </button>
            ))}
          </div>
        </div>

        {/* Data Management */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Database className="w-5 h-5 text-primary" />
            <h3 className="section-title">Data Management</h3>
          </div>
          <div className="space-y-2">
            <button
              onClick={handleExportCSV}
              className="flex items-center justify-between w-full py-3 min-h-tap"
              aria-label="Export data as CSV"
            >
              <div className="flex items-center gap-3">
                <Download className="w-5 h-5 text-gray-500" />
                <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                  Export All Data (CSV)
                </span>
              </div>
              <ChevronRight className="w-5 h-5 text-gray-400" />
            </button>

            <button
              className="flex items-center justify-between w-full py-3 min-h-tap"
              aria-label="Export PDF summary report"
            >
              <div className="flex items-center gap-3">
                <FileText className="w-5 h-5 text-gray-500" />
                <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                  Export PDF Report
                </span>
              </div>
              <ChevronRight className="w-5 h-5 text-gray-400" />
            </button>

            <div className="flex items-center justify-between w-full py-3 min-h-tap opacity-60">
              <div className="flex items-center gap-3">
                <Cloud className="w-5 h-5 text-gray-500" />
                <div>
                  <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                    iCloud Backup
                  </span>
                  <span className="badge-warning ml-2">Coming Soon</span>
                </div>
              </div>
            </div>

            <button
              onClick={() => setShowClearConfirm(true)}
              className="flex items-center gap-3 w-full py-3 min-h-tap text-danger"
              aria-label="Clear all data"
            >
              <Trash2 className="w-5 h-5" />
              <span className="text-dynamic-base font-medium">Clear All Data</span>
            </button>
          </div>
        </div>

        {/* Clear data confirmation */}
        {showClearConfirm && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-6">
            <div className="bg-white dark:bg-card-dark rounded-2xl p-6 max-w-sm w-full animate-fade-in">
              <h3 className="text-dynamic-lg font-bold text-danger mb-2">
                Delete All Data?
              </h3>
              <p className="text-dynamic-sm text-gray-600 dark:text-gray-400 mb-4">
                This will permanently delete all your logs, profile data, and settings.
                This action cannot be undone.
              </p>
              <div className="flex gap-3">
                <button
                  onClick={() => setShowClearConfirm(false)}
                  className="btn-secondary flex-1"
                >
                  Cancel
                </button>
                <button onClick={handleClearData} className="btn-danger flex-1">
                  Delete Everything
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Security */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Shield className="w-5 h-5 text-primary" />
            <h3 className="section-title">Security</h3>
          </div>
          <ToggleSwitch
            checked={!!profile?.biometric_enabled}
            onChange={(v) => updateProfile({ biometric_enabled: v })}
            label="Face ID / Touch ID"
            description="Protect your health data with biometrics"
          />
        </div>

        {/* About */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Info className="w-5 h-5 text-primary" />
            <h3 className="section-title">About</h3>
          </div>
          <div className="space-y-2">
            <div className="flex items-center justify-between py-2">
              <span className="text-dynamic-base text-gray-600 dark:text-gray-400">Version</span>
              <span className="text-dynamic-base text-gray-900 dark:text-gray-100">1.0.0</span>
            </div>
            <button className="flex items-center justify-between w-full py-2 min-h-tap">
              <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                Privacy Policy
              </span>
              <ExternalLink className="w-4 h-4 text-gray-400" />
            </button>
            <button className="flex items-center justify-between w-full py-2 min-h-tap">
              <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                Terms of Use
              </span>
              <ExternalLink className="w-4 h-4 text-gray-400" />
            </button>
            <button
              className="flex items-center gap-2 w-full py-2 min-h-tap text-primary font-medium"
              aria-label="Rate the app"
            >
              <Star className="w-5 h-5" />
              <span className="text-dynamic-base">Rate POTSTracker</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/ios/App/PrivacyInfo.xcprivacy << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>NSPrivacyTracking</key>
  <false/>
  <key>NSPrivacyTrackingDomains</key>
  <array/>
  <key>NSPrivacyCollectedDataTypes</key>
  <array/>
  <key>NSPrivacyAccessedAPITypes</key>
  <array>
    <dict>
      <key>NSPrivacyAccessedAPIType</key>
      <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
      <key>NSPrivacyAccessedAPITypeReasons</key>
      <array>
        <string>CA92.1</string>
      </array>
    </dict>
    <dict>
      <key>NSPrivacyAccessedAPIType</key>
      <string>NSPrivacyAccessedAPICategoryFileTimestamp</string>
      <key>NSPrivacyAccessedAPITypeReasons</key>
      <array>
        <string>C617.1</string>
      </array>
    </dict>
  </array>
</dict>
</plist>
ENDOFFILE

cat > ~/Desktop/POTSTracker/ios/App/Info.plist.additions << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Add these keys to your Info.plist in Xcode.
  These are the required privacy descriptions for App Store submission.
-->
<dict>
  <!-- Face ID / Biometric Auth -->
  <key>NSFaceIDUsageDescription</key>
  <string>Used to protect your private health data</string>

  <!-- HealthKit Read -->
  <key>NSHealthShareUsageDescription</key>
  <string>Used to read heart rate data from Apple Health</string>

  <!-- HealthKit Write -->
  <key>NSHealthUpdateUsageDescription</key>
  <string>Used to write symptom data to Apple Health</string>

  <!-- HealthKit Entitlement -->
  <key>UIBackgroundModes</key>
  <array>
    <string>processing</string>
  </array>

  <!-- App Category -->
  <key>LSApplicationCategoryType</key>
  <string>public.app-category.medical</string>

  <!-- Minimum iOS Version -->
  <key>MinimumOSVersion</key>
  <string>16.0</string>
</dict>
ENDOFFILE

cat > ~/Desktop/POTSTracker/ios/App/App.entitlements << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>com.apple.developer.healthkit</key>
  <true/>
  <key>com.apple.developer.healthkit.access</key>
  <array>
    <string>health-records</string>
  </array>
</dict>
</plist>
ENDOFFILE
