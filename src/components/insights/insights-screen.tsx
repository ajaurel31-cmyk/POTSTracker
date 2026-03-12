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
