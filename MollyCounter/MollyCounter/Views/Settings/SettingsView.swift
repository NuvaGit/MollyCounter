import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("emergencyContact") private var emergencyContact = ""
    @AppStorage("emergencyContactName") private var emergencyContactName = ""
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("appTheme") private var appTheme = "system"
    @State private var showingEmergencyView = false
    @State private var showingResetAlert = false
    @EnvironmentObject var dosageStore: DosageStore
    
    // MDMA-specific symptoms (same list as in CheckInView)
    let possibleSymptoms = [
        "Jaw clenching", "Eye wiggles", "Increased energy", 
        "Euphoria", "Enhanced touch", "Sweating", 
        "Thirst", "Increased heartrate", "Anxiety",
        "Enhanced music", "Talkativeness", "Empathy",
        "Body warmth", "Heightened senses", "Love feelings",
        "Light sensitivity", "Blurry vision", "Dizziness",
        "Headache", "Nausea", "Cold extremities"
    ]
    
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
                            Text("Sign in coming soon")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
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
                    Button(action: {
                        showingEmergencyView = true
                    }) {
                        HStack {
                            Label {
                                Text("Emergency Contact Settings")
                            } icon: {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.red)
                            }
                            
                            Spacer()
                            
                            if !emergencyContact.isEmpty {
                                Text(emergencyContactName.isEmpty ? emergencyContact : emergencyContactName)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Not Set")
                                    .foregroundColor(.secondary)
                            }
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
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
                    
                    // NEW: Symptom Guide navigation link
                    NavigationLink(destination: SymptomInfoListView(possibleSymptoms: possibleSymptoms)) {
                        Label {
                            Text("Symptom Guide")
                        } icon: {
                            Image(systemName: "waveform.path.ecg.rectangle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // NEW: Effects Visualizer link
                    NavigationLink(destination: MDMAEffectsVisualizer()) {
                        Label {
                            Text("Effects Visualizer")
                        } icon: {
                            Image(systemName: "figure.dance")
                                .foregroundColor(.pink)
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
            .sheet(isPresented: $showingEmergencyView) {
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(DosageStore())
    }
}