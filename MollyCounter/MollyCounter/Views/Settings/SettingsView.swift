import SwiftUI

struct SettingsView: View {
    @AppStorage("useBiometricAuth") private var useBiometricAuth = false
    @AppStorage("emergencyContact") private var emergencyContact = ""
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @State private var showingResetAlert = false
    @EnvironmentObject var dosageStore: DosageStore
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    // Placeholder for future authentication
                    NavigationLink(destination: Text("Account Settings Coming Soon")) {
                        Label("Account", systemImage: "person.fill")
                    }
                    
                    Toggle(isOn: $useBiometricAuth) {
                        Label("Use Face/Touch ID", systemImage: "faceid")
                    }
                }
                
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Enable Notifications", systemImage: "bell.fill")
                    }
                    
                    Toggle(isOn: $darkModeEnabled) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    
                    HStack {
                        Label("Emergency Contact", systemImage: "phone.fill")
                        Spacer()
                        TextField("Phone Number", text: $emergencyContact)
                            .keyboardType(.phonePad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Health & Safety Information")) {
                    NavigationLink(destination: SafetyInfoView()) {
                        Label("Harm Reduction Resources", systemImage: "heart.text.square.fill")
                    }
                    
                    NavigationLink(destination: DosageCalculatorView()) {
                        Label("Dosage Calculator", systemImage: "pills.fill")
                    }
                    
                    NavigationLink(destination: InteractionCheckerView()) {
                        Label("Drug Interaction Checker", systemImage: "exclamationmark.shield.fill")
                    }
                }
                
                Section(header: Text("Data Management")) {
                    Button(role: .destructive, action: {
                        showingResetAlert = true
                    }) {
                        Label("Reset All Data", systemImage: "trash.fill")
                    }
                    .alert("Reset All Data?", isPresented: $showingResetAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Reset", role: .destructive) {
                            // Clear all data
                            dosageStore.dosages = []
                            dosageStore.saveDosages()
                        }
                    } message: {
                        Text("This will permanently delete all your records. This action cannot be undone.")
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Label("Version", systemImage: "gear")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink(destination: Text("Privacy Policy would go here")) {
                        Label("Privacy Policy", systemImage: "lock.shield.fill")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// Placeholder views for future implementation
struct DosageCalculatorView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "pills.fill")
                .font(.system(size: 60))
                .foregroundColor(.purple)
            
            Text("Dosage Calculator")
                .font(.title)
            
            Text("Coming soon! This feature will help calculate safer dosage based on weight, experience level, and time since last use.")
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("Dosage Calculator")
    }
}

struct InteractionCheckerView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.shield.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Interaction Checker")
                .font(.title)
            
            Text("Coming soon! This feature will help identify potential dangerous interactions with other substances.")
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("Interaction Checker")
    }
}