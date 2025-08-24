import SwiftUI

enum AuthFeatures {
    static let socialLoginEnabled = false
}

struct LoginView: View {
    @StateObject private var supabaseManager = SupabaseManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordStep = false
    @State private var isCreatePasswordStep = false
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var isNewUser = false
    
    // Toast state
    @State private var showToast = false
    @State private var toastText = ""
    @State private var toastStyle: ToastStyle = .success
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(hex: "7233F5")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Logo Section
                    VStack(spacing: 16) {
                        Image("logo 1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 109, height: 109)
                    }
                    .padding(.top, geometry.size.height * 0.25)
                    
                    Spacer()
                    
                    // Login Sheet
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            // Title inside sheet (only for email step)
                            if !isPasswordStep && !isCreatePasswordStep {
                                Text(headerTitle)
                                    .font(.custom("Rubik", size: 16, relativeTo: .body))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.crumbleTextPrimary)
                                    .tracking(0.32)
                                    .padding(.top, 16)
                                    .padding(.bottom, 24)
                            }
                            // Header with back button
                            if isPasswordStep || isCreatePasswordStep {
                                HStack {
                                    Button(action: goBack) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.crumbleTextPrimary)
                                            .font(.custom("Rubik", size: 20))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 24)
                            }
                            
                            // Main Content
                            VStack(spacing: 0) {
                                if !isPasswordStep && !isCreatePasswordStep {
                                    // Step 1: Email Input
                                    VStack(spacing: 8) {
                                        Spacer()
                                            .frame(height: 40)
                                        
                                        VStack(spacing: 8) {
                                            TextField("Email address", text: $email)
                                                .textFieldStyle(EnhancedTextFieldStyle())
                                                .keyboardType(.emailAddress)
                                                .autocapitalization(.none)
                                                .onChange(of: email) { _, _ in
                                                    errorMessage = nil
                                                }
                                            
                                            Button(action: handleEmailContinue) {
                                                Text("Continue")
                                                    .font(.custom("Rubik", size: 16))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 56)
                                                    .background(Color(hex: "7233F5"))
                                                    .cornerRadius(4)
                                            }
                                            
                                            Text("By continuing, you agree to our Privacy Policy and Terms of Service")
                                                .font(.custom("Rubik", size: 14))
                                                .foregroundColor(.crumbleTextSecondary)
                                                .multilineTextAlignment(.center)
                                                .padding(.bottom, 16)
                                            .disabled(email.isEmpty || isLoading)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 16)
                                        
                                        if let errorMessage = errorMessage {
                                            Text(errorMessage)
                                                .font(.custom("Rubik", size: 14))
                                                .foregroundColor(.red)
                                                .padding(.top, 8)
                                        }
                                    }
                                    
                                } else if isPasswordStep {
                                    // Step 2: Password for existing users
                                    VStack(spacing: 8) {
                                        VStack(spacing: 24) {
                                            Text("Enter your password")
                                                .font(.custom("Rubik", size: 16))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.crumbleTextPrimary)
                                                .tracking(0.32)
                                            
                                            Text("We'll send you a sign in link to \(email)")
                                                .font(.custom("Rubik", size: 14))
                                                .foregroundColor(.crumbleTextSecondary)
                                                .multilineTextAlignment(.center)
                                        }
                                        
                                        VStack(spacing: 8) {
                                            SecureField("Password", text: $password)
                                                .textFieldStyle(EnhancedTextFieldStyle())
                                                .onChange(of: password) { _, _ in
                                                    errorMessage = nil
                                                }
                                            
                                            Button(action: handleSignIn) {
                                                Text("Sign In")
                                                    .font(.custom("Rubik", size: 16))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 56)
                                                    .background(Color(hex: "7233F5"))
                                                    .cornerRadius(4)
                                            }
                                            .disabled(password.isEmpty || isLoading)
                                            
                                            Button(action: handleForgotPassword) {
                                                Text("Forgot Password?")
                                                    .font(.custom("Rubik", size: 16))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.crumbleTextPrimary)
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 56)
                                                    .background(Color(hex: "F6F6F6"))
                                                    .cornerRadius(4)
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 16)
                                        
                                        if let errorMessage = errorMessage {
                                            Text(errorMessage)
                                                .font(.custom("Rubik", size: 14))
                                                .foregroundColor(.red)
                                                .padding(.top, 8)
                                        }
                                    }
                                    
                                } else if isCreatePasswordStep {
                                    // Step 3: Create password for new users
                                    VStack(spacing: 8) {
                                        // Title and back button aligned
                                        HStack {
                                            Button(action: goBack) {
                                                Image(systemName: "chevron.left")
                                                    .foregroundColor(.crumbleTextPrimary)
                                                    .font(.custom("Rubik", size: 20))
                                            }
                                            
                                            Text("Create Password")
                                                .font(.custom("Rubik", size: 16))
                                                .fontWeight(.heavy)
                                                .foregroundColor(.crumbleTextPrimary)
                                                .tracking(0.32)
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 16)
                                        
                                        // Instructional text aligned to left
                                        Text("Create your password")
                                            .font(.custom("Rubik", size: 14))
                                            .foregroundColor(.crumbleTextSecondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 16)
                                            .padding(.bottom, 16)
                                        
                                        VStack(spacing: 8) {
                                            SecureField("Password", text: $password)
                                                .textFieldStyle(EnhancedTextFieldStyle())
                                                .onChange(of: password) { _, _ in
                                                    errorMessage = nil
                                                }
                                            
                                            SecureField("Confirm Password", text: $confirmPassword)
                                                .textFieldStyle(EnhancedTextFieldStyle())
                                                .onChange(of: confirmPassword) { _, _ in
                                                    errorMessage = nil
                                                }
                                            
                                            Button(action: handleSignUp) {
                                                Text("Sign Up")
                                                    .font(.custom("Rubik", size: 16))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 56)
                                                    .background(Color(hex: "7233F5"))
                                                    .cornerRadius(4)
                                            }
                                            .disabled(password.isEmpty || confirmPassword.isEmpty || password != confirmPassword || isLoading)
                                            
                                            Text("By continuing, you agree to our Privacy Policy and Terms of Service")
                                                .font(.custom("Rubik", size: 14))
                                                .foregroundColor(.crumbleTextSecondary)
                                                .multilineTextAlignment(.center)
                                                .padding(.bottom, 16)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 16)
                                        
                                        if let errorMessage = errorMessage {
                                            Text(errorMessage)
                                                .font(.custom("Rubik", size: 14))
                                                .foregroundColor(.red)
                                                .padding(.top, 8)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white.ignoresSafeArea(edges: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
        }
        .toast(isPresented: $showToast, message: toastText, style: toastStyle)
    }
    
    private var headerTitle: String {
        if isCreatePasswordStep {
            return "Create Password"
        } else if isPasswordStep {
            return "Enter your password"
        } else {
            return "Login or Sign up"
        }
    }
    
    private func goBack() {
        if isCreatePasswordStep {
            isCreatePasswordStep = false
            isPasswordStep = true
            password = ""
            confirmPassword = ""
        } else if isPasswordStep {
            isPasswordStep = false
            password = ""
        }
        errorMessage = nil
    }
    
    private func handleEmailContinue() {
        guard InputValidator.isPlausibleEmail(email) else {
            errorMessage = "Enter a valid email address"
            return
        }
        
        isLoading = true
        
        // Check if user exists by attempting to sign in with a dummy password
        Task {
            do {
                try await supabaseManager.signIn(email: email, password: "dummy_password")
                // If we get here, user exists (though sign in failed due to wrong password)
                await MainActor.run {
                    isNewUser = false
                    isPasswordStep = true
                    isLoading = false
                    errorMessage = nil
                }
            } catch {
                // User doesn't exist, go to create password step
                await MainActor.run {
                    isNewUser = true
                    isCreatePasswordStep = true
                    isLoading = false
                    errorMessage = nil
                }
            }
        }
    }
    
    private func handleSignIn() {
        guard !password.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await supabaseManager.signIn(email: email, password: password)
                await MainActor.run {
                    isLoading = false
                    toastText = "It's all set! Let's start using Crumble 🎉"
                    toastStyle = .success
                    showToast = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    if let authError = error as? AuthError {
                        errorMessage = authError.localizedDescription
                        toastText = authError.localizedDescription
                        toastStyle = .error
                        showToast = true
                    } else {
                        errorMessage = "Something went wrong. Please try again."
                        toastText = "Something went wrong. Please try again."
                        toastStyle = .error
                        showToast = true
                    }
                }
            }
        }
    }
    
    private func handleSignUp() {
        guard !password.isEmpty && !confirmPassword.isEmpty else { return }
        guard password == confirmPassword else {
            errorMessage = "Passwords don't match"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await supabaseManager.signUp(email: email, password: password)
                await MainActor.run {
                    isLoading = false
                    toastText = "It's all set! Let's start using Crumble 🎉"
                    toastStyle = .success
                    showToast = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    if let authError = error as? AuthError {
                        errorMessage = authError.localizedDescription
                        toastText = authError.localizedDescription
                        toastStyle = .error
                        showToast = true
                    } else {
                        errorMessage = "Something went wrong. Please try again."
                        toastText = "Something went wrong. Please try again."
                        toastStyle = .error
                        showToast = true
                    }
                }
            }
        }
    }
    
    private func handleForgotPassword() {
        // TODO: Implement forgot password functionality
        errorMessage = "Forgot password functionality coming soon"
    }
}

