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
