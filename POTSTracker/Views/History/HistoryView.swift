import SwiftUI

struct HistoryView: View {
    @State private var logs: [DailyLog] = []
    @State private var selectedRange = 7
    @State private var selectedTab = 0

    private let ranges = [7, 14, 30]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Time range picker
                    Picker("Range", selection: $selectedRange) {
                        Text("7 Days").tag(7)
                        Text("14 Days").tag(14)
                        Text("30 Days").tag(30)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    if logs.isEmpty {
                        emptyState
                    } else {
                        // Tab selector
                        Picker("View", selection: $selectedTab) {
                            Text("Overview").tag(0)
                            Text("Heart Rate").tag(1)
                            Text("Symptoms").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)

                        switch selectedTab {
                        case 0: overviewSection
                        case 1: heartRateSection
                        case 2: symptomsSection
                        default: EmptyView()
                        }

                        logListSection
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("History")
            .onAppear { loadLogs() }
            .onChange(of: selectedRange) { _ in loadLogs() }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Data Yet")
                .font(.title3.weight(.semibold))
            Text("Start logging daily to see your trends here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
    }

    // MARK: - Overview

    private var overviewSection: some View {
        VStack(spacing: 12) {
            // Summary cards
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                SummaryCard(
                    title: "Avg Rating",
                    value: String(format: "%.1f", averageRating),
                    icon: "star.fill",
                    color: ratingColor(averageRating)
                )
                SummaryCard(
                    title: "Avg HR Increase",
                    value: averageHRIncrease.map { "\($0) BPM" } ?? "—",
                    icon: "heart.fill",
                    color: hrIncreaseColor
                )
                SummaryCard(
                    title: "Days Logged",
                    value: "\(logs.count)",
                    icon: "calendar.badge.checkmark",
                    color: .blue
                )
                SummaryCard(
                    title: "Avg Sleep",
                    value: String(format: "%.1fh", averageSleep),
                    icon: "moon.fill",
                    color: .indigo
                )
            }
            .padding(.horizontal)

            // Best & worst days
            if logs.count >= 3 {
                LogCard(title: "Best & Worst Days", icon: "arrow.up.arrow.down") {
                    VStack(spacing: 8) {
                        if let best = bestDay {
                            dayRow(log: best, label: "Best", color: .green)
                        }
                        if let worst = worstDay {
                            dayRow(log: worst, label: "Worst", color: .red)
                        }
                    }
                }
                .padding(.horizontal)
            }

            // Top triggers
            if !topTriggers.isEmpty {
                LogCard(title: "Top Triggers", icon: "exclamationmark.triangle") {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(topTriggers, id: \.0) { trigger, count in
                            HStack {
                                Text(trigger)
                                    .font(.subheadline)
                                Spacer()
                                Text("\(count)x")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.orange)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Heart Rate Section

    private var heartRateSection: some View {
        VStack(spacing: 12) {
            // HR Delta chart (bar-style using native SwiftUI)
            LogCard(title: "Orthostatic HR Increase", icon: "heart.fill") {
                if hrDeltas.isEmpty {
                    Text("No heart rate data recorded yet.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        // POTS threshold line label
                        HStack {
                            Spacer()
                            Text("POTS threshold: 30 BPM")
                                .font(.caption2)
                                .foregroundStyle(.red.opacity(0.7))
                        }

                        HStack(alignment: .bottom, spacing: 4) {
                            ForEach(hrDeltas, id: \.date) { entry in
                                VStack(spacing: 2) {
                                    Text("\(entry.delta)")
                                        .font(.system(size: 8))
                                        .foregroundStyle(.secondary)

                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(entry.delta >= 30 ? Color.red : Color.pink)
                                        .frame(height: max(4, CGFloat(entry.delta) * 1.5))

                                    Text(entry.label)
                                        .font(.system(size: 7))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .frame(height: 80)

                        // 30 BPM threshold indicator
                        HStack {
                            Rectangle()
                                .fill(Color.red.opacity(0.3))
                                .frame(height: 1)
                        }
                    }
                }
            }
            .padding(.horizontal)

            // HR breakdown
            LogCard(title: "Heart Rate by Position", icon: "figure.stand") {
                if logs.filter({ $0.lyingHR != nil }).isEmpty {
                    Text("No positional HR data yet.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    VStack(spacing: 8) {
                        hrPositionRow("Lying", values: logs.compactMap(\.lyingHR), color: .blue)
                        hrPositionRow("Sitting", values: logs.compactMap(\.sittingHR), color: .cyan)
                        hrPositionRow("Standing", values: logs.compactMap(\.standingHR), color: .pink)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Symptoms Section

    private var symptomsSection: some View {
        VStack(spacing: 12) {
            // Symptom frequency
            LogCard(title: "Symptom Frequency", icon: "list.bullet.clipboard") {
                if symptomFrequency.isEmpty {
                    Text("No symptoms logged yet.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    VStack(spacing: 8) {
                        ForEach(symptomFrequency.prefix(8), id: \.name) { item in
                            HStack {
                                Text(item.name)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                Spacer()

                                // Frequency bar
                                GeometryReader { geo in
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(severityColor(item.avgSeverity))
                                        .frame(width: geo.size.width * item.ratio)
                                }
                                .frame(width: 80, height: 12)

                                Text("\(item.count)x")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .frame(width: 30, alignment: .trailing)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)

            // Average severity
            LogCard(title: "Average Symptom Severity", icon: "gauge.with.dots.needle.33percent") {
                if symptomFrequency.isEmpty {
                    Text("No data yet.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    VStack(spacing: 6) {
                        ForEach(symptomFrequency.prefix(6), id: \.name) { item in
                            HStack {
                                Text(item.name)
                                    .font(.caption)
                                    .lineLimit(1)
                                Spacer()
                                ForEach(1...5, id: \.self) { level in
                                    Circle()
                                        .fill(level <= Int(item.avgSeverity.rounded()) ? severityColor(item.avgSeverity) : Color.gray.opacity(0.2))
                                        .frame(width: 10, height: 10)
                                }
                                Text(String(format: "%.1f", item.avgSeverity))
                                    .font(.caption2.weight(.semibold))
                                    .frame(width: 28, alignment: .trailing)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Log List

    private var logListSection: some View {
        LogCard(title: "Daily Logs", icon: "list.bullet") {
            VStack(spacing: 0) {
                ForEach(logs) { log in
                    NavigationLink(destination: LogDetailView(log: log)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(log.date, style: .date)
                                    .font(.subheadline.weight(.medium))
                                HStack(spacing: 8) {
                                    if let delta = log.orthostaticHRIncrease {
                                        Label("\(delta) BPM", systemImage: "heart.fill")
                                            .font(.caption)
                                            .foregroundStyle(delta >= 30 ? .red : .secondary)
                                    }
                                    if !log.symptoms.isEmpty {
                                        Label("\(log.symptoms.count) symptoms", systemImage: "staroflife")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            Spacer()
                            ratingBadge(log.overallRating)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 8)
                    }
                    .foregroundStyle(.primary)

                    if log.id != logs.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Helpers

    private func loadLogs() {
        logs = DatabaseManager.shared.loadDailyLogs(last: selectedRange)
    }

    private var averageRating: Double {
        guard !logs.isEmpty else { return 0 }
        return Double(logs.map(\.overallRating).reduce(0, +)) / Double(logs.count)
    }

    private var averageHRIncrease: Int? {
        let deltas = logs.compactMap(\.orthostaticHRIncrease)
        guard !deltas.isEmpty else { return nil }
        return deltas.reduce(0, +) / deltas.count
    }

    private var averageSleep: Double {
        guard !logs.isEmpty else { return 0 }
        return logs.map(\.hoursSlept).reduce(0, +) / Double(logs.count)
    }

    private var bestDay: DailyLog? {
        logs.max(by: { $0.overallRating < $1.overallRating })
    }

    private var worstDay: DailyLog? {
        logs.min(by: { $0.overallRating < $1.overallRating })
    }

    private var topTriggers: [(String, Int)] {
        var counts: [String: Int] = [:]
        for log in logs {
            for trigger in log.triggersToday {
                counts[trigger, default: 0] += 1
            }
        }
        return counts.sorted { $0.value > $1.value }.prefix(5).map { ($0.key, $0.value) }
    }

    private struct HRDelta: Hashable {
        let date: Date
        let delta: Int
        let label: String
    }

    private var hrDeltas: [HRDelta] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return logs.compactMap { log in
            guard let delta = log.orthostaticHRIncrease else { return nil }
            return HRDelta(date: log.date, delta: delta, label: formatter.string(from: log.date))
        }
    }

    private func hrPositionRow(_ label: String, values: [Int], color: Color) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .frame(width: 65, alignment: .leading)
            if values.isEmpty {
                Text("—")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                let avg = values.reduce(0, +) / values.count
                let min = values.min() ?? 0
                let max = values.max() ?? 0
                Text("Avg \(avg)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(color)
                Spacer()
                Text("Min \(min) / Max \(max)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private struct SymptomStat: Hashable {
        let name: String
        let count: Int
        let avgSeverity: Double
        let ratio: Double
    }

    private var symptomFrequency: [SymptomStat] {
        var counts: [String: (count: Int, totalSeverity: Int)] = [:]
        for log in logs {
            for symptom in log.symptoms {
                let existing = counts[symptom.name] ?? (0, 0)
                counts[symptom.name] = (existing.count + 1, existing.totalSeverity + symptom.severity)
            }
        }
        let maxCount = counts.values.map(\.count).max() ?? 1
        return counts.map { name, data in
            SymptomStat(
                name: name,
                count: data.count,
                avgSeverity: Double(data.totalSeverity) / Double(data.count),
                ratio: Double(data.count) / Double(maxCount)
            )
        }.sorted { $0.count > $1.count }
    }

    private func ratingColor(_ rating: Double) -> Color {
        if rating >= 7 { return .green }
        if rating >= 4 { return .orange }
        return .red
    }

    private var hrIncreaseColor: Color {
        guard let avg = averageHRIncrease else { return .secondary }
        return avg >= 30 ? .red : .pink
    }

    private func severityColor(_ severity: Double) -> Color {
        if severity >= 4 { return .red }
        if severity >= 3 { return .orange }
        if severity >= 2 { return .yellow }
        return .green
    }

    private func ratingBadge(_ rating: Int) -> some View {
        Text("\(rating)/10")
            .font(.caption.weight(.bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(ratingColor(Double(rating)).opacity(0.15))
            .foregroundStyle(ratingColor(Double(rating)))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    private func dayRow(log: DailyLog, label: String, color: Color) -> some View {
        HStack {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(color)
                .frame(width: 40, alignment: .leading)
            Text(log.date, style: .date)
                .font(.subheadline)
            Spacer()
            ratingBadge(log.overallRating)
        }
    }
}

// MARK: - Summary Card

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
