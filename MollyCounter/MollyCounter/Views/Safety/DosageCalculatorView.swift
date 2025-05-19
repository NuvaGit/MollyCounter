import SwiftUI

struct DosageCalculatorView: View {
    @State private var weight: Double = 70
    @State private var experience = "beginner"
    @State private var showResult = false
    @State private var recommendedDosage: ClosedRange<Double> = 0...0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Content
            ScrollView {
                VStack(spacing: 25) {
                    // Header image
                    Image(systemName: "pills.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.purple)
                        .padding()
                        .background(Circle().fill(Color.purple.opacity(0.1)))
                    
                    Text("Dosage Calculator")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .padding(.bottom, 30)
                    
                    GlassCard {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Your Weight")
                                .font(.headline)
                            
                            HStack {
                                Text("\(Int(weight)) kg")
                                    .fontWeight(.bold)
                                    .frame(width: 60, alignment: .leading)
                                
                                Slider(value: $weight, in: 40...120, step: 1)
                                    .accentColor(.purple)
                            }
                            
                            Text("Experience Level")
                                .font(.headline)
                                .padding(.top, 10)
                            
                            Picker("Experience", selection: $experience) {
                                Text("First time").tag("first")
                                Text("Beginner").tag("beginner")
                                Text("Experienced").tag("experienced")
                            }
                            .pickerStyle(.segmented)
                            
                            Button(action: {
                                calculateDosage()
                                withAnimation(.spring()) {
                                    showResult = true
                                }
                            }) {
                                HStack {
                                    Image(systemName: "function")
                                    Text("Calculate Safe Dosage")
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        colors: [.purple, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                            .padding(.top, 20)
                        }
                    }
                    .padding(.horizontal)
                    
                    if showResult {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Recommended Dosage")
                                    .font(.headline)
                                
                                HStack(alignment: .top, spacing: 20) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Low Range")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text("\(Int(recommendedDosage.lowerBound)) mg")
                                            .font(.system(size: 22, weight: .bold, design: .rounded))
                                    }
                                    
                                    Divider()
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("High Range")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text("\(Int(recommendedDosage.upperBound)) mg")
                                            .font(.system(size: 22, weight: .bold, design: .rounded))
                                    }
                                }
                                
                                Text("Safety Note")
                                    .font(.headline)
                                    .padding(.top, 10)
                                
                                Text("Always start with the lower end of the range. Wait at least 3 months between uses to allow for recovery.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle("Dosage Calculator")
    }
    
    func calculateDosage() {
        // Note: These are harm reduction guidelines
        switch experience {
        case "first":
            recommendedDosage = (weight * 0.8)...(weight * 1.0)
        case "beginner":
            recommendedDosage = (weight * 1.0)...(weight * 1.3)
        case "experienced":
            recommendedDosage = (weight * 1.2)...(weight * 1.5)
        default:
            recommendedDosage = (weight * 1.0)...(weight * 1.3)
        }
        
        // Cap maximum dosage (harm reduction)
        if recommendedDosage.upperBound > 150 {
            recommendedDosage = recommendedDosage.lowerBound...150
        }
    }
}

// GlassCard component for the DosageCalculatorView
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

struct DosageCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        DosageCalculatorView()
    }
}