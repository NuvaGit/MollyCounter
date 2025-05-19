import SwiftUI

@main
struct MollyCounterApp: App {
    @StateObject private var dosageStore = DosageStore()
    @AppStorage("appTheme") private var appTheme = "system"
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        // Set appearance based on stored theme
        setInitialAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(dosageStore)
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        setAppearance(to: appTheme)
                    }
                }
        }
    }
    
    func setInitialAppearance() {
        #if os(iOS)
        setAppearance(to: appTheme)
        #endif
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