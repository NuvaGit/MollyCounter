import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("useBiometricAuth") private var useBiometricAuth = false
    @AppStorage("emergencyContact") private var emergencyContact = ""
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("appTheme") private var appTheme = "system"
    @State private var showingEmergencySheet = false
    @State private var showingResetAlert = false
    @EnvironmentObject var dosageStore: DosageStore
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("Guest User")
                                .font(.headline)
                            Text("Sign in for personalized experience")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Future Sign In Action
                        }) {
                            Text("Sign In")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $appTheme) {
                        Text("System").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: appTheme) { newValue in
                        setAppearance(to: newValue)
                    }
                }
                
                Section(header: Text("Security")) {
                    Toggle(isOn: $useBiometricAuth) {
                        Label {
                            Text("Use Face/Touch ID")
                        } icon: {
                            Image(systemName: "faceid")
                                .foregroundColor(.blue)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                Section(header: Text("Notifications")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Label {
                            Text("Enable Notifications")
                        } icon: {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                Section(header: Text("Emergency Contact")) {
                    HStack {
                        Label {
                            Text("Phone Number")
                        } icon: {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        TextField("Add Emergency Contact", text: $emergencyContact)
                            .keyboardType(.phonePad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Button(action: {
                        showingEmergencySheet = true
                    }) {
                        Label("View Emergency Resources", systemImage: "list.bullet")
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("Health & Safety")) {
                    NavigationLink(destination: SafetyInfoView()) {
                        Label {
                            Text("Harm Reduction Resources")
                        } icon: {
                            Image(systemName: "heart.text.square.fill")
                                .foregroundColor(.purple)
                        }
                    }
                    
                    NavigationLink(destination: DosageCalculatorView()) {
                        Label {
                            Text("Dosage Calculator")
                        } icon: {
                            Image(systemName: "pills.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Section(header: Text("Data Management")) {
                    Button(role: .destructive, action: {
                        showingResetAlert = true
                    }) {
                        Label("Reset All Data", systemImage: "trash.fill")
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Label {
                            Text("Version")
                        } icon: {
                            Image(systemName: "gear")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingEmergencySheet) {
                EmergencyContactView()
            }
            .alert("Reset All Data?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    dosageStore.dosages = []
                    dosageStore.saveDosages()
                }
            } message: {
                Text("This will permanently delete all your records. This action cannot be undone.")
            }
        }
    }
    
    func setAppearance(to theme: String) {
        #if os(iOS)
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene else { return }
        guard let window = windowScene.windows.first else { return }
        
        window.overrideUserInterfaceStyle = {
            switch theme {
            case "light": return .light
            case "dark": return .dark
            default: return .unspecified
            }
        }()
        #endif
    }
}

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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(DosageStore())
    }
}