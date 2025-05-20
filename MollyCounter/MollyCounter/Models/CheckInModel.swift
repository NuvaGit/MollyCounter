import Foundation
import SwiftUI

struct CheckIn: Identifiable, Codable {
    var id = UUID()
    var dosageId: UUID
    var timestamp: Date
    var symptoms: [String]
    var feelingScore: Int // 1-5 scale
    var notes: String
    var waterConsumed: Int // Glasses of water since last check-in
    var phase: String? // Current phase (calculated, not entered)
    
    static var sampleCheckIn: CheckIn {
        CheckIn(
            dosageId: UUID(),
            timestamp: Date(),
            symptoms: ["Jaw clenching", "Euphoria"],
            feelingScore: 4,
            notes: "Feeling great, music sounds amazing",
            waterConsumed: 1
        )
    }
}