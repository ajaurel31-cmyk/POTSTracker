import Foundation

enum DiagnosisType: String, CaseIterable, Identifiable, Codable {
    case pots = "POTS"
    case hyperadrenergicPOTS = "Hyperadrenergic POTS"
    case vasovagalSyncope = "Vasovagal Syncope"
    case orthostaticHypotension = "Orthostatic Hypotension"
    case otherDysautonomia = "Other Dysautonomia"
    case undiagnosed = "Undiagnosed"

    var id: String { rawValue }
}
