import SwiftUI

struct MDMAEffectsVisualizer: View {
    @State private var selectedPhase = "Peak"
    
    var body: some View {
        VStack(spacing: 30) {
            Text("MDMA Effects Visualizer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // Phase selector
            Picker("Select Phase", selection: $selectedPhase) {
                Text("Onset").tag("Onset")
                Text("Come-up").tag("Come-up")
                Text("Peak").tag("Peak")
                Text("Plateau").tag("Plateau")
                Text("Come-down").tag("Come-down")
                Text("After-effects").tag("After-effects")
                Text("None").tag("None")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // Human figures showcase
            HStack(spacing: 30) {
                MDMAStateAnimation(phase: selectedPhase, minutesSince: getMinutesForPhase(selectedPhase))
                
                // Alternative designs can be shown here
                if selectedPhase != "None" {
                    alternativeHumanFigure()
                }
            }
            .padding(.vertical, 40)
            
            // Phase information
            if selectedPhase != "None" {
                VStack(alignment: .leading, spacing: 12) {
                    Text("About this phase:")
                        .font(.headline)
                    
                    Text(getPhaseDescription())
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("Typical duration:")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text(getPhaseDuration())
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.secondary.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            Spacer()
        }
    }
    
    // Alternative human figure design using SF Symbols
    @ViewBuilder
    private func alternativeHumanFigure() -> some View {
        let symbolName = getAlternativeSymbol()
        
        VStack {
            ZStack {
                Circle()
                    .fill(getPhaseColor().opacity(0.1))
                    .frame(width: 110, height: 110)
                
                Image(systemName: symbolName)
                    .font(.system(size: 50))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(getPhaseColor(), .gray)
            }
            
            Text("Alternative style")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // Get the appropriate time range for the selected phase
    private func getMinutesForPhase(_ phase: String) -> Int {
        switch phase {
        case "Onset": return 15
        case "Come-up": return 45
        case "Peak": return 90
        case "Plateau": return 180
        case "Come-down": return 300
        case "After-effects": return 600
        default: return 0
        }
    }
    
    // Get an alternative SF Symbol for each phase
    private func getAlternativeSymbol() -> String {
        switch selectedPhase {
        case "Onset":
            return "figure.wave"
        case "Come-up":
            return "figure.step.training"
        case "Peak":
            return "figure.arms.open"
        case "Plateau":
            return "figure.disco"
        case "Come-down":
            return "figure.walk.diamond"
        case "After-effects":
            return "figure.mind.and.body"
        default:
            return "figure.stand"
        }
    }
    
    // Get phase description
    private func getPhaseDescription() -> String {
        switch selectedPhase {
        case "Onset":
            return "Initial effects begin. You may feel slightly alert, anticipatory, and notice subtle body changes."
        case "Come-up":
            return "Effects intensify. Energy increases, mood enhances, possible rushes of euphoria with occasional anxiety."
        case "Peak":
            return "Maximum effects. Strong euphoria, empathy, heightened senses, enhanced touch and music appreciation, desire to connect with others."
        case "Plateau":
            return "Effects stabilize at a high level. Continued euphoria but slightly less intense than peak, sustained energy and sociability."
        case "Come-down":
            return "Effects gradually decrease. Energy reducing, still pleasant but less intense, becoming more introspective."
        case "After-effects":
            return "Primary effects mostly gone. Fatigue, possible mood fluctuations, reflective mental state, rest needed."
        default:
            return "No active effects."
        }
    }
    
    // Get phase duration
    private func getPhaseDuration() -> String {
        switch selectedPhase {
        case "Onset":
            return "0-30 minutes after consumption"
        case "Come-up":
            return "30-60 minutes after consumption"
        case "Peak":
            return "1-2.5 hours after consumption"
        case "Plateau":
            return "2.5-4 hours after consumption"
        case "Come-down":
            return "4-6 hours after consumption"
        case "After-effects":
            return "6-24 hours after consumption"
        default:
            return "N/A"
        }
    }
    
    // Get the appropriate color based on the phase
    private func getPhaseColor() -> Color {
        switch selectedPhase {
        case "Onset": return .blue
        case "Come-up": return .purple
        case "Peak": return .pink
        case "Plateau": return .orange
        case "Come-down": return .yellow
        case "After-effects": return .gray
        default: return .gray
        }
    }
}

struct MDMAEffectsVisualizer_Previews: PreviewProvider {
    static var previews: some View {
        MDMAEffectsVisualizer()
    }
}