//
//  LogEntryView.swift
//  MollyCounter
//

import SwiftUI

struct LogEntryView: View {
    @EnvironmentObject var dosageStore: DosageStore
    @State private var newDosage = Dosage.sampleDosage
    @State private var showingAlert = false
    
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
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $newDosage.notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button("Save Record") {
                        dosageStore.addDosage(newDosage)
                        showingAlert = true
                        newDosage = Dosage.sampleDosage
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(8)
                }
                .listRowInsets(EdgeInsets())
                .padding()
            }
            .navigationTitle("Log Health Data")
            .alert("Saved!", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your health data has been recorded.")
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