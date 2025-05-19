

import Foundation

struct Dosage: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var amount: Double // in mg
    var notes: String
    var feelingScore: Int // 1-5 scale
    var waterConsumed: Int // in glasses/ml
    
    static var sampleDosage: Dosage {
        Dosage(date: Date(), amount: 0, notes: "", feelingScore: 3, waterConsumed: 0)
    }
}

class DosageStore: ObservableObject {
    @Published var dosages: [Dosage] = []
    
    init() {
        loadDosages()
    }
    
    func addDosage(_ dosage: Dosage) {
        dosages.append(dosage)
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
}