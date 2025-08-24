import SwiftUI

struct LoginView: View {
    @StateObject private var supabaseManager = SupabaseManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            // Background
            Color.crumbleBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xl) {
                    // Logo and Title
                    VStack(spacing: DesignSystem.Spacing.md) {
                        DesignSystem.Logo.header()
                        
                        Text("Welcome to Crumble")
                            .font(.rubikTitle)
                            .foregroundColor(.crumbleTextPrimary)
                        
                        Text("Sign in to continue")
                            .font(.rubikBody)
                            .foregroundColor(.crumbleTextSecondary)
                    }
                    .padding(.top, DesignSystem.Spacing.xxl)
                    
                    // Form
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        // Email Field
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            Text("Email")
                                .font(.rubikSubheadline)
                                .foregroundColor(.crumbleTextPrimary)
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            Text("Password")
                                .font(.rubikSubheadline)
                                .foregroundColor(.crumbleTextPrimary)
                            
                            HStack {
                                if showPassword {
                                    TextField("Enter your password", text: $password)
                                        .textFieldStyle(CustomTextFieldStyle())
                                        .textContentType(.password)
                                } else {
                                    SecureField("Enter your password", text: $password)
                                        .textFieldStyle(CustomTextFieldStyle())
                                        .textContentType(.password)
                                }
                                
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.crumbleTextSecondary)
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                        
                        // Error Message
                        if let errorMessage = supabaseManager.errorMessage {
                            Text(errorMessage)
                                .font(.rubikCaption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, DesignSystem.Spacing.md)
                        }
                        
                        // Action Button
                        Button(action: {
                            Task {
                                if isSignUp {
                                    await supabaseManager.signUp(email: email, password: password)
                                } else {
                                    await supabaseManager.signIn(email: email, password: password)
                                }
                            }
                        }) {
                            HStack {
                                if supabaseManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text(isSignUp ? "Sign Up" : "Sign In")
                                        .font(.rubikHeadline)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.crumblePrimary)
                            .cornerRadius(DesignSystem.CornerRadius.medium)
                        }
                        .disabled(email.isEmpty || password.isEmpty || supabaseManager.isLoading)
                        .opacity((email.isEmpty || password.isEmpty || supabaseManager.isLoading) ? 0.6 : 1.0)
                        
                        // Toggle Sign Up/Sign In
                        Button(action: { isSignUp.toggle() }) {
                            Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                                .font(.rubikSubheadline)
                                .foregroundColor(.crumblePrimary)
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    
                    Spacer(minLength: DesignSystem.Spacing.xl)
                }
            }
        }
        .onAppear {
            Task {
                await supabaseManager.checkCurrentUser()
            }
        }
    }
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(DesignSystem.Spacing.md)
            .background(Color.white)
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(Color.crumbleTextSecondary.opacity(0.3), lineWidth: 1)
            )
            .font(.rubikBody)
    }
}

#Preview {
    LoginView()
}
