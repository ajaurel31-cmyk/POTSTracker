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
