import SwiftUI

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

struct ActionButton: View {
    var title: String
    var icon: String
    var gradient: LinearGradient
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                Text(title)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(gradient)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.3), 
                    radius: 10, x: 0, y: 5)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct AnimatedProgressRing: View {
    let progress: Double
    let strokeWidth: CGFloat
    let gradient: LinearGradient
    let size: CGFloat
    
    init(progress: Double, size: CGFloat = 80, strokeWidth: CGFloat = 8, 
         colors: [Color] = [.blue, .purple]) {
        self.progress = min(max(progress, 0), 1)
        self.size = size
        self.strokeWidth = strokeWidth
        self.gradient = LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
    }
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(lineWidth: strokeWidth)
                .opacity(0.1)
                .foregroundColor(Color.gray)
            
            // Progress ring
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
                .fill(gradient)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut(duration: 1.0), value: progress)
            
            // Text percentage
            Text("\(Int(progress * 100))%")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
        }
        .frame(width: size, height: size)
    }
}