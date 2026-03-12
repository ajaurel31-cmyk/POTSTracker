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
