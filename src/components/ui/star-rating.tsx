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
