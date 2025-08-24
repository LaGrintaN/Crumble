//
//  CrumbleApp.swift
//  Crumble
//
//  Created by Nicole Rosolin on 24/08/25.
//

import SwiftUI

@main
struct CrumbleApp: App {
    var body: some Scene {
        WindowGroup {
            AppContentView()
        }
    }
}

struct AppContentView: View {
    @State private var showSplash = true
    @StateObject private var supabaseManager = SupabaseManager.shared
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(2)
            } else if supabaseManager.isAuthenticated {
                ContentView()
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(0)
            } else {
                LoginView()
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(1)
            }
        }
        .onAppear {
            // Hide splash screen after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showSplash = false
                }
            }
        }
    }
}
