

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dosageStore: DosageStore
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Last use info
                    if let lastDosage = dosageStore.dosages.last {
                        LastUsageCard(dosage: lastDosage)
                    } else {
                        NoUsageCard()
                    }
                    
                    // Safety status
                    SafetyStatusCard(dosages: dosageStore.dosages)
                    
                    // Quick tips
                    TipsCard()
                }
                .padding()
            }
            .navigationTitle("Health Dashboard")
        }
    }
}

struct LastUsageCard: View {
    let dosage: Dosage
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Last Recorded Use")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Date: \(dosage.date, style: .date)")
                    Text("Amount: \(dosage.amount, specifier: "%.1f") mg")
                    Text("Water: \(dosage.waterConsumed) glasses")
                }
                Spacer()
                Text("\(Int(Date().timeIntervalSince(dosage.date) / 86400)) days ago")
                    .bold()
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
}

struct NoUsageCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("No Records")
                .font(.headline)
            Text("Use the Log tab to record health information")
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SafetyStatusCard: View {
    let dosages: [Dosage]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Health Status")
                .font(.headline)
            
            // Simplified safety check
            let daysSinceLastUse = dosages.isEmpty ? 999 : Int(Date().timeIntervalSince(dosages.last!.date) / 86400)
            
            HStack {
                Image(systemName: daysSinceLastUse > 90 ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(daysSinceLastUse > 90 ? .green : .orange)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(daysSinceLastUse > 90 ? "Recovery Complete" : "Recovery In Progress")
                        .font(.subheadline)
                        .bold()
                    Text("Recommended wait: 3+ months between uses")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct TipsCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Health Tips")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                TipRow(icon: "drop.fill", text: "Stay hydrated but don't overhydrate")
                TipRow(icon: "thermometer", text: "Monitor your body temperature")
                TipRow(icon: "bed.double.fill", text: "Ensure you get enough rest")
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .font(.subheadline)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(DosageStore())
    }
}