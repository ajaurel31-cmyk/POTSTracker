import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function formatDate(date: Date | string): string {
  const d = typeof date === 'string' ? new Date(date) : date;
  return d.toLocaleDateString('en-US', {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
}

export function formatDateShort(date: Date | string): string {
  const d = typeof date === 'string' ? new Date(date) : date;
  return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
}

export function getToday(): string {
  return new Date().toISOString().split('T')[0];
}

export function getDateNDaysAgo(n: number): string {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().split('T')[0];
}

export function calculateHRDelta(lying?: number, standing?: number): number | null {
  if (lying == null || standing == null) return null;
  return standing - lying;
}

export function checkOrthostatic(
  lying?: number,
  standing?: number,
  ageUnder19?: boolean
): { met: boolean; delta: number | null; threshold: number } {
  const threshold = ageUnder19 ? 40 : 30;
  const delta = calculateHRDelta(lying, standing);
  return {
    met: delta !== null && delta >= threshold,
    delta,
    threshold,
  };
}

export function checkOrthostaticHypotension(
  lyingSys?: number,
  lyingDia?: number,
  standingSys?: number,
  standingDia?: number
): { met: boolean; sysDrop: number | null; diaDrop: number | null } {
  if (!lyingSys || !standingSys || !lyingDia || !standingDia) {
    return { met: false, sysDrop: null, diaDrop: null };
  }
  const sysDrop = lyingSys - standingSys;
  const diaDrop = lyingDia - standingDia;
  return {
    met: sysDrop >= 20 || diaDrop >= 10,
    sysDrop,
    diaDrop,
  };
}

export function calculateSodiumFromGrams(grams: number): number {
  return Math.round(grams * 393);
}

export function ozToMl(oz: number): number {
  return Math.round(oz * 29.5735);
}

export function mlToOz(ml: number): number {
  return Math.round(ml / 29.5735 * 10) / 10;
}

export function getEmojiForRating(rating: number): string {
  if (rating <= 2) return '😫';
  if (rating <= 4) return '😔';
  if (rating <= 6) return '😐';
  if (rating <= 8) return '🙂';
  return '😊';
}

export function getAgeFromDob(dob: string): number {
  const birth = new Date(dob);
  const today = new Date();
  let age = today.getFullYear() - birth.getFullYear();
  const m = today.getMonth() - birth.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) {
    age--;
  }
  return age;
}

export function debounce<T extends (...args: unknown[]) => unknown>(
  fn: T,
  delay: number
): (...args: Parameters<T>) => void {
  let timer: NodeJS.Timeout;
  return (...args: Parameters<T>) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  };
}
