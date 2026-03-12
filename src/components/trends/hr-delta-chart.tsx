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
