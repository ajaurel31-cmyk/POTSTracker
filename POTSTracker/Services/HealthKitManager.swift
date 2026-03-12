import Foundation
import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()
    private let store = HKHealthStore()

    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func fetchLatestHeartRate() async -> Int? {
        await fetchLatestQuantity(type: .heartRate, unit: HKUnit.count().unitDivided(by: .minute()))
            .map { Int($0) }
    }

    func fetchLatestBloodPressure() async -> (systolic: Int, diastolic: Int)? {
        guard let bpType = HKCorrelationType.correlationType(forIdentifier: .bloodPressure) else { return nil }

        let predicate = HKQuery.predicateForSamples(
            withStart: Calendar.current.startOfDay(for: Date()),
            end: Date(),
            options: .strictStartDate
        )
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: bpType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                guard let correlation = samples?.first as? HKCorrelation else {
                    continuation.resume(returning: nil)
                    return
                }

                let systolicSamples = correlation.objects(for: HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!)
                let diastolicSamples = correlation.objects(for: HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!)

                guard let systolic = (systolicSamples.first as? HKQuantitySample)?.quantity.doubleValue(for: .millimeterOfMercury()),
                      let diastolic = (diastolicSamples.first as? HKQuantitySample)?.quantity.doubleValue(for: .millimeterOfMercury()) else {
                    continuation.resume(returning: nil)
                    return
                }

                continuation.resume(returning: (Int(systolic), Int(diastolic)))
            }
            store.execute(query)
        }
    }

    private func fetchLatestQuantity(type identifier: HKQuantityTypeIdentifier, unit: HKUnit) async -> Double? {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else { return nil }

        let predicate = HKQuery.predicateForSamples(
            withStart: Calendar.current.startOfDay(for: Date()),
            end: Date(),
            options: .strictStartDate
        )
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                guard let sample = samples?.first as? HKQuantitySample else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: sample.quantity.doubleValue(for: unit))
            }
            store.execute(query)
        }
    }
}
