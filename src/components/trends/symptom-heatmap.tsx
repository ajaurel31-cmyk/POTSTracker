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
