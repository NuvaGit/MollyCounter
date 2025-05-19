

import SwiftUI

struct SafetyInfoView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    InfoSection(
                        title: "Harm Reduction",
                        content: "This app is designed to help you track and monitor substance use for harm reduction purposes. It is not an endorsement of drug use."
                    )
                    
                    InfoSection(
                        title: "Safe Use Guidelines",
                        content: "• Wait at least 3 months between uses\n• Start with lower doses\n• Stay hydrated but don't overhydrate\n• Take breaks when dancing\n• Be aware of drug interactions\n• Test your substances"
                    )
                    
                    InfoSection(
                        title: "Warning Signs",
                        content: "Seek medical help immediately if experiencing:\n• High fever\n• Severe headache\n• Irregular heartbeat\n• Difficulty breathing\n• Confusion or disorientation"
                    )
                    
                    InfoSection(
                        title: "Resources",
                        content: "• DanceSafe: dancesafe.org\n• Erowid: erowid.org\n• MAPS: maps.org\n• TripSit: tripsit.me"
                    )
                    
                    InfoSection(
                        title: "Emergency Contacts",
                        content: "• Emergency: 911\n• Poison Control: 1-800-222-1222\n• SAMHSA Helpline: 1-800-662-4357"
                    )
                }
                .padding()
            }
            .navigationTitle("Safety Information")
        }
    }
}

struct InfoSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.purple)
            
            Text(content)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SafetyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SafetyInfoView()
    }
}