'use client';

import { cn } from '@/lib/utils';

interface NumericInputProps {
  label: string;
  value?: number;
  onChange: (value?: number) => void;
  unit?: string;
  min?: number;
  max?: number;
  placeholder?: string;
  className?: string;
  accessibilityLabel?: string;
}

export function NumericInput({
  label,
  value,
  onChange,
  unit,
  min = 0,
  max = 999,
  placeholder,
  className,
  accessibilityLabel,
}: NumericInputProps) {
  return (
    <div className={cn('flex flex-col gap-1', className)}>
      <label className="text-dynamic-sm text-gray-600 dark:text-gray-400 font-medium">
        {label}
      </label>
      <div className="relative">
        <input
          type="number"
          inputMode="numeric"
          pattern="[0-9]*"
          value={value ?? ''}
          onChange={(e) => {
            const v = e.target.value;
            if (v === '') {
              onChange(undefined);
            } else {
              const num = parseInt(v, 10);
              if (!isNaN(num) && num >= min && num <= max) {
                onChange(num);
              }
            }
          }}
          placeholder={placeholder || label}
          className="input-field pr-12"
          aria-label={accessibilityLabel || label}
          min={min}
          max={max}
        />
        {unit && (
          <span className="absolute right-3 top-1/2 -translate-y-1/2 text-dynamic-sm text-gray-400">
            {unit}
          </span>
        )}
      </div>
    </div>
  );
}
