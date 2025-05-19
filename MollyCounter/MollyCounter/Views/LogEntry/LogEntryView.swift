import SwiftUI

struct LogEntryView: View {
    @EnvironmentObject var dosageStore: DosageStore
    @State private var newDosage = Dosage.sampleDosage
    @State private var showingAlert = false
    @State private var navigateToCalculator = false
    @State private var showEnvironment = false
    @State private var environment = "Home"
    @State private var selectedSymptoms: Set<String> = []
    
    // MDMA-specific symptoms to track
    let possibleSymptoms = [
        "Jaw clenching", "Eye wiggles", "Increased energy", 
        "Euphoria", "Enhanced touch", "Sweating", 
        "Thirst", "Increased heartrate", "Anxiety"
    ]
    
    // MDMA-specific environments
    let environments = ["Home", "Club", "Festival", "Party", "Concert", "Nature", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When")) {
                    DatePicker("Date & Time", selection: $newDosage.date)
                }
                
                Section(header: Text("Dosage")) {
                    HStack {
                        Text("Amount (mg)")
                        Spacer()
                        TextField("0", value: $newDosage.amount, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    // Modified to use navigation link directly to dosage calculator
                    NavigationLink(destination: DosageCalculatorView()) {
                        HStack {
                            Image(systemName: "function")
                            Text("Not sure? Calculate safe dosage")
                        }
                        .foregroundColor(.purple)
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("Environment")) {
                    Picker("Setting", selection: $environment) {
                        ForEach(environments, id: \.self) { env in
                            Text(env)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Toggle("With trusted friends?", isOn: $showEnvironment)
                }
                
                Section(header: Text("Health tracking")) {
                    HStack {
                        Text("Water consumed (glasses)")
                        Spacer()
                        TextField("0", value: $newDosage.waterConsumed, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("How did you feel? (1-5)")
                        HStack {
                            ForEach(1...5, id: \.self) { score in
                                Button(action: {
                                    newDosage.feelingScore = score
                                }) {
                                    Image(systemName: score <= newDosage.feelingScore ? "star.fill" : "star")
                                        .foregroundColor(score <= newDosage.feelingScore ? .yellow : .gray)
                                        .font(.title2)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("MDMA Effects")) {
                    ForEach(possibleSymptoms.sorted(), id: \.self) { symptom in
                        Button(action: {
                            if selectedSymptoms.contains(symptom) {
                                selectedSymptoms.remove(symptom)
                            } else {
                                selectedSymptoms.insert(symptom)
                            }
                        }) {
                            HStack {
                                Text(symptom)
                                Spacer()
                                if selectedSymptoms.contains(symptom) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
                
                Section(header: Text("Supplement Checklist")) {
                    SupplementCheckView(name: "Magnesium (reduces jaw clenching)")
                    SupplementCheckView(name: "Vitamin C (antioxidant)")
                    SupplementCheckView(name: "ALA (Alpha Lipoic Acid)")
                    SupplementCheckView(name: "CoQ10 (heart health)")
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $newDosage.notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: {
                        // Store selected symptoms
                        newDosage.symptoms = Array(selectedSymptoms)
                        newDosage.location = environment
                        
                        dosageStore.addDosage(newDosage)
                        showingAlert = true
                        
                        // Reset form
                        newDosage = Dosage.sampleDosage
                        selectedSymptoms = []
                    }) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                            Text("Save Record")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                        .padding()
                    }
                    .background(Color.purple)
                    .cornerRadius(8)
                }
                .listRowInsets(EdgeInsets())
                .padding()
            }
            .navigationTitle("Log MDMA Use")
            .alert("Saved!", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your MDMA usage has been recorded. Remember to stay hydrated and take breaks if dancing.")
            }
        }
    }
}

struct SupplementCheckView: View {
    let name: String
    @State private var isTaken = false
    
    var body: some View {
        HStack {
            Button(action: {
                isTaken.toggle()
            }) {
                HStack {
                    Text(name)
                    Spacer()
                    Image(systemName: isTaken ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isTaken ? .green : .gray)
                }
            }
            .foregroundColor(.primary)
        }
    }
}

struct LogEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LogEntryView()
            .environmentObject(DosageStore())
    }
}