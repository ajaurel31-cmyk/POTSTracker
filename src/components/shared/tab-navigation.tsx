'use client';

import { ClipboardList, TrendingUp, Lightbulb, User } from 'lucide-react';
import { useAppStore } from '@/stores/app-store';
import { cn } from '@/lib/utils';

const tabs = [
  { id: 'log' as const, label: 'Log Today', icon: ClipboardList },
  { id: 'trends' as const, label: 'Trends', icon: TrendingUp },
  { id: 'insights' as const, label: 'Insights', icon: Lightbulb },
  { id: 'profile' as const, label: 'Profile', icon: User },
];

export function TabNavigation() {
  const { activeTab, setActiveTab } = useAppStore();

  return (
    <nav className="tab-bar" role="tablist" aria-label="Main navigation">
      {tabs.map(({ id, label, icon: Icon }) => (
        <button
          key={id}
          onClick={() => setActiveTab(id)}
          className={cn('tab-item', activeTab === id && 'tab-item-active')}
          role="tab"
          aria-selected={activeTab === id}
          aria-label={label}
        >
          <Icon className="w-6 h-6" />
          <span className="text-[10px] mt-0.5 font-medium">{label}</span>
        </button>
      ))}
    </nav>
  );
}