// MARK: - Enhanced Text Field Style
struct EnhancedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 52)
            .padding(.horizontal, DesignSystem.Spacing.md)
            .background(Color(hex: "#F5F3FF"))
            .foregroundColor(Color(hex: "#A48FDC"))
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        Color(hex: "#7B61FF").opacity(0.2),
                        lineWidth: 1
                    )
            )
            .font(.custom("Rubik", size: 14))
    }
}

// MARK: - Social Login Button
struct SocialLoginButton: View {
    let title: String
    let icon: String
    let color: Color
    let textColor: Color
    let isImage: Bool
    let logoScale: CGFloat
    let action: () async throws -> Void
    let isLoading: Bool
    let isDisabled: Bool
    
    init(title: String, icon: String, color: Color, textColor: Color, isImage: Bool = false, logoScale: CGFloat = 1.0, action: @escaping () async throws -> Void, isLoading: Bool = false, isDisabled: Bool = false) {
        self.title = title
        self.icon = icon
        self.color = color
        self.textColor = textColor
        self.isImage = isImage
        self.logoScale = logoScale
        self.action = action
        self.isLoading = isLoading
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await action()
                } catch {
                    // Error handling is done in the parent view
                    print("❌ Social sign-in error: \(error)")
                }
            }
        }) {
            HStack(spacing: DesignSystem.Spacing.md) {
                if isLoading {
                    // Loading spinner
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                        .frame(width: 24, height: 24)
                } else {
                    if isImage {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                            .scaleEffect(logoScale)
                    } else {
                        Image(systemName: icon)
                            .font(.custom("Rubik", size: 18))
                    }
                }
                
                Text(title)
                    .font(.custom("Rubik", size: 16))
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(color)
            .cornerRadius(4)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

#Preview {
    LoginView()
}
