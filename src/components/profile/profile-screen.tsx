'use client';

import { useState } from 'react';
import {
  User, Pill, AlertCircle, Bell, Ruler, Database,
  Shield, Info, ChevronRight, Trash2, Download,
  FileText, Cloud, Star, ExternalLink, Plus, X,
} from 'lucide-react';
import { useAppStore } from '@/stores/app-store';
import { ToggleSwitch } from '@/components/ui/toggle-switch';
import { exportAllDataAsCSV, clearAllData } from '@/lib/database';
import { DIAGNOSIS_TYPES, type DiagnosisType, type Medication } from '@/types';
import { cn } from '@/lib/utils';

export function ProfileScreen() {
  const { profile, updateProfile } = useAppStore();
  const [showClearConfirm, setShowClearConfirm] = useState(false);
  const [editingMed, setEditingMed] = useState(false);
  const [newMedName, setNewMedName] = useState('');
  const [newMedDosage, setNewMedDosage] = useState('');
  const [newCustomSymptom, setNewCustomSymptom] = useState('');
  const [showAddSymptom, setShowAddSymptom] = useState(false);

  const handleExportCSV = async () => {
    const csv = await exportAllDataAsCSV();
    if (!csv) return;
    // Create blob and download
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `POTSTracker_Export_${new Date().toISOString().split('T')[0]}.csv`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  const handleClearData = async () => {
    await clearAllData();
    setShowClearConfirm(false);
    window.location.reload();
  };

  const addMedication = () => {
    if (!newMedName.trim()) return;
    const med: Medication = {
      id: crypto.randomUUID?.() || Math.random().toString(36).slice(2),
      name: newMedName.trim(),
      dosage: newMedDosage.trim(),
      time_of_day: 'morning',
      reminder_enabled: false,
    };
    updateProfile({
      medications: [...(profile?.medications || []), med],
    });
    setNewMedName('');
    setNewMedDosage('');
    setEditingMed(false);
  };

  const removeMedication = (id: string) => {
    updateProfile({
      medications: (profile?.medications || []).filter((m) => m.id !== id),
    });
  };

  const addCustomSymptom = () => {
    if (!newCustomSymptom.trim()) return;
    updateProfile({
      custom_symptoms: [...(profile?.custom_symptoms || []), newCustomSymptom.trim()],
    });
    setNewCustomSymptom('');
    setShowAddSymptom(false);
  };

  const removeCustomSymptom = (symptom: string) => {
    updateProfile({
      custom_symptoms: (profile?.custom_symptoms || []).filter((s) => s !== symptom),
    });
  };

  return (
    <div className="pb-24">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-bg-light dark:bg-bg-dark px-4 py-3 border-b border-gray-100 dark:border-gray-800">
        <h1 className="text-dynamic-xl font-bold text-gray-900 dark:text-gray-100">
          Profile & Settings
        </h1>
      </div>

      <div className="px-4 py-3 space-y-4">
        {/* Personal Info */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <User className="w-5 h-5 text-primary" />
            <h3 className="section-title">Personal Info</h3>
          </div>
          <div className="space-y-3">
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Name</label>
              <input
                type="text"
                value={profile?.name || ''}
                onChange={(e) => updateProfile({ name: e.target.value })}
                className="input-field"
                placeholder="Your name"
                aria-label="Name"
              />
            </div>
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Date of Birth</label>
              <input
                type="date"
                value={profile?.dob || ''}
                onChange={(e) => updateProfile({ dob: e.target.value })}
                className="input-field"
                aria-label="Date of birth"
              />
            </div>
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Diagnosis</label>
              <select
                value={profile?.diagnosis_type || 'Undiagnosed'}
                onChange={(e) =>
                  updateProfile({ diagnosis_type: e.target.value as DiagnosisType })
                }
                className="input-field"
                aria-label="Diagnosis type"
              >
                {DIAGNOSIS_TYPES.map((d) => (
                  <option key={d} value={d}>{d}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Gender</label>
              <select
                value={profile?.gender || 'prefer-not-to-say'}
                onChange={(e) =>
                  updateProfile({ gender: e.target.value as Profile['gender'] })
                }
                className="input-field"
                aria-label="Gender"
              >
                <option value="female">Female</option>
                <option value="male">Male</option>
                <option value="non-binary">Non-Binary</option>
                <option value="prefer-not-to-say">Prefer not to say</option>
              </select>
            </div>
          </div>
        </div>

        {/* Medications */}
        <div className="card p-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <Pill className="w-5 h-5 text-primary" />
              <h3 className="section-title">Medications</h3>
            </div>
            <button
              onClick={() => setEditingMed(true)}
              className="text-primary text-dynamic-sm font-medium min-h-tap flex items-center gap-1"
              aria-label="Add medication"
            >
              <Plus className="w-4 h-4" /> Add
            </button>
          </div>

          {(profile?.medications || []).length === 0 && !editingMed && (
            <p className="text-dynamic-sm text-gray-500">No medications added.</p>
          )}

          {(profile?.medications || []).map((med) => (
            <div
              key={med.id}
              className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700 last:border-0"
            >
              <div>
                <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                  {med.name}
                </span>
                {med.dosage && (
                  <span className="text-dynamic-sm text-gray-500 ml-2">{med.dosage}</span>
                )}
              </div>
              <button
                onClick={() => removeMedication(med.id)}
                className="min-h-tap min-w-tap flex items-center justify-center text-danger"
                aria-label={`Remove ${med.name}`}
              >
                <X className="w-4 h-4" />
              </button>
            </div>
          ))}

          {editingMed && (
            <div className="space-y-2 mt-3 pt-3 border-t border-gray-100 dark:border-gray-700">
              <input
                type="text"
                value={newMedName}
                onChange={(e) => setNewMedName(e.target.value)}
                placeholder="Medication name"
                className="input-field"
                aria-label="New medication name"
                autoFocus
              />
              <input
                type="text"
                value={newMedDosage}
                onChange={(e) => setNewMedDosage(e.target.value)}
                placeholder="Dosage (e.g., 10mg)"
                className="input-field"
                aria-label="Medication dosage"
              />
              <div className="flex gap-2">
                <button onClick={addMedication} className="btn-primary flex-1 text-dynamic-sm">
                  Save
                </button>
                <button
                  onClick={() => setEditingMed(false)}
                  className="btn-secondary flex-1 text-dynamic-sm"
                >
                  Cancel
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Custom Symptoms */}
        <div className="card p-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <AlertCircle className="w-5 h-5 text-primary" />
              <h3 className="section-title">Custom Symptoms</h3>
            </div>
            <button
              onClick={() => setShowAddSymptom(true)}
              className="text-primary text-dynamic-sm font-medium min-h-tap flex items-center gap-1"
              aria-label="Add custom symptom"
            >
              <Plus className="w-4 h-4" /> Add
            </button>
          </div>

          {(profile?.custom_symptoms || []).length === 0 && !showAddSymptom && (
            <p className="text-dynamic-sm text-gray-500">No custom symptoms added.</p>
          )}

          <div className="flex flex-wrap gap-2">
            {(profile?.custom_symptoms || []).map((symptom) => (
              <span
                key={symptom}
                className="inline-flex items-center gap-1 px-3 py-1.5 rounded-full bg-gray-100 dark:bg-gray-800 text-dynamic-sm"
              >
                {symptom}
                <button
                  onClick={() => removeCustomSymptom(symptom)}
                  className="text-gray-400 hover:text-danger min-w-tap min-h-[28px] flex items-center"
                  aria-label={`Remove ${symptom}`}
                >
                  <X className="w-3 h-3" />
                </button>
              </span>
            ))}
          </div>

          {showAddSymptom && (
            <div className="flex gap-2 mt-3">
              <input
                type="text"
                value={newCustomSymptom}
                onChange={(e) => setNewCustomSymptom(e.target.value)}
                placeholder="Symptom name"
                className="input-field flex-1"
                onKeyDown={(e) => e.key === 'Enter' && addCustomSymptom()}
                aria-label="New custom symptom"
                autoFocus
              />
              <button onClick={addCustomSymptom} className="btn-primary px-4 text-dynamic-sm">
                Add
              </button>
            </div>
          )}
        </div>

        {/* Notifications */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Bell className="w-5 h-5 text-primary" />
            <h3 className="section-title">Notifications</h3>
          </div>
          <div className="space-y-1">
            <ToggleSwitch
              checked={!!profile?.notification_log_time}
              onChange={(v) =>
                updateProfile({ notification_log_time: v ? '20:00' : undefined })
              }
              label="Daily Log Reminder"
              description="Reminds you to log your vitals"
            />
            {profile?.notification_log_time && (
              <div className="pl-4 py-1">
                <label className="text-dynamic-xs text-gray-500 block mb-1">Reminder Time</label>
                <input
                  type="time"
                  value={profile.notification_log_time}
                  onChange={(e) => updateProfile({ notification_log_time: e.target.value })}
                  className="input-field w-40"
                  aria-label="Daily log reminder time"
                />
              </div>
            )}
            <ToggleSwitch
              checked={!!profile?.notification_hydration_interval}
              onChange={(v) =>
                updateProfile({ notification_hydration_interval: v ? 2 : undefined })
              }
              label="Hydration Reminders"
              description="Every 2 hours during the day"
            />
          </div>
        </div>

        {/* Units */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Ruler className="w-5 h-5 text-primary" />
            <h3 className="section-title">Units</h3>
          </div>
          <div className="flex gap-2">
            {(['imperial', 'metric'] as const).map((unit) => (
              <button
                key={unit}
                onClick={() => updateProfile({ units: unit })}
                className={cn(
                  'flex-1 py-3 rounded-xl text-dynamic-base font-medium min-h-tap transition-all border',
                  profile?.units === unit
                    ? 'bg-primary text-white border-primary'
                    : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
                )}
                aria-pressed={profile?.units === unit}
              >
                {unit === 'imperial' ? 'Imperial (oz, lbs)' : 'Metric (mL, kg)'}
              </button>
            ))}
          </div>
        </div>

        {/* Data Management */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Database className="w-5 h-5 text-primary" />
            <h3 className="section-title">Data Management</h3>
          </div>
          <div className="space-y-2">
            <button
              onClick={handleExportCSV}
              className="flex items-center justify-between w-full py-3 min-h-tap"
              aria-label="Export data as CSV"
            >
              <div className="flex items-center gap-3">
                <Download className="w-5 h-5 text-gray-500" />
                <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                  Export All Data (CSV)
                </span>
              </div>
              <ChevronRight className="w-5 h-5 text-gray-400" />
            </button>

            <button
              className="flex items-center justify-between w-full py-3 min-h-tap"
              aria-label="Export PDF summary report"
            >
              <div className="flex items-center gap-3">
                <FileText className="w-5 h-5 text-gray-500" />
                <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                  Export PDF Report
                </span>
              </div>
              <ChevronRight className="w-5 h-5 text-gray-400" />
            </button>

            <div className="flex items-center justify-between w-full py-3 min-h-tap opacity-60">
              <div className="flex items-center gap-3">
                <Cloud className="w-5 h-5 text-gray-500" />
                <div>
                  <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                    iCloud Backup
                  </span>
                  <span className="badge-warning ml-2">Coming Soon</span>
                </div>
              </div>
            </div>

            <button
              onClick={() => setShowClearConfirm(true)}
              className="flex items-center gap-3 w-full py-3 min-h-tap text-danger"
              aria-label="Clear all data"
            >
              <Trash2 className="w-5 h-5" />
              <span className="text-dynamic-base font-medium">Clear All Data</span>
            </button>
          </div>
        </div>

        {/* Clear data confirmation */}
        {showClearConfirm && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-6">
            <div className="bg-white dark:bg-card-dark rounded-2xl p-6 max-w-sm w-full animate-fade-in">
              <h3 className="text-dynamic-lg font-bold text-danger mb-2">
                Delete All Data?
              </h3>
              <p className="text-dynamic-sm text-gray-600 dark:text-gray-400 mb-4">
                This will permanently delete all your logs, profile data, and settings.
                This action cannot be undone.
              </p>
              <div className="flex gap-3">
                <button
                  onClick={() => setShowClearConfirm(false)}
                  className="btn-secondary flex-1"
                >
                  Cancel
                </button>
                <button onClick={handleClearData} className="btn-danger flex-1">
                  Delete Everything
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Security */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Shield className="w-5 h-5 text-primary" />
            <h3 className="section-title">Security</h3>
          </div>
          <ToggleSwitch
            checked={!!profile?.biometric_enabled}
            onChange={(v) => updateProfile({ biometric_enabled: v })}
            label="Face ID / Touch ID"
            description="Protect your health data with biometrics"
          />
        </div>

        {/* About */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Info className="w-5 h-5 text-primary" />
            <h3 className="section-title">About</h3>
          </div>
          <div className="space-y-2">
            <div className="flex items-center justify-between py-2">
              <span className="text-dynamic-base text-gray-600 dark:text-gray-400">Version</span>
              <span className="text-dynamic-base text-gray-900 dark:text-gray-100">1.0.0</span>
            </div>
            <button className="flex items-center justify-between w-full py-2 min-h-tap">
              <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                Privacy Policy
              </span>
              <ExternalLink className="w-4 h-4 text-gray-400" />
            </button>
            <button className="flex items-center justify-between w-full py-2 min-h-tap">
              <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                Terms of Use
              </span>
              <ExternalLink className="w-4 h-4 text-gray-400" />
            </button>
            <button
              className="flex items-center gap-2 w-full py-2 min-h-tap text-primary font-medium"
              aria-label="Rate the app"
            >
              <Star className="w-5 h-5" />
              <span className="text-dynamic-base">Rate POTSTracker</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
