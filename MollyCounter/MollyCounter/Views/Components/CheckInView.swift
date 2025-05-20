import SwiftUI

struct CheckInView: View {
    @EnvironmentObject var dosageStore: DosageStore
    @Environment(\.presentationMode) var presentationMode
    @State private var newCheckIn: CheckIn
    @State private var selectedSymptoms: Set<String> = []
    @State private var showingAlert = false
    
    let dosage: Dosage
    let minutesSince: Int
    
    // MDMA-specific symptoms to track
    let possibleSymptoms = [
        "Jaw clenching", "Eye wiggles", "Increased energy", 
        "Euphoria", "Enhanced touch", "Sweating", 
        "Thirst", "Increased heartrate", "Anxiety",
        "Enhanced music", "Talkativeness", "Empathy",
        "Body warmth", "Heightened senses", "Love feelings",
        "Light sensitivity", "Blurry vision", "Dizziness",
        "Headache", "Nausea", "Cold extremities"
    ]
    
    init(dosage: Dosage, minutesSince: Int) {
        self.dosage = dosage
        self.minutesSince = minutesSince
        
        // Initialize with default values
        _newCheckIn = State(initialValue: CheckIn(
            dosageId: dosage.id,
            timestamp: Date(),
            symptoms: [],
            feelingScore: 3,
            notes: "",
            waterConsumed: 0
        ))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("How are you feeling?")) {
                    VStack(alignment: .leading) {
                        Text("Rate your current experience (1-5)")
                        HStack {
                            ForEach(1...5, id: \.self) { score in
                                Button(action: {
                                    newCheckIn.feelingScore = score
                                }) {
                                    Image(systemName: score <= newCheckIn.feelingScore ? "star.fill" : "star")
                                        .foregroundColor(score <= newCheckIn.feelingScore ? .yellow : .gray)
                                        .font(.title2)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Current Effects")) {
                    // Create a grid-like layout using LazyVGrid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 10) {
                        ForEach(possibleSymptoms.sorted(), id: \.self) { symptom in
                            Button(action: {
                                if selectedSymptoms.contains(symptom) {
                                    selectedSymptoms.remove(symptom)
                                } else {
                                    selectedSymptoms.insert(symptom)
                                }
                            }) {
                                HStack {
                                    if selectedSymptoms.contains(symptom) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Text(symptom)
                                        .font(.caption)
                                }
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedSymptoms.contains(symptom) ? 
                                              Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Hydration")) {
                    HStack {
                        Text("Water consumed since last check")
                        Spacer()
                        
                        Stepper("\(newCheckIn.waterConsumed) glasses", value: $newCheckIn.waterConsumed, in: 0...10)
                    }
                    
                    if newCheckIn.waterConsumed >= 4 {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Remember not to overhydrate!")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $newCheckIn.notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: {
                        // Prepare check-in data
                        newCheckIn.symptoms = Array(selectedSymptoms)
                        
                        // Set phase based on time since dosage
                        let phase = getCurrentPhase(minutesSince: minutesSince)
                        newCheckIn.phase = phase?.name
                        
                        // Save check-in
                        dosageStore.addCheckIn(newCheckIn)
                        showingAlert = true
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Check-In")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                        .padding()
                    }
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .listRowInsets(EdgeInsets())
                .padding()
            }
            .navigationTitle("MDMA Check-In")
            .alert("Check-In Saved", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Your check-in has been recorded. Stay safe and enjoy your experience.")
            }
        }
    }
    
    // Helper function to get current phase
    private func getCurrentPhase(minutesSince: Int) -> EffectPhase? {
        let effectPhases = [
            EffectPhase(
                name: "Onset",
                timeRange: 0...30,
                description: "Initial absorption",
                feelings: ["Anticipation", "Subtle changes", "Alertness"],
                color: .blue,
                icon: "timer"
            ),
            EffectPhase(
                name: "Come-up",
                timeRange: 30...60,
                description: "Effects begin",
                feelings: ["Energy", "Enhanced mood", "Excitement", "Possible anxiety"],
                color: .purple,
                icon: "arrow.up.circle.fill"
            ),
            EffectPhase(
                name: "Peak",
                timeRange: 60...150,
                description: "Maximum effects",
                feelings: ["Euphoria", "Empathy", "Enhanced senses", "Sociability"],
                color: .pink,
                icon: "sparkles"
            ),
            EffectPhase(
                name: "Plateau",
                timeRange: 150...240,
                description: "Sustained effects",
                feelings: ["Continued euphoria", "Reduced intensity", "Energy"],
                color: .orange,
                icon: "waveform.path.ecg"
            ),
            EffectPhase(
                name: "Come-down",
                timeRange: 240...360,
                description: "Reducing effects",
                feelings: ["Gentle decline", "Less energy", "Relaxation"],
                color: .yellow,
                icon: "arrow.down.circle.fill"
            ),
            EffectPhase(
                name: "After-effects",
                timeRange: 360...1440,
                description: "Recovery beginning",
                feelings: ["Fatigue", "Reflective", "Rest needed"],
                color: .gray,
                icon: "bed.double.fill"
            )
        ]
        
        return effectPhases.first(where: { phase in
            minutesSince >= phase.timeRange.lowerBound && minutesSince <= phase.timeRange.upperBound
        })
    }
}

// Preview is commented out to avoid dependency issues
/*
struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView(dosage: Dosage.sampleDosage, minutesSince: 90)
            .environmentObject(DosageStore())
    }
}
*/