import SwiftUI

struct EmergencyContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("emergencyContact") private var emergencyContact = ""
    @AppStorage("emergencyContactName") private var emergencyContactName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Emergency Contact")) {
                    TextField("Name", text: $emergencyContactName)
                        .autocapitalization(.words)
                    
                    TextField("Phone Number", text: $emergencyContact)
                        .keyboardType(.phonePad)
                    
                    if !emergencyContact.isEmpty {
                        Button(action: {
                            if let url = URL(string: "tel:\(emergencyContact.filter { $0.isNumber })") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Label("Call Emergency Contact", systemImage: "phone.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section(header: Text("Emergency Resources")) {
                    EmergencyResourceRow(
                        name: "Emergency Services",
                        number: "911",
                        icon: "phone.fill",
                        color: .red
                    )
                    
                    EmergencyResourceRow(
                        name: "Poison Control",
                        number: "1-800-222-1222",
                        icon: "cross.case.fill",
                        color: .blue
                    )
                    
                    EmergencyResourceRow(
                        name: "Crisis Text Line",
                        number: "Text HOME to 741741",
                        icon: "message.fill",
                        color: .green
                    )
                }
                
                Section(header: Text("Warning Signs - Seek Help Immediately")) {
                    WarningSignRow(sign: "High fever or overheating")
                    WarningSignRow(sign: "Severe headache or dizziness")
                    WarningSignRow(sign: "Irregular heartbeat")
                    WarningSignRow(sign: "Excessive sweating/chills")
                    WarningSignRow(sign: "Confusion or disorientation")
                }
            }
            .navigationTitle("Emergency Contact")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct EmergencyResourceRow: View {
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

struct WarningSignRow: View {
    let sign: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(sign)
        }
    }
}

struct EmergencyContactView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContactView()
    }
}