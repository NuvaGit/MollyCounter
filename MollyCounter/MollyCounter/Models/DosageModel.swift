import Foundation
import SwiftUI

struct Dosage: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var amount: Double // in mg
    var notes: String
    var feelingScore: Int // 1-5 scale
    var waterConsumed: Int // in glasses/ml
    var location: String? // Optional location info
    var symptoms: [String]? // Optional symptoms reported
    var userId: String? // For future multi-user support
    
    static var sampleDosage: Dosage {
        Dosage(date: Date(), amount: 0, notes: "", feelingScore: 3, waterConsumed: 0)
    }
}

class DosageStore: ObservableObject {
    @Published var dosages: [Dosage] = []
    @Published var currentUser: UserProfile? = nil
    
    init() {
        loadDosages()
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