

import SwiftUI

@main
struct MollyCounterApp: App {
    @StateObject private var dosageStore = DosageStore()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(dosageStore)
        }
    }
}