#!/bin/bash
set -e

cat > ~/Desktop/POTSTracker/src/components/ui/collapsible-card.tsx << 'ENDOFFILE'
'use client';

import { useState, type ReactNode } from 'react';
import { ChevronDown, ChevronUp } from 'lucide-react';
import { cn } from '@/lib/utils';

interface CollapsibleCardProps {
  title: string;
  icon: ReactNode;
  children: ReactNode;
  defaultOpen?: boolean;
  className?: string;
}

export function CollapsibleCard({
  title,
  icon,
  children,
  defaultOpen = true,
  className,
}: CollapsibleCardProps) {
  const [isOpen, setIsOpen] = useState(defaultOpen);

  return (
    <div className={cn('card', className)}>
      <button
        className="card-header w-full tap-highlight-none"
        onClick={() => setIsOpen(!isOpen)}
        aria-expanded={isOpen}
        aria-label={`${title} section, ${isOpen ? 'collapse' : 'expand'}`}
      >
        <div className="flex items-center gap-2">
          <span className="text-primary" aria-hidden="true">{icon}</span>
          <h3 className="section-title">{title}</h3>
        </div>
        {isOpen ? (
          <ChevronUp className="w-5 h-5 text-gray-400" />
        ) : (
          <ChevronDown className="w-5 h-5 text-gray-400" />
        )}
      </button>
      {isOpen && <div className="card-body animate-fade-in">{children}</div>}
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/numeric-input.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/severity-slider.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/star-rating.tsx << 'ENDOFFILE'
'use client';

import { Star } from 'lucide-react';
import { cn } from '@/lib/utils';

interface StarRatingProps {
  value: number;
  onChange: (value: number) => void;
  max?: number;
  label?: string;
}

export function StarRating({ value, onChange, max = 5, label }: StarRatingProps) {
  return (
    <div className="flex flex-col gap-1">
      {label && (
        <span className="text-dynamic-sm text-gray-600 dark:text-gray-400 font-medium">
          {label}
        </span>
      )}
      <div className="flex gap-1" role="radiogroup" aria-label={label || 'Rating'}>
        {Array.from({ length: max }, (_, i) => i + 1).map((star) => (
          <button
            key={star}
            onClick={() => onChange(star)}
            className="min-w-tap min-h-tap flex items-center justify-center tap-highlight-none"
            role="radio"
            aria-checked={star === value}
            aria-label={`${star} star${star > 1 ? 's' : ''}`}
          >
            <Star
              className={cn(
                'w-8 h-8 transition-colors',
                star <= value
                  ? 'fill-warning text-warning'
                  : 'fill-none text-gray-300 dark:text-gray-600'
              )}
            />
          </button>
        ))}
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/chip-select.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/range-slider.tsx << 'ENDOFFILE'
'use client';

import { cn } from '@/lib/utils';

interface RangeSliderProps {
  value: number;
  onChange: (value: number) => void;
  min: number;
  max: number;
  step?: number;
  label: string;
  unit?: string;
  showValue?: boolean;
  className?: string;
}

export function RangeSlider({
  value,
  onChange,
  min,
  max,
  step = 1,
  label,
  unit,
  showValue = true,
  className,
}: RangeSliderProps) {
  const percentage = ((value - min) / (max - min)) * 100;

  return (
    <div className={cn('flex flex-col gap-2', className)}>
      <div className="flex justify-between items-center">
        <label className="text-dynamic-sm text-gray-600 dark:text-gray-400 font-medium">
          {label}
        </label>
        {showValue && (
          <span className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100">
            {value}
            {unit && <span className="text-dynamic-sm text-gray-500 ml-1">{unit}</span>}
          </span>
        )}
      </div>
      <input
        type="range"
        min={min}
        max={max}
        step={step}
        value={value}
        onChange={(e) => onChange(parseFloat(e.target.value))}
        className="w-full h-2 rounded-full appearance-none cursor-pointer
          [&::-webkit-slider-thumb]:appearance-none
          [&::-webkit-slider-thumb]:w-6
          [&::-webkit-slider-thumb]:h-6
          [&::-webkit-slider-thumb]:rounded-full
          [&::-webkit-slider-thumb]:bg-primary
          [&::-webkit-slider-thumb]:shadow-md
          [&::-webkit-slider-thumb]:cursor-pointer"
        style={{
          background: `linear-gradient(to right, #0D7377 0%, #0D7377 ${percentage}%, #d1d5db ${percentage}%, #d1d5db 100%)`,
        }}
        aria-label={label}
        aria-valuemin={min}
        aria-valuemax={max}
        aria-valuenow={value}
      />
      <div className="flex justify-between text-dynamic-xs text-gray-400">
        <span>{min}{unit}</span>
        <span>{max}{unit}</span>
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/toggle-switch.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/empty-state.tsx << 'ENDOFFILE'
'use client';

import { BarChart3 } from 'lucide-react';
import type { ReactNode } from 'react';

interface EmptyStateProps {
  icon?: ReactNode;
  title: string;
  description: string;
  action?: ReactNode;
}

export function EmptyState({ icon, title, description, action }: EmptyStateProps) {
  return (
    <div className="empty-state">
      <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center mb-4">
        {icon || <BarChart3 className="w-8 h-8 text-primary" />}
      </div>
      <h3 className="text-dynamic-lg font-semibold text-gray-900 dark:text-gray-100 mb-2">
        {title}
      </h3>
      <p className="text-dynamic-sm text-gray-500 dark:text-gray-400 max-w-xs">
        {description}
      </p>
      {action && <div className="mt-4">{action}</div>}
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/skeleton-loader.tsx << 'ENDOFFILE'
'use client';

import { cn } from '@/lib/utils';

interface SkeletonProps {
  className?: string;
}

export function Skeleton({ className }: SkeletonProps) {
  return <div className={cn('skeleton', className)} />;
}

export function ChartSkeleton() {
  return (
    <div className="card p-4 space-y-3">
      <Skeleton className="h-5 w-32" />
      <Skeleton className="h-48 w-full" />
      <div className="flex gap-2">
        <Skeleton className="h-4 w-16" />
        <Skeleton className="h-4 w-16" />
        <Skeleton className="h-4 w-16" />
      </div>
    </div>
  );
}

export function CardSkeleton() {
  return (
    <div className="card p-4 space-y-3">
      <Skeleton className="h-5 w-40" />
      <Skeleton className="h-4 w-full" />
      <Skeleton className="h-4 w-3/4" />
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/success-overlay.tsx << 'ENDOFFILE'
'use client';

import { Check } from 'lucide-react';

interface SuccessOverlayProps {
  show: boolean;
  message?: string;
}

export function SuccessOverlay({ show, message = 'Saved!' }: SuccessOverlayProps) {
  if (!show) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/30 animate-fade-in">
      <div className="bg-white dark:bg-card-dark rounded-2xl p-8 flex flex-col items-center shadow-xl animate-checkmark">
        <div className="w-16 h-16 rounded-full bg-success flex items-center justify-center mb-3">
          <Check className="w-10 h-10 text-white" strokeWidth={3} />
        </div>
        <span className="text-dynamic-lg font-semibold text-gray-900 dark:text-gray-100">
          {message}
        </span>
      </div>
    </div>
  );
}
ENDOFFILE
