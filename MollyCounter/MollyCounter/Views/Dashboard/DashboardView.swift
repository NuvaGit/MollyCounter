//
//  DashboardView.swift
//  MollyCounter
//

import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var dosageStore: DosageStore
    @State private var showingEmergencySheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Emergency access
                    EmergencyCard(showingSheet: $showingEmergencySheet)
                    
                    // Current status
                    if let lastDosage = dosageStore.dosages.last {
                        CurrentStatusCard(dosage: lastDosage)
                    } else {
                        NoUsageCard()
                    }
                    
                    // Recovery timeline
                    RecoveryTimelineCard(dosages: dosageStore.dosages)
                    
                    // Usage graph
                    UsageGraphCard(dosages: dosageStore.dosages)
                    
                    // Health tips
                    TipsCard()
                }
                .padding()
            }
            .navigationTitle("Health Dashboard")
            .sheet(isPresented: $showingEmergencySheet) {
                EmergencyContactView()
            }
        }
    }
}

struct EmergencyCard: View {
    @Binding var showingSheet: Bool
    
    var body: some View {
        Button(action: {
            showingSheet = true
        }) {
            HStack {
                Image(systemName: "phone.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Emergency Contact")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .cornerRadius(12)
        }
    }
}

struct CurrentStatusCard: View {
    let dosage: Dosage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Status")
                .font(.headline)
            
            let daysSince = Int(Date().timeIntervalSince(dosage.date) / 86400)
            let hoursSince = Int(Date().timeIntervalSince(dosage.date) / 3600) % 24
            
