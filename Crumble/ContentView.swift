//
//  ContentView.swift
//  Crumble
//
//  Created by Nicole Rosolin on 24/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var supabaseManager = SupabaseManager.shared
    
    var body: some View {
        ZStack {
            // Background
            Color.crumbleBackground
                .ignoresSafeArea()
            
            // Debug Test
            VStack {
                Text("Debug Test")
                    .font(.rubikTitle)
                    .foregroundColor(.crumblePrimary)
                
                Text("Supabase URL: \(SupabaseConfig.supabaseURL)")
                    .font(.rubikBody)
                    .foregroundColor(.crumbleTextSecondary)
                
                Text("Config Valid: \(SupabaseConfig.isValid ? "Yes" : "No")")
                    .font(.rubikBody)
                    .foregroundColor(.crumbleTextSecondary)
            }
            .onAppear {
                print("🔍 ContentView appeared")
                print("🔍 Supabase URL: \(SupabaseConfig.supabaseURL)")
                print("🔍 Config Valid: \(SupabaseConfig.isValid)")
            }
            
            VStack(spacing: DesignSystem.Spacing.lg) {
                // Header with Logout
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            await supabaseManager.signOut()
                        }
                    }) {
                        Text("Logout")
                            .font(.rubikSubheadline)
                            .foregroundColor(.crumblePrimary)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                            .padding(.vertical, DesignSystem.Spacing.sm)
                            .background(Color.crumblePrimary.opacity(0.1))
                            .cornerRadius(DesignSystem.CornerRadius.small)
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.top, DesignSystem.Spacing.md)
                
                // Logo
                DesignSystem.Logo.splash()
                    .padding(.top, DesignSystem.Spacing.xl)
                
                // Welcome Message
                if supabaseManager.currentUser != nil {
                    Text("Welcome back!")
                        .font(.rubikTitle)
                        .foregroundColor(.crumblePrimary)
                    
                    Text("You are successfully signed in!")
                        .font(.rubikBody)
                        .foregroundColor(.crumbleTextSecondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Crumble")
                        .font(.rubikLargeTitle)
                        .foregroundColor(.crumblePrimary)
                    
                    Text("Your Design System is Ready!")
                        .font(.rubikTitle2)
                        .foregroundColor(.crumbleTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Feature Cards
                VStack(spacing: DesignSystem.Spacing.md) {
                    DesignCard(
                        title: "Rubik Fonts",
                        description: "Beautiful typography with variable weights",
                        icon: "textformat",
                        color: .crumblePrimary
                    )
                    
                    DesignCard(
                        title: "Custom Colors",
                        description: "Primary and secondary color palette",
                        icon: "paintpalette",
                        color: .crumbleSecondary
                    )
                    
                    DesignCard(
                        title: "Consistent Spacing",
                        description: "Standardized spacing system",
                        icon: "ruler",
                        color: .crumblePrimary
                    )
                    
                    DesignCard(
                        title: "Logo System",
                        description: "Multiple sizes and variations",
                        icon: "photo",
                        color: .crumbleSecondary
                    )
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                
                // Logo Showcase
                VStack(spacing: DesignSystem.Spacing.md) {
                    Text("Logo Variations")
                        .font(.rubikTitle3)
                        .foregroundColor(.crumbleTextPrimary)
                    
                    HStack(spacing: DesignSystem.Spacing.lg) {
                        VStack {
                            DesignSystem.Logo.header()
                            Text("Header")
                                .font(.rubikCaption)
                                .foregroundColor(.crumbleTextSecondary)
                        }
                        
                        VStack {
                            DesignSystem.Logo.icon()
                            Text("Icon")
                                .font(.rubikCaption)
                                .foregroundColor(.crumbleTextSecondary)
                        }
                        
                        VStack {
                            DesignSystem.Logo.small()
                            Text("Small")
                                .font(.rubikCaption2)
                                .foregroundColor(.crumbleTextSecondary)
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                
                Spacer()
            }
        }
    }
}

// MARK: - Design Card Component
struct DesignCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            // Content
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(.rubikHeadline)
                    .foregroundColor(.crumbleTextPrimary)
                
                Text(description)
                    .font(.rubikBody)
                    .foregroundColor(.crumbleTextSecondary)
            }
            
            Spacer()
        }
        .padding(DesignSystem.Spacing.md)
        .background(Color.crumbleBackground)
        .cornerRadius(DesignSystem.CornerRadius.medium)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    ContentView()
}
