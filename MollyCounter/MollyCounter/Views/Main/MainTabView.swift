import SwiftUI

class TabSelection: ObservableObject {
    @Published var selectedTab = 0
}

struct MainTabView: View {
    @StateObject private var tabSelection = TabSelection()
    
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection.selectedTab) {
                DashboardView()
                    .gesture(swipeGesture(for: tabSelection.selectedTab))
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                    .tag(0)
                
                LogEntryView()
                    .gesture(swipeGesture(for: tabSelection.selectedTab))
                    .tabItem {
                        Label("Log", systemImage: "plus.circle.fill")
                    }
                    .tag(1)
                
                HistoryView()
                    .gesture(swipeGesture(for: tabSelection.selectedTab))
                    .tabItem {
                        Label("History", systemImage: "clock.fill")
                    }
                    .tag(2)
                
                SettingsView()
                    .gesture(swipeGesture(for: tabSelection.selectedTab))
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(3)
            }
            .accentColor(.purple)
        }
        .environmentObject(tabSelection)
    }
    
    private func swipeGesture(for tabIndex: Int) -> some Gesture {
        let maxIndex = 3 // Number of tabs minus 1
        
        // Swipe left gesture (for next tab)
        let swipeLeft = DragGesture()
            .onEnded { gesture in
                // If we're swiping left with enough distance
                if gesture.translation.width < -50 && tabIndex < maxIndex {
                    withAnimation {
                        tabSelection.selectedTab = tabIndex + 1
                    }
                }
            }
        
        // Swipe right gesture (for previous tab)
        let swipeRight = DragGesture()
            .onEnded { gesture in
                // If we're swiping right with enough distance
                if gesture.translation.width > 50 && tabIndex > 0 {
                    withAnimation {
                        tabSelection.selectedTab = tabIndex - 1
                    }
                }
            }
        
        // Combine both gestures
        return swipeLeft.simultaneously(with: swipeRight)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(DosageStore())
    }
}