            // Current recovery phase
            HStack {
                Image(systemName: getPhaseIcon(daysSince: daysSince))
                    .foregroundColor(getPhaseColor(daysSince: daysSince))
                    .font(.title)
                
                VStack(alignment: .leading) {
                    Text(getPhaseName(daysSince: daysSince))
                        .font(.title3)
                        .bold()
                    Text(getPhaseDescription(daysSince: daysSince))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Time since last use
            HStack {
                VStack(alignment: .leading) {
                    Text("Last recorded use:")
                        .font(.subheadline)
                    Text("\(daysSince) days, \(hoursSince) hours ago")
                        .font(.title3)
                        .bold()
                    Text("Amount: \(dosage.amount, specifier: "%.1f") mg")
                        .font(.subheadline)
                }
                
                Spacer()
                
                // Circular progress toward 90-day recovery
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .opacity(0.3)
                        .foregroundColor(Color.blue)
                    
                    Circle()
                        .trim(from: 0.0, to: min(CGFloat(daysSince) / 90.0, 1.0))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.blue)
                        .rotationEffect(Angle(degrees: 270.0))
                    
                    Text("\(min(daysSince * 100 / 90, 100))%")
                        .font(.caption)
                        .bold()
                }
                .frame(width: 60, height: 60)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    // Helper functions for status display
    func getPhaseName(daysSince: Int) -> String {
        if daysSince < 7 {
            return "Acute Recovery"
        } else if daysSince < 30 {
            return "Mid Recovery"
        } else if daysSince < 90 {
            return "Late Recovery"
        } else {
            return "Full Recovery"
        }
    }
    
    func getPhaseDescription(daysSince: Int) -> String {
        if daysSince < 7 {
            return "Body is clearing substances"
        } else if daysSince < 30 {
            return "Neurotransmitters rebalancing"
        } else if daysSince < 90 {
            return "Final healing stages"
        } else {
            return "3+ months since last use"
        }
    }
    
    func getPhaseIcon(daysSince: Int) -> String {
        if daysSince < 7 {
            return "arrow.counterclockwise.circle.fill"
        } else if daysSince < 30 {
            return "chart.line.uptrend.xyaxis.circle.fill"
        } else if daysSince < 90 {
            return "leaf.circle.fill"
        } else {
            return "checkmark.seal.fill"
        }
    }
    
    func getPhaseColor(daysSince: Int) -> Color {
        if daysSince < 7 {
            return Color.orange
        } else if daysSince < 30 {
            return Color.yellow
        } else if daysSince < 90 {
            return Color.blue
        } else {
            return Color.green
        }
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

struct RecoveryTimelineCard: View {
    let dosages: [Dosage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recovery Timeline")
                .font(.headline)
            
            let daysSinceLastUse = dosages.isEmpty ? 999 : Int(Date().timeIntervalSince(dosages.last!.date) / 86400)
            
            TimelineView(.everyMinute) { timeline in
                VStack(spacing: 15) {
                    RecoveryMilestone(
                        name: "7 Days",
                        description: "Sleep patterns begin to normalize",
                        achieved: daysSinceLastUse >= 7,
                        daysLeft: max(0, 7 - daysSinceLastUse)
                    )
                    
                    RecoveryMilestone(
                        name: "30 Days", 
                        description: "Mood stabilizes and energy improves",
                        achieved: daysSinceLastUse >= 30,
                        daysLeft: max(0, 30 - daysSinceLastUse)
                    )
                    
                    RecoveryMilestone(
                        name: "90 Days",
                        description: "Neurotransmitter systems healing well",
                        achieved: daysSinceLastUse >= 90,
                        daysLeft: max(0, 90 - daysSinceLastUse)
                    )
                }
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
}

struct RecoveryMilestone: View {
    let name: String
    let description: String
    let achieved: Bool
    let daysLeft: Int
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: achieved ? "checkmark.circle.fill" : "circle")
                .foregroundColor(achieved ? .green : .gray)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.subheadline)
                    .bold()
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !achieved {
                Text("\(daysLeft) days left")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.orange)
            }
        }
    }
}

struct UsageGraphCard: View {
    let dosages: [Dosage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Usage Patterns")
                .font(.headline)
            
            if dosages.count < 2 {
                Text("Not enough data to display graph")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                let last6Months = getDateLabels()
                let data = prepareGraphData(dates: last6Months)
                
                Chart {
                    ForEach(data) { item in
                        BarMark(
                            x: .value("Month", item.month),
                            y: .value("Usage", item.usageCount)
                        )
                        .foregroundStyle(Color.purple.gradient)
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(preset: .aligned) { _ in
                        AxisValueLabel()
                    }
                }
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
    
    // Helpers for chart data
    struct UsageDataPoint: Identifiable {
        var id = UUID()
        var month: String
        var usageCount: Int
    }
    
    func getDateLabels() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        var date = Date()
        
        for i in 0..<6 {
            if let newDate = calendar.date(byAdding: .month, value: -i, to: date) {
                dates.append(newDate)
            }
        }
        
        return dates.reversed()
    }
    
    func prepareGraphData(dates: [Date]) -> [UsageDataPoint] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        return dates.map { date in
            let startOfMonth = Calendar.current.startOfMonth(for: date)
            let endOfMonth = Calendar.current.endOfMonth(for: date)
            
            let usagesInMonth = dosages.filter { dosage in
                dosage.date >= startOfMonth && dosage.date <= endOfMonth
            }.count
            
            return UsageDataPoint(
                month: dateFormatter.string(from: date),
                usageCount: usagesInMonth
            )
        }
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

// Additional extension for calendar calculations
extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
    
    func endOfMonth(for date: Date) -> Date {
        var components = DateComponents()
        components.month = 1
        components.day = -1
        return self.date(byAdding: components, to: startOfMonth(for: date))!
    }
}

struct EmergencyContactView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Emergency Numbers")) {
                    EmergencyContactRow(
                        name: "Emergency Services",
                        number: "911",
                        icon: "phone.fill",
                        color: .red
                    )
                    
                    EmergencyContactRow(
                        name: "Poison Control",
                        number: "1-800-222-1222",
                        icon: "cross.case.fill",
                        color: .blue
                    )
                    
                    EmergencyContactRow(
                        name: "Crisis Text Line",
                        number: "Text HOME to 741741",
                        icon: "message.fill",
                        color: .green
                    )
                }
                
                Section(header: Text("Warning Signs")) {
                    WarningRow(sign: "High fever or overheating")
                    WarningRow(sign: "Severe headache or dizziness")
                    WarningRow(sign: "Irregular heartbeat")
                    WarningRow(sign: "Excessive sweating/chills")
                    WarningRow(sign: "Confusion or disorientation")
                    WarningRow(sign: "Severe anxiety or panic")
                }
            }
            .navigationTitle("Emergency Resources")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        // Sheet will dismiss
                    }
                }
            }
        }
    }
}

struct EmergencyContactRow: View {
    let name: String
    let number: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(number)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let url = URL(string: "tel:\(number.filter { $0.isNumber })"), number != "Text HOME to 741741" {
                Link(destination: url) {
                    Image(systemName: "phone.arrow.up.right.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct WarningRow: View {
    let sign: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(sign)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(DosageStore())
    }
}