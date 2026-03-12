import type { DailyLog, Insight } from '@/types';

export function generateInsights(logs: DailyLog[]): Insight[] {
  const insights: Insight[] = [];
  if (logs.length < 3) return insights;

  const last14 = logs.slice(-14);
  const last7 = logs.slice(-7);
  const last30 = logs.slice(-30);

  // 1. HR Delta analysis
  const hrDeltaLogs = last14.filter(
    (l) => l.hr_lying != null && l.hr_standing != null
  );
  if (hrDeltaLogs.length >= 3) {
    const exceeded = hrDeltaLogs.filter(
      (l) => (l.hr_standing! - l.hr_lying!) >= 30
    );
    if (exceeded.length > 0) {
      insights.push({
        id: 'hr-delta-freq',
        title: 'Orthostatic HR Pattern',
        description: `Your HR delta has exceeded 30 BPM on ${exceeded.length} of the last ${hrDeltaLogs.length} days.`,
        type: exceeded.length > hrDeltaLogs.length / 2 ? 'warning' : 'info',
        tip: 'Consider increasing fluid and salt intake. Compression garments may help. Talk to your doctor about adjusting medications if this is persistent.',
      });
    }
  }

  // 2. Sleep and symptoms correlation
  const withSleepAndRating = last14.filter(
    (l) => l.sleep_hours != null && l.overall_rating != null
  );
  if (withSleepAndRating.length >= 5) {
    const poorSleepDays = withSleepAndRating.filter((l) => (l.sleep_hours || 0) < 6);
    const goodSleepDays = withSleepAndRating.filter((l) => (l.sleep_hours || 0) >= 7);
    if (poorSleepDays.length >= 2 && goodSleepDays.length >= 2) {
      const avgPoorRating =
        poorSleepDays.reduce((sum, l) => sum + (l.overall_rating || 0), 0) / poorSleepDays.length;
      const avgGoodRating =
        goodSleepDays.reduce((sum, l) => sum + (l.overall_rating || 0), 0) / goodSleepDays.length;
      if (avgGoodRating - avgPoorRating > 1.5) {
        insights.push({
          id: 'sleep-correlation',
          title: 'Sleep Affects Your Days',
          description: `Your worst symptom days correlated with sleeping less than 6 hours. Days with 7+ hours averaged a ${avgGoodRating.toFixed(1)} rating vs ${avgPoorRating.toFixed(1)}.`,
          type: 'info',
          tip: 'Try to maintain a consistent sleep schedule. Elevate the head of your bed 4-6 inches. Avoid screens 1 hour before bed.',
        });
      }
    }
  }

  // 3. Hydration goal tracking
  const hydrationGoal = 64; // oz, can be customized later
  const withWater = last7.filter((l) => l.water_intake != null);
  if (withWater.length >= 3) {
    const metGoal = withWater.filter((l) => (l.water_intake || 0) >= hydrationGoal);
    insights.push({
      id: 'hydration-goal',
      title: 'Hydration Progress',
      description: `You've hit your hydration goal ${metGoal.length} of the last ${withWater.length} days.`,
      type: metGoal.length >= withWater.length * 0.7 ? 'positive' : 'warning',
      tip: 'Aim for 2-3 liters of water daily. Consider adding electrolyte packets. Set hourly hydration reminders.',
    });
  }

  // 4. Trigger pattern analysis
  const withRating = last30.filter(
    (l) => l.overall_rating != null && l.triggers && l.triggers.length > 0
  );
  if (withRating.length >= 5) {
    const worstDays = [...withRating]
      .sort((a, b) => (a.overall_rating || 0) - (b.overall_rating || 0))
      .slice(0, 5);
    const triggerCounts: Record<string, number> = {};
    worstDays.forEach((day) => {
      day.triggers?.forEach((t) => {
        triggerCounts[t] = (triggerCounts[t] || 0) + 1;
      });
    });
    const topTrigger = Object.entries(triggerCounts).sort(([, a], [, b]) => b - a)[0];
    if (topTrigger && topTrigger[1] >= 3) {
      insights.push({
        id: 'trigger-pattern',
        title: 'Trigger Alert',
        description: `"${topTrigger[0]}" was logged as a trigger on ${topTrigger[1]} of your ${worstDays.length} worst days this month.`,
        type: 'warning',
        tip: `Try to minimize exposure to "${topTrigger[0]}" when possible. Track this trigger closely and discuss patterns with your doctor.`,
      });
    }
  }

  // 5. Symptom trend (improving or worsening)
  if (last14.length >= 7) {
    const firstHalf = last14.slice(0, 7);
    const secondHalf = last14.slice(7);

    const avgFirst =
      firstHalf.reduce((sum, l) => {
        const symptomAvg =
          l.symptoms && l.symptoms.length > 0
            ? l.symptoms.reduce((s, sym) => s + sym.severity, 0) / l.symptoms.length
            : 0;
        return sum + symptomAvg;
      }, 0) / firstHalf.length;

    const avgSecond =
      secondHalf.reduce((sum, l) => {
        const symptomAvg =
          l.symptoms && l.symptoms.length > 0
            ? l.symptoms.reduce((s, sym) => s + sym.severity, 0) / l.symptoms.length
            : 0;
        return sum + symptomAvg;
      }, 0) / secondHalf.length;

    if (avgFirst - avgSecond > 0.5) {
      insights.push({
        id: 'symptom-trend-down',
        title: 'Symptoms Improving',
        description: 'Your symptom severity is trending downward over the past 2 weeks.',
        type: 'positive',
        tip: 'Keep up what you\'re doing! Note any changes in routine, medications, or habits that may be helping.',
      });
    } else if (avgSecond - avgFirst > 0.5) {
      insights.push({
        id: 'symptom-trend-up',
        title: 'Symptoms Increasing',
        description: 'Your symptom severity has been trending upward over the past 2 weeks.',
        type: 'negative',
        tip: 'Consider scheduling a check-in with your doctor. Review any changes in medication, sleep, or stress levels.',
      });
    }
  }

  // 6. Activity impact
  const withActivity = last14.filter(
    (l) => l.activity_level != null && l.overall_rating != null
  );
  if (withActivity.length >= 5) {
    const restDays = withActivity.filter(
      (l) => l.activity_level === 'Bedbound' || l.activity_level === 'Mostly Resting'
    );
    const activeDays = withActivity.filter(
      (l) => l.activity_level === 'Light Activity' || l.activity_level === 'Moderate' || l.activity_level === 'Active'
    );
    if (restDays.length >= 2 && activeDays.length >= 2) {
      const avgRestRating =
        restDays.reduce((s, l) => s + (l.overall_rating || 0), 0) / restDays.length;
      const avgActiveRating =
        activeDays.reduce((s, l) => s + (l.overall_rating || 0), 0) / activeDays.length;
      if (avgActiveRating > avgRestRating + 1) {
        insights.push({
          id: 'activity-helps',
          title: 'Movement Helps',
          description: `Active days averaged a ${avgActiveRating.toFixed(1)} rating vs ${avgRestRating.toFixed(1)} on rest days.`,
          type: 'positive',
          tip: 'Gentle, recumbent exercise (like recumbent biking or swimming) is often well-tolerated with POTS. Start slow and gradually increase.',
        });
      }
    }
  }

  return insights;
}

