'use client';

import { useState } from 'react';
import { Zap, Plus } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { useLogStore } from '@/stores/log-store';
import { useAppStore } from '@/stores/app-store';
import { DEFAULT_TRIGGERS } from '@/types';
import { cn } from '@/lib/utils';

export function TriggersSection() {
  const { currentLog, toggleTrigger } = useLogStore();
  const profile = useAppStore((s) => s.profile);
  const [customTrigger, setCustomTrigger] = useState('');
  const [showCustom, setShowCustom] = useState(false);

  const allTriggers = [
    ...DEFAULT_TRIGGERS,
    ...(profile?.custom_triggers || []),
  ];

  const addCustomTrigger = () => {
    if (customTrigger.trim()) {
      toggleTrigger(customTrigger.trim());
      setCustomTrigger('');
      setShowCustom(false);
    }
  };

  return (
    <CollapsibleCard title="Triggers Today" icon={<Zap className="w-5 h-5" />}>
      <div className="space-y-3">
        <div className="flex flex-wrap gap-2">
          {allTriggers.map((trigger) => {
            const isSelected = currentLog.triggers.includes(trigger);
            return (
              <button
                key={trigger}
                onClick={() => toggleTrigger(trigger)}
                className={cn(
                  'px-3 py-2 rounded-full text-dynamic-sm font-medium min-h-tap border transition-all',
                  isSelected
                    ? 'bg-warning/20 text-yellow-800 dark:text-yellow-200 border-warning'
                    : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
                )}
                role="checkbox"
                aria-checked={isSelected}
                aria-label={`Trigger: ${trigger}`}
              >
                {trigger}
              </button>
            );
          })}
          <button
            onClick={() => setShowCustom(true)}
            className="px-3 py-2 rounded-full text-dynamic-sm font-medium min-h-tap
              border border-dashed border-gray-300 dark:border-gray-600
              text-gray-500 flex items-center gap-1"
            aria-label="Add custom trigger"
          >
            <Plus className="w-4 h-4" />
            Custom
          </button>
        </div>

        {showCustom && (
          <div className="flex gap-2">
            <input
              type="text"
              value={customTrigger}
              onChange={(e) => setCustomTrigger(e.target.value)}
              placeholder="Enter custom trigger"
              className="input-field flex-1"
              onKeyDown={(e) => e.key === 'Enter' && addCustomTrigger()}
              aria-label="Custom trigger name"
              autoFocus
            />
            <button onClick={addCustomTrigger} className="btn-primary px-4" aria-label="Add trigger">
              Add
            </button>
          </div>
        )}
      </div>
    </CollapsibleCard>
  );
}
