

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dosageStore: DosageStore
    
    var body: some View {
        NavigationView {
            List {
                if dosageStore.dosages.isEmpty {
                    Text("No records yet")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(dosageStore.dosages.sorted(by: { $0.date > $1.date })) { dosage in
                        NavigationLink(destination: DosageDetailView(dosage: dosage)) {
                            DosageRow(dosage: dosage)
                        }
                    }
                }
            }
            .navigationTitle("Health History")
        }
    }
}

struct DosageRow: View {
    let dosage: Dosage
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dosage.date, style: .date)
                    .font(.headline)
                Text("\(dosage.amount, specifier: "%.1f") mg")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack {
                ForEach(1...dosage.feelingScore, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct DosageDetailView: View {
    let dosage: Dosage
    
    var body: some View {
        Form {
            Section(header: Text("Timing")) {
                HStack {
                    Text("Date")
                    Spacer()
                    Text(dosage.date, style: .date)
                }
                HStack {
                    Text("Time")
                    Spacer()
                    Text(dosage.date, style: .time)
                }
            }
            
            Section(header: Text("Details")) {
                HStack {
                    Text("Amount")
                    Spacer()
                    Text("\(dosage.amount, specifier: "%.1f") mg")
                }
                HStack {
                    Text("Water Consumed")
                    Spacer()
                    Text("\(dosage.waterConsumed) glasses")
                }
                HStack {
                    Text("Feeling Score")
                    Spacer()
                    HStack {
                        ForEach(1...5, id: \.self) { score in
                            Image(systemName: score <= dosage.feelingScore ? "star.fill" : "star")
                                .foregroundColor(score <= dosage.feelingScore ? .yellow : .gray)
                        }
                    }
                }
            }
            
            if !dosage.notes.isEmpty {
                Section(header: Text("Notes")) {
                    Text(dosage.notes)
                }
            }
        }
        .navigationTitle("Record Details")
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(DosageStore())
    }
}