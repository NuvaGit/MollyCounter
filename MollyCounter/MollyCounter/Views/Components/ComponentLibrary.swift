import SwiftUI


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

// Preview for the component
struct AnimatedProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            AnimatedProgressRing(progress: 0.35, size: 100, colors: [.blue, .purple])
            AnimatedProgressRing(progress: 0.75, size: 100, colors: [.orange, .red])
            AnimatedProgressRing(progress: 1.0, size: 100, colors: [.green, .blue])
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}