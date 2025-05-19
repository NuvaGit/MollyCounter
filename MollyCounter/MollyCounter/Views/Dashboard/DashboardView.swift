import SwiftUI
import Charts

struct DashboardView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dosageStore: DosageStore
    @State private var showingEmergencySheet = false
    @State private var animateCards = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dynamic background
                backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Current status hero section
                        if let lastDosage = dosageStore.dosages.last {
                            heroSection(dosage: lastDosage)
                                .offset(y: animateCards ? 0 : 50)
                                .opacity(animateCards ? 1 : 0)
                        } else {
                            noRecordsView()
                                .offset(y: animateCards ? 0 : 50)
                                .opacity(animateCards ? 1 : 0)
                        }
                        
                        // Recovery timeline
                        GlassCard {
                            RecoveryTimelineCard(dosages: dosageStore.dosages)
                        }
                        .padding(.horizontal)
                        .offset(y: animateCards ? 0 : 70)
                        .opacity(animateCards ? 1 : 0)
                        
                        // Usage patterns
                        GlassCard {
                            UsageGraphCard(dosages: dosageStore.dosages)
                        }
                        .padding(.horizontal)
                        .offset(y: animateCards ? 0 : 90)
                        .opacity(animateCards ? 1 : 0)
                        
                        // Health tips
                        GlassCard {
                            TipsCard()
                        }
                        .padding(.horizontal)
                        .offset(y: animateCards ? 0 : 110)
                        .opacity(animateCards ? 1 : 0)
                        
                        // Quick actions
                        quickActionsSection()
                            .offset(y: animateCards ? 0 : 130)
                            .opacity(animateCards ? 1 : 0)
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.top, 20)
                }
                .navigationTitle("Dashboard")
                .sheet(isPresented: $showingEmergencySheet) {
                    EmergencyContactView()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                animateCards = true
            }
        }
    }
    
    @ViewBuilder
    var backgroundGradient: some View {
        let colors: [Color] = colorScheme == .dark ? 
            [Color(hex: "121212"), Color(hex: "1E1E1E")] : 
            [Color(hex: "F8F9FA"), Color(hex: "E9ECEF")]
        
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    @ViewBuilder
    func heroSection(dosage: Dosage) -> some View {
        let daysSince = Int(Date().timeIntervalSince(dosage.date) / 86400)
        let hoursSince = Int(Date().timeIntervalSince(dosage.date) / 3600) % 24
        
        VStack(spacing: 0) {
            // Recovery progress
            GlassCard {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Recovery Progress")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            Text(getPhaseName(daysSince: daysSince))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Dynamic color based on progress
                        let progressColors: [Color] = {
                            if daysSince < 7 {
                                return [.orange, .red]
                            } else if daysSince < 30 {
                                return [.yellow, .orange]
                            } else if daysSince < 90 {
                                return [.blue, .purple]
                            } else {
                                return [.green, .blue]
                            }
                        }()
                        
                        AnimatedProgressRing(
                            progress: min(Double(daysSince) / 90.0, 1.0),
                            size: 80,
                            colors: progressColors
                        )
                    }
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    HStack(spacing: 25) {
                        VStack(spacing: 8) {
                            Text("\(daysSince)")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Text("Days")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 8) {
                            Text("\(hoursSince)")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Text("Hours")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 8) {
                            Text("\(dosage.amount, specifier: "%.0f")")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Text("mg")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Phase info
                    phaseInfoView(daysSince: daysSince)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func phaseInfoView(daysSince: Int) -> some View {
        HStack(spacing: 15) {
            Image(systemName: getPhaseIcon(daysSince: daysSince))
                .font(.system(size: 30))
                .foregroundColor(getPhaseColor(daysSince: daysSince))
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(getPhaseDescription(daysSince: daysSince))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if daysSince < 90 {
                    Text("\(90 - daysSince) days until full recovery")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Recommended recovery period complete")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? 
                      Color.white.opacity(0.05) : 
                      Color.black.opacity(0.03))
        )
    }
    
    @ViewBuilder
    func noRecordsView() -> some View {
        GlassCard {
            VStack(spacing: 20) {
                Image(systemName: "clipboard")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding()
                    .background(Circle().fill(Color.blue.opacity(0.1)))
                
                Text("No Records Yet")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Use the Log tab to record health information and track your recovery journey.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    // Tab to log entry
                }) {
                    Text("Add First Record")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func quickActionsSection() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    QuickActionCard(
                        title: "Log",
                        description: "Record health info",
                        icon: "plus.circle.fill",
                        color: .blue,
                        action: {}
                    )
                    
                    QuickActionCard(
                        title: "Calculator",
                        description: "Safe dosage info",
                        icon: "function",
                        color: .purple,
                        action: {}
                    )
                    
                    QuickActionCard(
                        title: "History",
                        description: "View past records",
                        icon: "clock.fill",
                        color: .orange,
                        action: {}
                    )
                    
                    QuickActionCard(
                        title: "Resources",
                        description: "Safety information",
                        icon: "heart.text.square.fill",
                        color: .green,
                        action: {}
                    )
                }
                .padding(.horizontal)
            }
        }
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

// MARK: - Missing Components Added Here

struct RecoveryTimelineCard: View {
    let dosages: [Dosage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recovery Timeline")
                .font(.headline)
            
            let daysSinceLastUse = dosages.isEmpty ? 999 : Int(Date().timeIntervalSince(dosages.last!.date) / 86400)
            
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

struct QuickActionCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 140, height: 120)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Calendar extension for date calculations
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

// Color extension helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Preview provider
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(DosageStore())
    }
}