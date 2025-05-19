import SwiftUI

struct MDMAStateAnimation: View {
    let phase: String
    let minutesSince: Int
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            ZStack {
                // Background glow effect
                Circle()
                    .fill(getPhaseColor().opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                
                // Human figure with animation
                Image(systemName: getPhaseSymbol())
                    .font(.system(size: 60))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(getPhaseColor())
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                    .rotationEffect(getRotationEffect())
                    .offset(y: getYOffset())
            }
            
            Text(getStateDescription())
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(width: 120)
        }
        .onAppear {
            withAnimation(getAnimation()) {
                isAnimating = true
            }
        }
    }
    
    // Get the appropriate SF Symbol based on the phase
    private func getPhaseSymbol() -> String {
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
    
    // Get the appropriate color based on the phase
    private func getPhaseColor() -> Color {
        switch phase {
        case "Onset":
            return .blue
        case "Come-up":
            return .purple
        case "Peak":
            return .pink
        case "Plateau":
            return .orange
        case "Come-down":
            return .yellow
        case "After-effects":
            return .gray
        default:
            return .gray
        }
    }
    
    // Get the appropriate animation based on the phase
    private func getAnimation() -> Animation {
        switch phase {
        case "Peak":
            // Fast, energetic animation for dancing
            return Animation.easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true)
        case "Come-up", "Plateau":
            // Medium animation for high energy
            return Animation.easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
        case "Come-down":
            // Slower animation for reduced energy
            return Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        case "After-effects":
            // Very slow animation for tired state
            return Animation.easeInOut(duration: 2.5)
                .repeatForever(autoreverses: true)
        default:
            // Standard animation for other states
            return Animation.easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
        }
    }
    
    // Get rotation effect based on phase
    private func getRotationEffect() -> Angle {
        switch phase {
        case "Peak":
            return Angle(degrees: isAnimating ? 5 : -5)
        case "Come-up", "Plateau":
            return Angle(degrees: isAnimating ? 3 : -3)
        case "Come-down":
            return Angle(degrees: isAnimating ? 1 : -1)
        default:
            return Angle(degrees: 0)
        }
    }
    
    // Get Y-axis offset for bouncing effect
    private func getYOffset() -> CGFloat {
        switch phase {
        case "Peak":
            return isAnimating ? -5 : 0
        case "Come-up", "Plateau":
            return isAnimating ? -3 : 0
        case "Come-down":
            return isAnimating ? -1 : 0
        case "After-effects":
            return isAnimating ? 1 : 0
        default:
            return 0
        }
    }
    
    // Get descriptive text for the current state
    private func getStateDescription() -> String {
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
}

// Do NOT include the extension here - we'll add it directly to DashboardView