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
