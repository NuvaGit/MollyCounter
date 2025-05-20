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
                            DosageRow(dosage: dosage, hasCheckIns: dosageStore.getCheckIns(forDosage: dosage.id).count > 0)
                        }
                    }
                }
            }
            .navigationTitle("MDMA History")
        }
    }
}

struct DosageRow: View {
    let dosage: Dosage
    let hasCheckIns: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dosage.date, style: .date)
                    .font(.headline)
                Text("\(dosage.amount, specifier: "%.1f") mg")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                HStack {
                    ForEach(1...dosage.feelingScore, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
                
                if hasCheckIns {
                    Text("Has check-ins")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct DosageDetailView: View {
    @EnvironmentObject var dosageStore: DosageStore
    @State private var showingAddCheckInSheet = false
    
    let dosage: Dosage
    
    var body: some View {
        List {
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
                    Text("Initial Expectation")
                    Spacer()
                    HStack {
                        ForEach(1...5, id: \.self) { score in
                            Image(systemName: score <= dosage.feelingScore ? "star.fill" : "star")
                                .foregroundColor(score <= dosage.feelingScore ? .yellow : .gray)
                        }
                    }
                }
                
                if let location = dosage.location {
                    HStack {
                        Text("Setting")
                        Spacer()
                        Text(location)
                    }
                }
                
                if let withFriends = dosage.withFriends {
                    HStack {
                        Text("With trusted friends")
                        Spacer()
                        Text(withFriends ? "Yes" : "No")
                    }
                }
            }
            
            if let supplements = dosage.supplements, !supplements.isEmpty {
                Section(header: Text("Supplements Taken")) {
                    ForEach(supplements, id: \.self) { supplement in
                        Text(supplement)
                    }
                }
            }
            
            if !dosage.notes.isEmpty {
                Section(header: Text("Notes")) {
                    Text(dosage.notes)
                }
            }
            
            // Check-ins section
            let checkIns = dosageStore.getCheckIns(forDosage: dosage.id)
            if !checkIns.isEmpty {
                Section(header: Text("Experience Check-Ins")) {
                    ForEach(checkIns.sorted(by: { $0.timestamp > $1.timestamp })) { checkIn in
                        NavigationLink(destination: CheckInDetailView(checkIn: checkIn)) {
                            CheckInRow(checkIn: checkIn)
                        }
                    }
                }
            }
            
            // Add check-in retrospectively if needed
            Section {
                Button(action: {
                    showingAddCheckInSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add Retrospective Check-In")
                    }
                }
            }
        }
        .navigationTitle("Record Details")
        .sheet(isPresented: $showingAddCheckInSheet) {
            let minutesSince = Int(Date().timeIntervalSince(dosage.date) / 60)
            CheckInView(dosage: dosage, minutesSince: minutesSince)
        }
    }
}

struct CheckInRow: View {
    let checkIn: CheckIn
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let phase = checkIn.phase {
                    Text(phase)
                        .font(.headline)
                        .foregroundColor(getPhaseColor(phase: phase))
                } else {
                    Text("Check-In")
                        .font(.headline)
                }
                
                Spacer()
                
                Text(relativeTime(for: checkIn.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !checkIn.symptoms.isEmpty {
                Text("\(checkIn.symptoms.count) symptoms recorded")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                ForEach(1...checkIn.feelingScore, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func relativeTime(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func getPhaseColor(phase: String) -> Color {
        switch phase {
        case "Onset": return .blue
        case "Come-up": return .purple
        case "Peak": return .pink
        case "Plateau": return .orange
        case "Come-down": return .yellow
        case "After-effects": return .gray
        default: return .primary
        }
    }
}

struct CheckInDetailView: View {
    let checkIn: CheckIn
    
    var body: some View {
        Form {
            Section(header: Text("Timing")) {
                HStack {
                    Text("Time")
                    Spacer()
                    Text(checkIn.timestamp, style: .time)
                }
                
                if let phase = checkIn.phase {
                    HStack {
                        Text("Phase")
                        Spacer()
                        Text(phase)
                            .foregroundColor(getPhaseColor(phase: phase))
                    }
                }
            }
            
            Section(header: Text("Feeling")) {
                HStack {
                    Text("Feeling Score")
                    Spacer()
                    HStack {
                        ForEach(1...5, id: \.self) { score in
                            Image(systemName: score <= checkIn.feelingScore ? "star.fill" : "star")
                                .foregroundColor(score <= checkIn.feelingScore ? .yellow : .gray)
                        }
                    }
                }
                
                HStack {
                    Text("Water Consumed")
                    Spacer()
                    Text("\(checkIn.waterConsumed) glasses")
                }
            }
            
            if !checkIn.symptoms.isEmpty {
                Section(header: Text("Effects Experienced")) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(checkIn.symptoms.sorted(), id: \.self) { symptom in
                            Text(symptom)
                                .font(.caption)
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            if !checkIn.notes.isEmpty {
                Section(header: Text("Notes")) {
                    Text(checkIn.notes)
                }
            }
        }
        .navigationTitle("Check-In Details")
    }
    
    private func getPhaseColor(phase: String) -> Color {
        switch phase {
        case "Onset": return .blue
        case "Come-up": return .purple
        case "Peak": return .pink
        case "Plateau": return .orange
        case "Come-down": return .yellow
        case "After-effects": return .gray
        default: return .primary
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(DosageStore())
    }
}