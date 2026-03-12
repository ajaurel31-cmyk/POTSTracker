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