// Generate a doctor visit summary
export function generateDoctorSummary(logs: DailyLog[], days: number): string {
  if (logs.length === 0) return 'No data available for this period.';

  const lines: string[] = [];
  lines.push(`POTSTracker - Doctor Visit Summary`);
  lines.push(`Period: Last ${days} days (${logs.length} entries)`);
  lines.push(`Generated: ${new Date().toLocaleDateString()}`);
  lines.push('');

  // HR summary
  const hrLogs = logs.filter((l) => l.hr_lying != null && l.hr_standing != null);
  if (hrLogs.length > 0) {
    const avgLying = Math.round(
      hrLogs.reduce((s, l) => s + (l.hr_lying || 0), 0) / hrLogs.length
    );
    const avgStanding = Math.round(
      hrLogs.reduce((s, l) => s + (l.hr_standing || 0), 0) / hrLogs.length
    );
    const avgDelta = avgStanding - avgLying;
    const daysOver30 = hrLogs.filter(
      (l) => (l.hr_standing! - l.hr_lying!) >= 30
    ).length;

    lines.push('HEART RATE');
    lines.push(`  Average Lying HR: ${avgLying} BPM`);
    lines.push(`  Average Standing HR: ${avgStanding} BPM`);
    lines.push(`  Average Orthostatic Delta: +${avgDelta} BPM`);
    lines.push(`  Days with delta ≥30 BPM: ${daysOver30}/${hrLogs.length}`);
    lines.push('');
  }

  // BP summary
  const bpLogs = logs.filter((l) => l.bp_lying_sys != null && l.bp_standing_sys != null);
  if (bpLogs.length > 0) {
    const avgLyingSys = Math.round(
      bpLogs.reduce((s, l) => s + (l.bp_lying_sys || 0), 0) / bpLogs.length
    );
    const avgLyingDia = Math.round(
      bpLogs.reduce((s, l) => s + (l.bp_lying_dia || 0), 0) / bpLogs.length
    );
    const avgStandSys = Math.round(
      bpLogs.reduce((s, l) => s + (l.bp_standing_sys || 0), 0) / bpLogs.length
    );
    const avgStandDia = Math.round(
      bpLogs.reduce((s, l) => s + (l.bp_standing_dia || 0), 0) / bpLogs.length
    );

    lines.push('BLOOD PRESSURE');
    lines.push(`  Average Lying: ${avgLyingSys}/${avgLyingDia} mmHg`);
    lines.push(`  Average Standing: ${avgStandSys}/${avgStandDia} mmHg`);
    lines.push('');
  }

  // Top symptoms
  const symptomCounts: Record<string, { count: number; totalSeverity: number }> = {};
  logs.forEach((l) => {
    l.symptoms?.forEach((s) => {
      if (!symptomCounts[s.name]) symptomCounts[s.name] = { count: 0, totalSeverity: 0 };
      symptomCounts[s.name].count++;
      symptomCounts[s.name].totalSeverity += s.severity;
    });
  });
  const topSymptoms = Object.entries(symptomCounts)
    .sort(([, a], [, b]) => b.count - a.count)
    .slice(0, 10);

  if (topSymptoms.length > 0) {
    lines.push('TOP SYMPTOMS');
    topSymptoms.forEach(([name, data]) => {
      const avgSev = (data.totalSeverity / data.count).toFixed(1);
      lines.push(`  ${name}: ${data.count} days, avg severity ${avgSev}/5`);
    });
    lines.push('');
  }

  // Triggers
  const triggerCounts: Record<string, number> = {};
  logs.forEach((l) => {
    l.triggers?.forEach((t) => {
      triggerCounts[t] = (triggerCounts[t] || 0) + 1;
    });
  });
  const topTriggers = Object.entries(triggerCounts)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 5);

  if (topTriggers.length > 0) {
    lines.push('TOP TRIGGERS');
    topTriggers.forEach(([name, count]) => {
      lines.push(`  ${name}: ${count} days`);
    });
    lines.push('');
  }

  // Overall ratings
  const rated = logs.filter((l) => l.overall_rating != null);
  if (rated.length > 0) {
    const avgRating =
      rated.reduce((s, l) => s + (l.overall_rating || 0), 0) / rated.length;
    const worst = Math.min(...rated.map((l) => l.overall_rating || 10));
    const best = Math.max(...rated.map((l) => l.overall_rating || 0));
    lines.push('OVERALL WELLBEING');
    lines.push(`  Average Day Rating: ${avgRating.toFixed(1)}/10`);
    lines.push(`  Best Day: ${best}/10`);
    lines.push(`  Worst Day: ${worst}/10`);
    lines.push('');
  }

  // Sleep
  const sleepLogs = logs.filter((l) => l.sleep_hours != null);
  if (sleepLogs.length > 0) {
    const avgSleep =
      sleepLogs.reduce((s, l) => s + (l.sleep_hours || 0), 0) / sleepLogs.length;
    const unrefreshed = sleepLogs.filter((l) => l.unrefreshed).length;
    lines.push('SLEEP');
    lines.push(`  Average: ${avgSleep.toFixed(1)} hours`);
    lines.push(`  Woke unrefreshed: ${unrefreshed}/${sleepLogs.length} days`);
    lines.push('');
  }

  lines.push('---');
  lines.push('Generated by POTSTracker – Dysautonomia Diary');

  return lines.join('\n');
}
