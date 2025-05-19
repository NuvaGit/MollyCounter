//
//  ContentView.swift
//  MollyCounter
//
//  Created by Jack Neilan on 19/05/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .environmentObject(DosageStore())
}