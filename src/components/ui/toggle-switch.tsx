'use client';

import { cn } from '@/lib/utils';

interface ToggleSwitchProps {
  checked: boolean;
  onChange: (checked: boolean) => void;
  label: string;
  description?: string;
}

export function ToggleSwitch({ checked, onChange, label, description }: ToggleSwitchProps) {
  return (
    <button
      className="flex items-center justify-between w-full min-h-tap py-2 tap-highlight-none"
      onClick={() => onChange(!checked)}
      role="switch"
      aria-checked={checked}
      aria-label={label}
    >
      <div className="flex flex-col items-start">
        <span className="text-dynamic-base text-gray-900 dark:text-gray-100">{label}</span>
        {description && (
          <span className="text-dynamic-sm text-gray-500 dark:text-gray-400">{description}</span>
        )}
      </div>
      <div
        className={cn(
          'relative w-12 h-7 rounded-full transition-colors duration-200 flex-shrink-0 ml-3',
          checked ? 'bg-primary' : 'bg-gray-300 dark:bg-gray-600'
        )}
      >
        <div
          className={cn(
            'absolute top-0.5 w-6 h-6 rounded-full bg-white shadow-md transition-transform duration-200',
            checked ? 'translate-x-[22px]' : 'translate-x-0.5'
          )}
        />
      </div>
    </button>
  );
}
