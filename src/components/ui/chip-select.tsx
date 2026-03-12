'use client';

import { cn } from '@/lib/utils';

interface ChipSelectProps {
  options: string[];
  selected: string[];
  onChange: (selected: string[]) => void;
  multiSelect?: boolean;
  label?: string;
}

export function ChipSelect({
  options,
  selected,
  onChange,
  multiSelect = true,
  label,
}: ChipSelectProps) {
  const toggle = (option: string) => {
    if (multiSelect) {
      if (selected.includes(option)) {
        onChange(selected.filter((s) => s !== option));
      } else {
        onChange([...selected, option]);
      }
    } else {
      onChange([option]);
    }
  };

  return (
    <div className="flex flex-col gap-2">
      {label && (
        <span className="text-dynamic-sm text-gray-600 dark:text-gray-400 font-medium">
          {label}
        </span>
      )}
      <div className="flex flex-wrap gap-2" role="group" aria-label={label || 'Select options'}>
        {options.map((option) => {
          const isSelected = selected.includes(option);
          return (
            <button
              key={option}
              onClick={() => toggle(option)}
              className={cn(
                'px-3 py-2 rounded-full text-dynamic-sm font-medium',
                'min-h-tap transition-all tap-highlight-none',
                'border',
                isSelected
                  ? 'bg-primary text-white border-primary'
                  : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
              )}
              role={multiSelect ? 'checkbox' : 'radio'}
              aria-checked={isSelected}
              aria-label={option}
            >
              {option}
            </button>
          );
        })}
      </div>
    </div>
  );
}
