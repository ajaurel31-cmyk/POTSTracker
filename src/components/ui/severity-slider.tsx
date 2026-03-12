'use client';

import { cn } from '@/lib/utils';

interface SeveritySliderProps {
  value: number;
  onChange: (value: number) => void;
  label: string;
  min?: number;
  max?: number;
}

const severityColors = [
  'bg-green-400',
  'bg-yellow-300',
  'bg-yellow-500',
  'bg-orange-500',
  'bg-red-500',
];

const severityLabels = ['Mild', 'Light', 'Moderate', 'Severe', 'Extreme'];

export function SeveritySlider({
  value,
  onChange,
  label,
  min = 1,
  max = 5,
}: SeveritySliderProps) {
  return (
    <div className="flex flex-col gap-1.5">
      <div className="flex justify-between items-center">
        <span className="text-dynamic-sm text-gray-700 dark:text-gray-300 truncate mr-2">
          {label}
        </span>
        <span className={cn(
          'text-dynamic-xs font-medium px-2 py-0.5 rounded-full text-white',
          severityColors[value - 1]
        )}>
          {severityLabels[value - 1]}
        </span>
      </div>
      <div className="flex gap-1.5">
        {Array.from({ length: max - min + 1 }, (_, i) => i + min).map((level) => (
          <button
            key={level}
            onClick={() => onChange(level)}
            className={cn(
              'flex-1 h-8 rounded-lg transition-all min-w-tap min-h-[32px]',
              level <= value
                ? severityColors[level - 1]
                : 'bg-gray-200 dark:bg-gray-700'
            )}
            aria-label={`Set ${label} severity to ${level}: ${severityLabels[level - 1]}`}
          />
        ))}
      </div>
    </div>
  );
}
