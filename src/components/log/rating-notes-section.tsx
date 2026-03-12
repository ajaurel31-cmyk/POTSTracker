'use client';

import { Smile, StickyNote } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { RangeSlider } from '@/components/ui/range-slider';
import { useLogStore } from '@/stores/log-store';
import { getEmojiForRating } from '@/lib/utils';

export function RatingNotesSection() {
  const { currentLog, setOverallRating, setNotes } = useLogStore();

  return (
    <>
      <CollapsibleCard title="Overall Day Rating" icon={<Smile className="w-5 h-5" />}>
        <div className="space-y-2">
          <div className="flex items-center justify-center">
            <span className="text-4xl mr-3" role="img" aria-hidden="true">
              {getEmojiForRating(currentLog.overall_rating || 5)}
            </span>
            <span className="text-dynamic-3xl font-bold text-gray-900 dark:text-gray-100">
              {currentLog.overall_rating || 5}/10
            </span>
          </div>
          <RangeSlider
            label=""
            value={currentLog.overall_rating || 5}
            onChange={setOverallRating}
            min={1}
            max={10}
            showValue={false}
          />
          <div className="flex justify-between text-dynamic-xs text-gray-400">
            <span>Terrible</span>
            <span>Great</span>
          </div>
        </div>
      </CollapsibleCard>

      <CollapsibleCard title="Notes" icon={<StickyNote className="w-5 h-5" />} defaultOpen={false}>
        <div>
          <textarea
            value={currentLog.notes || ''}
            onChange={(e) => {
              if (e.target.value.length <= 500) {
                setNotes(e.target.value);
              }
            }}
            placeholder="Any additional notes about today..."
            className="input-field min-h-[100px] resize-none"
            aria-label="Daily notes"
            maxLength={500}
          />
          <p className="text-dynamic-xs text-gray-400 mt-1 text-right">
            {(currentLog.notes || '').length}/500
          </p>
        </div>
      </CollapsibleCard>
    </>
  );
}
