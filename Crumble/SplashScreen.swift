import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var backgroundOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background
            Color.crumblePrimary
                .ignoresSafeArea()
                .opacity(backgroundOpacity)
            
            // Logo
            VStack(spacing: DesignSystem.Spacing.lg) {
                // Logo
                Image("logo 1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 216, height: 216) // 120 * 1.8 = 216
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.33) // 1/3 from top
        }
        .onAppear {
            startAnimation()
        }
        .onChange(of: isActive) { _, newValue in
            if newValue {
                // Navigate to main content after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // This will be handled by the parent view
                }
            }
        }
    }
    
    private func startAnimation() {
        // Start with background fade in
        withAnimation(.easeInOut(duration: 0.8)) {
            backgroundOpacity = 1
        }
        
        // Logo animation with slight delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)) {
                logoScale = 1.0
                logoOpacity = 1
            }
        }
        
        // Set active after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isActive = true
            }
        }
    }
}

#Preview {
    SplashScreen()
}
