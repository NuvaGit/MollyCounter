import SwiftUI

struct LogEntryView: View {
    @EnvironmentObject var dosageStore: DosageStore
    @State private var newDosage = Dosage.sampleDosage
    @State private var showingAlert = false
    @State private var showEnvironment = false
    @State private var environment = "Home"
    @State private var selectedSupplements: Set<String> = []
    
    // MDMA environments
    let environments = ["Home", "Club", "Festival", "Party", "Concert", "Nature", "Other"]
    
    // MDMA-specific supplements
    let possibleSupplements = [
        "Magnesium (reduces jaw clenching)",
        "Vitamin C (antioxidant)",
        "ALA (Alpha Lipoic Acid)",
        "CoQ10 (heart health)",
        "EGCG (Green tea extract)",
        "5-HTP (for recovery, 24h+ after)",
        "Melatonin (for sleep after)"
    ]
    
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
                
                Section(header: Text("Initial Preparation")) {
                    HStack {
                        Text("Water prepared (glasses)")
                        Spacer()
                        TextField("0", value: $newDosage.waterConsumed, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Expectation (1-5)")
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
                
                Section(header: Text("Pre-Loading Supplements")) {
                    ForEach(possibleSupplements.sorted(), id: \.self) { supplement in
                        Button(action: {
                            if selectedSupplements.contains(supplement) {
                                selectedSupplements.remove(supplement)
                            } else {
                                selectedSupplements.insert(supplement)
                            }
                        }) {
                            HStack {
                                Text(supplement)
                                Spacer()
                                if selectedSupplements.contains(supplement) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $newDosage.notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: {
                        // Store selected supplements
                        newDosage.supplements = Array(selectedSupplements)
                        newDosage.location = environment
                        
                        dosageStore.addDosage(newDosage)
                        showingAlert = true
                        
                        // Reset form
                        newDosage = Dosage.sampleDosage
                        selectedSupplements = []
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
                Text("Your MDMA usage has been recorded. You can check in later as effects develop.")
            }
        }
    }
}

struct LogEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LogEntryView()
            .environmentObject(DosageStore())
    }
}