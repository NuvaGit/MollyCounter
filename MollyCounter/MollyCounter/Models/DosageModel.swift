import Foundation
import SwiftUI

struct Dosage: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var amount: Double // in mg
    var notes: String
    var feelingScore: Int // 1-5 scale - initial expectation
    var waterConsumed: Int // in glasses/ml - initial amount
    var location: String? // Setting where MDMA was consumed
    var withFriends: Bool? // Whether with trusted friends
    var supplements: [String]? // Supplements taken
    var purity: String? // Purity level if tested
    var userId: String? // For future multi-user support
    
    static var sampleDosage: Dosage {
        Dosage(date: Date(), amount: 100, notes: "", feelingScore: 3, waterConsumed: 0, withFriends: true)
    }
}

class DosageStore: ObservableObject {
    @Published var dosages: [Dosage] = []
    @Published var checkIns: [CheckIn] = []
    @Published var currentUser: UserProfile? = nil
    
    init() {
        loadDosages()
        loadCheckIns()
    }
    
    func addDosage(_ dosage: Dosage) {
        var newDosage = dosage
        newDosage.userId = currentUser?.id
        dosages.append(newDosage)
        saveDosages()
    }
    
    func saveDosages() {
        // Save to UserDefaults for now
        if let encoded = try? JSONEncoder().encode(dosages) {
            UserDefaults.standard.set(encoded, forKey: "dosages")
        }
    }
    
    func loadDosages() {
        if let data = UserDefaults.standard.data(forKey: "dosages"),
           let decoded = try? JSONDecoder().decode([Dosage].self, from: data) {
            dosages = decoded
        }
    }
    
    func addCheckIn(_ checkIn: CheckIn) {
        checkIns.append(checkIn)
        saveCheckIns()
    }
    
    func saveCheckIns() {
        if let encoded = try? JSONEncoder().encode(checkIns) {
            UserDefaults.standard.set(encoded, forKey: "checkIns")
        }
    }
    
    func loadCheckIns() {
        if let data = UserDefaults.standard.data(forKey: "checkIns"),
           let decoded = try? JSONDecoder().decode([CheckIn].self, from: data) {
            checkIns = decoded
        }
    }
    
    // Get check-ins for a specific dosage
    func getCheckIns(forDosage dosageId: UUID) -> [CheckIn] {
        return checkIns.filter { $0.dosageId == dosageId }
            .sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    // Check if there are any check-ins for a dosage
    func hasCheckIns(forDosage dosageId: UUID) -> Bool {
        return checkIns.contains(where: { $0.dosageId == dosageId })
    }
    
    // Calculate safe dosage based on weight and experience
    func calculateSafeDosage(weight: Double, experience: String) -> ClosedRange<Double> {
        var dosageRange: ClosedRange<Double>
        
        switch experience {
        case "first":
            dosageRange = (weight * 0.8)...(weight * 1.0)
        case "beginner":
            dosageRange = (weight * 1.0)...(weight * 1.3)
        case "experienced":
            dosageRange = (weight * 1.2)...(weight * 1.5)
        default:
            dosageRange = (weight * 1.0)...(weight * 1.3)
        }
        
        // Cap maximum dosage (harm reduction)
        if dosageRange.upperBound > 150 {
            dosageRange = dosageRange.lowerBound...150
        }
        
        return dosageRange
    }
    
    // For future authentication implementation
    func setCurrentUser(_ user: UserProfile) {
        self.currentUser = user
        // Would filter dosages by user.id in a real implementation
    }
    
    func clearCurrentUser() {
        self.currentUser = nil
    }
}

// For future authentication implementation
struct UserProfile: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var createdAt: Date
    var preferences: UserPreferences
}

struct UserPreferences: Codable {
    var useBiometricAuth: Bool = false
    var notificationsEnabled: Bool = true
    var darkModeEnabled: Bool = false
    var emergencyContact: String = ""
}

// MDMA-specific phase information
struct EffectPhase {
    let name: String
    let timeRange: ClosedRange<Int> // in minutes from dosage
    let description: String
    let feelings: [String]
    let color: Color
    let icon: String
}