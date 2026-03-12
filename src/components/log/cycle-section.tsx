'use client';

import { Calendar } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { useLogStore } from '@/stores/log-store';
import { cn } from '@/lib/utils';
import type { CyclePhase } from '@/types';

const phases: { value: CyclePhase; label: string }[] = [
  { value: 'on-period', label: 'On Period' },
  { value: 'pre-period', label: 'Pre-Period' },
  { value: 'mid-cycle', label: 'Mid-Cycle' },
  { value: 'post-period', label: 'Post-Period' },
];

export function CycleSection() {
  const { currentLog, setCyclePhase } = useLogStore();

  return (
    <CollapsibleCard
      title="Menstrual Cycle"
      icon={<Calendar className="w-5 h-5" />}
      defaultOpen={false}
    >
      <div className="flex flex-wrap gap-2">
        {phases.map(({ value, label }) => (
          <button
            key={value}
            onClick={() =>
              setCyclePhase(currentLog.cycle_phase === value ? undefined : value)
            }
            className={cn(
              'px-4 py-2 rounded-xl text-dynamic-sm font-medium min-h-tap border transition-all',
              currentLog.cycle_phase === value
                ? 'bg-accent/20 text-accent border-accent'
                : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
            )}
            role="radio"
            aria-checked={currentLog.cycle_phase === value}
            aria-label={`Cycle phase: ${label}`}
          >
            {label}
          </button>
        ))}
      </div>
    </CollapsibleCard>
  );
}
