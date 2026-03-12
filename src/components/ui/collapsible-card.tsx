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
