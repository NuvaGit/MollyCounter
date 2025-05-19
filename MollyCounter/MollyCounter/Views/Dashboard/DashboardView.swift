import SwiftUI
import Charts

struct DashboardView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dosageStore: DosageStore
    @State private var showingEmergencySheet = false
    @State private var animateCards = false
    @State private var timeNow = Date()
    @State private var pulseSize: CGFloat = 1.0
    @State private var heartbeatSize: CGFloat = 1.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dynamic background
                backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Pulsing circle with effects
                        if let lastDosage = dosageStore.dosages.last {
                            pulseCircleView(dosage: lastDosage)
                                .offset(y: animateCards ? 0 : 50)
                                .opacity(animateCards ? 1 : 0)
                                .padding(.top, 20)
                        } else {
                            emptyStateView()
                                .offset(y: animateCards ? 0 : 50)
                                .opacity(animateCards ? 1 : 0)
                                .padding(.top, 30)
                        }
                        
                        // NEW: MDMA State Human Figure Animation
                        if let _ = dosageStore.dosages.last, isRecentDosage() {
                            mdmaStateView()
                                .offset(y: animateCards ? 0 : 60)
                                .opacity(animateCards ? 1 : 0)
                        }
                        
                        // Future Apple Watch integration teaser
                        if let _ = dosageStore.dosages.last, isRecentDosage() {
                            healthMetricsTeaserView()
                                .offset(y: animateCards ? 0 : 70)
                                .opacity(animateCards ? 1 : 0)
                        }
                        
                        // Divider with "More info" text
                        HStack {
                            VStack {
                                Divider()
                            }
                            
                            Text("More Info")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 10)
                            
                            VStack {
                                Divider()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .offset(y: animateCards ? 0 : 80)
                        .opacity(animateCards ? 1 : 0)
                        
                        // Recovery timeline card
                        if let lastDosage = dosageStore.dosages.last {
                            GlassCard {
                                RecoveryTimelineCard(dosages: dosageStore.dosages)
                            }
                            .padding(.horizontal)
                            .offset(y: animateCards ? 0 : 90)
                            .opacity(animateCards ? 1 : 0)
                        }
                        
                        // Usage graph card
                        GlassCard {
                            UsageGraphCard(dosages: dosageStore.dosages)
                        }
                        .padding(.horizontal)
                        .offset(y: animateCards ? 0 : 100)
                        .opacity(animateCards ? 1 : 0)
                        
                        // Health tips - Updated for MDMA
                        GlassCard {
                            MDMATipsCard()
                        }
                        .padding(.horizontal)
                        .offset(y: animateCards ? 0 : 110)
                        .opacity(animateCards ? 1 : 0)
                        
                        // Quick actions
                        quickActionsSection()
                            .offset(y: animateCards ? 0 : 120)
                            .opacity(animateCards ? 1 : 0)
                        
                        Spacer(minLength: 30)
                    }
                }
                .navigationTitle("Molly Counter")
                .sheet(isPresented: $showingEmergencySheet) {
                    EmergencyContactView()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                animateCards = true
            }
            
            startAnimations()
        }
        .onReceive(timer) { _ in
            timeNow = Date()
        }
    }
    
    // MARK: - Animation Control
    
    private func startAnimations() {
        let phase = getCurrentPhaseString()
        let pulseDuration = getPulseDuration(for: phase)
        let heartbeatInterval = getHeartbeatInterval(for: phase)
        
        // Start breathing animation - bigger more visible effect
        withAnimation(Animation.easeInOut(duration: pulseDuration).repeatForever(autoreverses: true)) {
            pulseSize = 1.1 // Very noticeable pulse
        }
        
        // Start heartbeat animation - run it in a loop
        func animateHeartbeat() {
            // Expand quickly
            withAnimation(.easeOut(duration: 0.2)) {
                heartbeatSize = 1.1
            }
            
            // Contract more slowly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeIn(duration: 0.4)) {
                    heartbeatSize = 1.0
                }
                
                // Schedule next heartbeat
                DispatchQueue.main.asyncAfter(deadline: .now() + heartbeatInterval) {
                    animateHeartbeat()
                }
            }
        }
        
        // Start the heartbeat loop
        animateHeartbeat()
    }
    
    // Helper function to get current phase name
    private func getCurrentPhaseString() -> String? {
        guard let lastDosage = dosageStore.dosages.last,
              isRecentDosage() else {
            return nil
        }
        
        let minutesSince = Int(timeNow.timeIntervalSince(lastDosage.date) / 60)
        let phase = getCurrentPhase(minutesSince: minutesSince)
        return phase?.name
    }
    
    // Get pulse duration based on MDMA phase
    private func getPulseDuration(for phase: String?) -> Double {
        switch phase {
        case "Peak": return 0.8     // Fast, energetic
        case "Come-up": return 1.2   // Medium-fast
        case "Plateau": return 1.5   // Medium
        case "Come-down": return 2.0 // Slower
        case "After-effects": return 3.0 // Very slow
        case "Onset": return 1.8     // Slightly elevated
        default: return 3.0          // Normal/slow
        }
    }
    
    // Get heartbeat interval based on MDMA phase
    private func getHeartbeatInterval(for phase: String?) -> Double {
        switch phase {
        case "Peak": return 0.6      // Rapid heartbeat
        case "Come-up": return 0.8   // Fast heartbeat
        case "Plateau": return 1.0   // Medium heartbeat
        case "Come-down": return 1.5 // Slower heartbeat
        case "After-effects": return 2.0 // Very slow heartbeat
        case "Onset": return 1.2     // Slightly elevated heartbeat
        default: return 2.0          // Normal heartbeat
        }
    }
    
    // MARK: - Background Gradient
    
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
    
    // MARK: - Pulse Circle View
    
    @ViewBuilder
    func pulseCircleView(dosage: Dosage) -> some View {
        let minutesSince = Int(timeNow.timeIntervalSince(dosage.date) / 60)
        let phase = getCurrentPhase(minutesSince: minutesSince)
        let (circleColor, statusColor) = getPhaseColors(minutesSince: minutesSince)
        
        VStack(spacing: 25) {
            ZStack {
                // Pulse ring - now with bigger animation
                Circle()
                    .fill(Color.clear)
                    .frame(width: 220, height: 220)
                    .overlay(
                        Circle()
                            .stroke(circleColor.opacity(0.2), lineWidth: 40)
                    )
                    .scaleEffect(pulseSize) // This now scales to 1.1 for a very visible effect
                
                // Main circle with heartbeat effect - now with bigger animation
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [circleColor.opacity(0.7), circleColor]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(heartbeatSize) // This will pulse from 1.0 to 1.1 very visibly
                    .shadow(color: circleColor.opacity(0.5), radius: 15, x: 0, y: 0)
                
                // Inner content - UPDATED
                VStack(spacing: 8) {
                    if isRecentDosage() {
                        // Show phase information for recent dosage
                        Text(phase?.name ?? "Recovery")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(formatTimeInterval(minutes: minutesSince))
                            .font(.system(size: 18, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                        
                        // Put the active status and icon inside the circle
                        VStack(spacing: 3) {
                            Circle()
                                .fill(statusColor)
                                .frame(width: 10, height: 10)
                            
                            Text("Active")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                                
                            // Add the icon based on the phase
                            Image(systemName: getPhaseSymbol(phase: phase?.name ?? "Recovery"))
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.top, 5)
                        }
                        .opacity(isRecentDosage() ? 1 : 0)
                    } else {
                        // Show recovery information for older dosage
                        let daysSince = Int(timeNow.timeIntervalSince(dosage.date) / 86400)
                        
                        Text("Day \(daysSince)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Recovery")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("\(max(0, 90 - daysSince)) days left")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
            
            // Current feelings
            if isRecentDosage(), let phase = phase {
                VStack(spacing: 8) {
                    Text("Current Effects")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    FlowLayout(
                        mode: .stack,
                        items: phase.feelings,
                        itemSpacing: 8,
                        lineSpacing: 8
                    ) { feeling in
                        Text(feeling)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(circleColor.opacity(0.15))
                            .foregroundColor(circleColor)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
            } else if !isRecentDosage() {
                VStack(spacing: 8) {
                    Text("Recovery Focus")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    let daysSince = Int(timeNow.timeIntervalSince(dosage.date) / 86400)
                    let recoveryTips = getRecoveryTips(daysSince: daysSince)
                    
                    FlowLayout(
                        mode: .stack,
                        items: recoveryTips,
                        itemSpacing: 8,
                        lineSpacing: 8
                    ) { tip in
                        Text(tip)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(circleColor.opacity(0.15))
                            .foregroundColor(circleColor)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - MDMA State View - UPDATED
    
    @ViewBuilder
    func mdmaStateView() -> some View {
        if let lastDosage = dosageStore.dosages.last {
            let minutesSince = Int(timeNow.timeIntervalSince(lastDosage.date) / 60)
            let phase = getCurrentPhase(minutesSince: minutesSince)
            
            VStack(spacing: 15) {
                Text("Current State")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                // Use rectangle shape instead of rounded rectangle
                ZStack {
                    // Background
                    Rectangle()
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    VStack(spacing: 12) {
                        // Only show the phase name and description, removed the icon as requested
                        Text(phase?.name ?? "Recovery")
                            .font(.headline)
                        
                        Text(getStateDescription(phase: phase?.name ?? "Recovery"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                    }
                    .padding()
                }
                .frame(height: 100) // Reduced height since we removed the icon
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    func emptyStateView() -> some View {
        VStack(spacing: 25) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.7)]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .frame(width: 200, height: 200)
                
                VStack(spacing: 10) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Text("No Records")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            
            Text("Add your first record to track your MDMA use")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                // Navigate to log tab
            }) {
                Text("Add Record")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .foregroundColor(.white)
            }
        }
    }
    
    @ViewBuilder
    func healthMetricsTeaserView() -> some View {
        HStack(spacing: 15) {
            MetricTeaserCard(
                title: "Heart Rate",
                value: "-- BPM",
                icon: "heart.fill",
                color: .red
            )
            
            MetricTeaserCard(
                title: "Body Temp",
                value: "-- °C",
                icon: "thermometer",
                color: .orange
            )
            
            MetricTeaserCard(
                title: "Hydration",
                value: "-- %",
                icon: "drop.fill",
                color: .blue
            )
        }
        .padding(.horizontal)
        .padding(.top, 10)
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
                        description: "Record MDMA use",
                        icon: "plus.circle.fill",
                        color: .blue,
                        action: {}
                    )
                    
                    QuickActionCard(
                        title: "Emergency",
                        description: "Contact resources",
                        icon: "phone.fill",
                        color: .red,
                        action: {
                            showingEmergencySheet = true
                        }
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
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func isRecentDosage() -> Bool {
        guard let lastDosage = dosageStore.dosages.last else { return false }
        return timeNow.timeIntervalSince(lastDosage.date) < 24 * 3600 // 24 hours
    }
    
    func getPhaseColors(minutesSince: Int) -> (main: Color, status: Color) {
        if minutesSince < 30 { // Onset - Updated time ranges for MDMA
            return (.blue, .blue)
        } else if minutesSince < 60 { // Come-up
            return (.purple, .purple)
        } else if minutesSince < 150 { // Peak
            return (.pink, .pink)
        } else if minutesSince < 240 { // Plateau
            return (.orange, .orange)
        } else if minutesSince < 360 { // Come-down
            return (.yellow, .yellow)
        } else if minutesSince < 1440 { // After-effects
            return (.gray, .gray)
        } else { // Recovery
            let daysSince = minutesSince / 1440
            if daysSince < 7 {
                return (.orange, .orange)
            } else if daysSince < 30 {
                return (.yellow, .yellow)
            } else if daysSince < 90 {
                return (.blue, .blue)
            } else {
                return (.green, .green)
            }
        }
    }
    
    // Helper function to get the SF Symbol based on the phase
    func getPhaseSymbol(phase: String) -> String {
        switch phase {
        case "Onset":
            return "figure.stand"
        case "Come-up":
            return "figure.walk"
        case "Peak":
            return "figure.dance"
        case "Plateau":
            return "figure.socialdance"
        case "Come-down":
            return "figure.walk.motion"
        case "After-effects":
            return "figure.rest"
        default:
            return "figure.stand"
        }
    }
    
    // Helper function to get the description based on phase
    func getStateDescription(phase: String) -> String {
        switch phase {
        case "Onset":
            return "Starting to feel initial effects"
        case "Come-up":
            return "Energy increasing, euphoria beginning"
        case "Peak":
            return "Maximum euphoria and energy"
        case "Plateau":
            return "Sustained effects with stable energy"
        case "Come-down":
            return "Effects gradually reducing"
        case "After-effects":
            return "Tired, recovery beginning"
        default:
            return "No active effects"
        }
    }
    
    func getRecoveryTips(daysSince: Int) -> [String] {
        if daysSince < 7 {
            return ["Rest", "Hydrate", "5-HTP supplements", "Nutritious food", "Avoid alcohol"]
        } else if daysSince < 30 {
            return ["Exercise", "Meditation", "Sleep hygiene", "Balanced diet"]
        } else if daysSince < 90 {
            return ["Regular exercise", "Social support", "Healthy habits"]
        } else {
            return ["Maintain health", "Long-term wellness", "Balanced lifestyle"]
        }
    }
    
    func getCurrentPhase(minutesSince: Int) -> EffectPhase? {
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
    
    func formatTimeInterval(minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        
        if hours > 0 {
            return String(format: "%dh %02dm", hours, mins)
        } else {
            return String(format: "%d min", mins)
        }
    }
}

// MARK: - Metric Teaser Card
struct MetricTeaserCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - MDMA-specific tips card
struct MDMATipsCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("MDMA Safety Tips")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                TipRow(icon: "drop.fill", text: "Drink ~500ml water per hour, not more")
                TipRow(icon: "thermometer", text: "Take breaks from dancing to cool down")
                TipRow(icon: "clock.arrow.2.circlepath", text: "Wait 3+ months between uses")
                TipRow(icon: "pills.fill", text: "Consider pre/post-loading supplements")
                TipRow(icon: "brain.head.profile", text: "Lower doses reduce neurotoxicity risk")
            }
        }
    }
}

// MARK: - Glass Card Component
struct GlassCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(colorScheme == .dark ? 
                              Color.white.opacity(0.07) : 
                              Color.white.opacity(0.9))
                    
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            colorScheme == .dark ?
                            Color.white.opacity(0.1) :
                            Color.black.opacity(0.05),
                            lineWidth: 1
                        )
                }
                .shadow(color: colorScheme == .dark ? 
                        Color.black.opacity(0.2) : 
                        Color.black.opacity(0.1),
                        radius: 10, x: 0, y: 5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

// MARK: - Flow Layout for tags
struct FlowLayout<T: Hashable, Content: View>: View {
    enum Mode {
        case stack
        case scrollable
    }
    
    let mode: Mode
    let items: [T]
    let itemSpacing: CGFloat
    let lineSpacing: CGFloat
    @ViewBuilder let viewForItem: (T) -> Content
    
    var body: some View {
        if mode == .stack {
            VStack(alignment: .leading, spacing: lineSpacing) {
                ForEach(getRows(), id: \.self) { row in
                    HStack(spacing: itemSpacing) {
                        ForEach(row, id: \.self) { item in
                            viewForItem(item)
                        }
                    }
                }
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: itemSpacing) {
                    ForEach(items, id: \.self) { item in
                        viewForItem(item)
                    }
                }
            }
        }
    }
    
    private func getRows() -> [[T]] {
        var rows: [[T]] = [[]]
        var currentRowWidth: CGFloat = 0
        let screenWidth = UIScreen.main.bounds.width - 40 // Adjusting for container padding
        
        for item in items {
            // This is a rough estimate of width, ideally we would measure the actual rendered width
            let label = String(describing: item)
            let estimatedWidth = CGFloat(label.count) * 10 + 40 // Rough estimate: 10pt per character + padding
            
            if currentRowWidth + estimatedWidth > screenWidth {
                // Start a new row
                rows.append([item])
                currentRowWidth = estimatedWidth + itemSpacing
            } else {
                // Add to the current row
                rows[rows.count - 1].append(item)
                currentRowWidth += estimatedWidth + itemSpacing
            }
        }
        
        return rows
    }
}

// MARK: - Quick Action Card
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
            .frame(width: 120, height: 110)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Recovery Timeline Component
struct RecoveryTimelineCard: View {
    let dosages: [Dosage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("MDMA Recovery Timeline")
                .font(.headline)
            
            let daysSinceLastUse = dosages.isEmpty ? 999 : Int(Date().timeIntervalSince(dosages.last!.date) / 86400)
            
            VStack(spacing: 15) {
                RecoveryMilestone(
                    name: "7 Days",
                    description: "Serotonin begins to replenish",
                    achieved: daysSinceLastUse >= 7,
                    daysLeft: max(0, 7 - daysSinceLastUse)
                )
                
                RecoveryMilestone(
                    name: "30 Days", 
                    description: "Mood and energy significantly improve",
                    achieved: daysSinceLastUse >= 30,
                    daysLeft: max(0, 30 - daysSinceLastUse)
                )
                
                RecoveryMilestone(
                    name: "90 Days",
                    description: "Recommended time between MDMA uses",
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

// MARK: - Usage Graph Component
struct UsageGraphCard: View {
    let dosages: [Dosage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("MDMA Usage Patterns")
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

// MARK: - Tips Component
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

// MARK: - Calendar Extensions
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

// MARK: - Color Extension
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

// MARK: - Preview Provider
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(DosageStore())
    }
}