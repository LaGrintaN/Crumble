import SwiftUI

struct LoginView: View {
    @StateObject private var supabaseManager = SupabaseManager.shared
    @State private var email = ""
    @State private var isSignUp = false
    @State private var showPassword = false
    @State private var isPasswordStep = false
    @State private var password = ""
    @State private var errorMessage: String? = nil
    @FocusState private var emailFieldFocused: Bool
    @FocusState private var passwordFieldFocused: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.crumblePrimary
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Section with Logo
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        Spacer()
                        
                        // Logo
                        Image("logo 1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .scaleEffect(0.91) // 120 * 0.91 = ~109 (increased by +1.6x from 0.57)
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.25) // 1/4 of viewport
                    
                    // White sheet that extends to bottom
                    VStack(spacing: 0) {
                        // Card Header
                        HStack {
                            if isPasswordStep {
                                Button(action: { 
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        isPasswordStep = false
                                        password = ""
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.title3)
                                        .foregroundColor(.crumbleTextSecondary)
                                        .frame(width: 32, height: 32)
                                        .background(Color.crumbleBackground)
                                        .clipShape(Circle())
                                }
                            }
                            
                            Spacer()
                            
                                                    Text(isPasswordStep ? "Enter Password" : "Login or Sign up")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(Color(hex: "#2A1562"))
                            .tracking(0.32) // 2% letter-spacing (16 * 0.02 = 0.32)
                            
                            Spacer()
                            
                            if isPasswordStep {
                                // Invisible spacer to maintain centering
                                Color.clear
                                    .frame(width: 32, height: 32)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.top, DesignSystem.Spacing.lg)
                        
                        // Form Content
                        VStack(spacing: 8) { // Reduced to 8px as requested
                            if !isPasswordStep {
                                // Spacer for 40px padding between title and email field
                                Spacer()
                                    .frame(height: 40)
                                
                                // Email Step and Continue Button Container
                                VStack(spacing: 8) {
                                                                    // Email Field
                                TextField("Email Address", text: $email)
                                    .textFieldStyle(EnhancedTextFieldStyle(
                                        isFocused: emailFieldFocused,
                                        hasError: errorMessage != nil && errorMessage!.contains("email")
                                    ))
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .focused($emailFieldFocused)
                                    .onChange(of: email) { oldValue, newValue in
                                        // Clear error when user starts typing
                                        errorMessage = nil
                                    }
                                    
                                                                    // Continue Button
                                Button(action: {
                                    // Validate email before proceeding
                                    if !InputValidator.isPlausibleEmail(email) {
                                        errorMessage = "Enter a valid email address"
                                        return
                                    }
                                    
                                    // Proceed to password step
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        isPasswordStep = true
                                        passwordFieldFocused = true
                                        errorMessage = nil // Clear any previous errors
                                    }
                                }) {
                                    HStack {
                                        Text("Continue")
                                            .font(.system(size: 17, weight: .semibold, design: .default))
                                            .tracking(0.34) // 2% letter-spacing (17 * 0.02 = 0.34)
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity) // Full width to match email field
                                    .frame(height: 56)
                                    .background(
                                        InputValidator.isPlausibleEmail(email) 
                                            ? Color.crumblePrimary
                                            : Color.crumbleTextSecondary.opacity(0.3)
                                    )
                                    .cornerRadius(4) // Changed to 4px as requested
                                }
                                .disabled(!InputValidator.isPlausibleEmail(email))
                                .scaleEffect(InputValidator.isPlausibleEmail(email) ? 1.0 : 0.98)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: InputValidator.isPlausibleEmail(email))
                                
                                // Error Message
                                if let errorMessage = errorMessage {
                                    Text(errorMessage)
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 4)
                                        .transition(.opacity.combined(with: .scale))
                                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: errorMessage)
                                }
                                }
                                
                                                            // Legal Text
                            VStack(spacing: 2) {
                                HStack(spacing: 0) {
                                    Text("By continuing, you agree to our ")
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                        .foregroundColor(.crumbleTextSecondary)
                                    
                                    Text("Privacy Policy")
                                        .font(.system(size: 16, weight: .medium, design: .default))
                                        .foregroundColor(.crumblePrimary)
                                }
                                
                                HStack(spacing: 0) {
                                    Text("and ")
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                        .foregroundColor(.crumbleTextSecondary)
                                    
                                    Text("Terms of Service")
                                        .font(.system(size: 16, weight: .medium, design: .default))
                                        .foregroundColor(.crumblePrimary)
                                }
                            }
                            .multilineTextAlignment(.center)
                            .padding(.top, 24) // 24px padding after continue button
                            
                            // Separator
                            HStack(spacing: 0) {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.crumbleTextSecondary.opacity(0.2))
                                    .frame(maxWidth: .infinity)
                                
                                Text("Or access with")
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    .foregroundColor(.crumbleTextSecondary)
                                    .padding(.horizontal, 12) // Reduced padding to fit text on one line
                                    .fixedSize(horizontal: true, vertical: false) // Prevents text wrapping
                                
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.crumbleTextSecondary.opacity(0.2))
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.top, 24) // 24px padding after policy text
                            
                            // Social Login Buttons
                            VStack(spacing: 8) { // 8px spacing between social buttons
                                SocialLoginButton(
                                    title: "Apple",
                                    icon: "appleLogo",
                                    color: Color(hex: "#F6F6F6"),
                                    textColor: Color(hex: "#2A1562"),
                                    isImage: true,
                                    action: { try await supabaseManager.signInWithApple() },
                                    isLoading: supabaseManager.isLoading,
                                    isDisabled: supabaseManager.isLoading
                                )
                                
                                SocialLoginButton(
                                    title: "Facebook",
                                    icon: "facebookLogo",
                                    color: Color(hex: "#F6F6F6"),
                                    textColor: Color(hex: "#2A1562"),
                                    isImage: true,
                                    action: { try await supabaseManager.signInWithFacebook() },
                                    isLoading: supabaseManager.isLoading,
                                    isDisabled: supabaseManager.isLoading
                                )
                                
                                SocialLoginButton(
                                    title: "Google",
                                    icon: "googleLogo",
                                    color: Color(hex: "#F6F6F6"),
                                    textColor: Color(hex: "#2A1562"),
                                    isImage: true,
                                    logoScale: 0.75,
                                    action: { try await supabaseManager.signInWithGoogle() },
                                    isLoading: supabaseManager.isLoading,
                                    isDisabled: supabaseManager.isLoading
                                )
                            }
                            .padding(.top, 24) // 24px padding after divider
                                
                            } else {
                                // Password Step
                                HStack {
                                                                    if showPassword {
                                    TextField("Password", text: $password)
                                        .textFieldStyle(EnhancedTextFieldStyle(isFocused: passwordFieldFocused, hasError: errorMessage != nil))
                                        .textContentType(.password)
                                        .focused($passwordFieldFocused)
                                        .onChange(of: password) { oldValue, newValue in
                                            // Clear error when user starts typing
                                            errorMessage = nil
                                        }
                                } else {
                                    SecureField("Password", text: $password)
                                        .textFieldStyle(EnhancedTextFieldStyle(isFocused: passwordFieldFocused, hasError: errorMessage != nil))
                                        .textContentType(.password)
                                        .focused($passwordFieldFocused)
                                        .onChange(of: password) { oldValue, newValue in
                                            // Clear error when user starts typing
                                            errorMessage = nil
                                        }
                                        }
                                    
                                    Button(action: { 
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            showPassword.toggle()
                                        }
                                    }) {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundColor(.crumbleTextSecondary)
                                            .frame(width: 20, height: 20)
                                            .padding(.trailing, DesignSystem.Spacing.sm)
                                    }
                                }
                                
                                                            // Sign In Button
                            Button(action: {
                                Task {
                                    do {
                                        await supabaseManager.signIn(email: email, password: password)
                                        // If successful, errorMessage will be nil
                                    } catch {
                                        // Map Supabase errors to friendly messages
                                        let authError = AuthErrorKind.from(error)
                                        switch authError {
                                        case .invalidEmailFormat:
                                            errorMessage = "That doesn't look like an email."
                                        case .wrongEmailOrPassword:
                                            errorMessage = "Wrong email or password."
                                        case .userNotFound:
                                            errorMessage = "No account with this email."
                                        case .weakPassword:
                                            errorMessage = "Password is too weak."
                                        case .emailAlreadyUsed:
                                            errorMessage = "This email is already in use."
                                        case .network:
                                            errorMessage = "You're offline. Please check your connection."
                                        case .timeout:
                                            errorMessage = "This is taking too long. Try again."
                                        case .unknown:
                                            errorMessage = "Something went wrong. Please try again."
                                        }
                                    }
                                }
                            }) {
                                HStack {
                                    if supabaseManager.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    } else {
                                        Text("Sign In")
                                            .font(.system(size: 17, weight: .semibold, design: .default))
                                            .tracking(0.34) // 2% letter-spacing (17 * 0.02 = 0.34)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    password.isEmpty 
                                        ? Color.crumbleTextSecondary.opacity(0.3)
                                        : Color.crumblePrimary
                                    )
                                .cornerRadius(4) // Changed to 4px as requested
                            }
                            .disabled(password.isEmpty || supabaseManager.isLoading)
                            .scaleEffect(password.isEmpty ? 0.98 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: password.isEmpty)
                            
                            // Error Message for password step
                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, DesignSystem.Spacing.md)
                                    .transition(.opacity.combined(with: .scale))
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: errorMessage)
                            }
                        }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.bottom, 34) // Safe area bottom height
                        
                        // This ensures the white background extends to the bottom
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(Color.white.ignoresSafeArea(edges: .bottom))
                    .cornerRadius(DesignSystem.CornerRadius.large, corners: [.topLeft, .topRight])
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: -10)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onAppear {
            Task {
                await supabaseManager.checkCurrentUser()
            }
        }
    }
}

// MARK: - Enhanced Text Field Style
struct EnhancedTextFieldStyle: TextFieldStyle {
    let isFocused: Bool
    let hasError: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 52) // Height set to 52px as requested
            .padding(.horizontal, DesignSystem.Spacing.md)
            .background(Color(hex: "#F5F3FF")) // Fill color as requested
            .foregroundColor(Color(hex: "#A48FDC")) // Text color as requested
            .cornerRadius(4) // Changed to 4px as requested
            .overlay(
                RoundedRectangle(cornerRadius: 4) // Changed to 4px as requested
                    .stroke(
                        hasError ? Color.red : Color(hex: "#7B61FF").opacity(0.2), // Red border for error, normal for valid
                        lineWidth: 1 // 1px stroke as requested
                    )
            )
            .font(.system(size: 14, weight: .regular, design: .default))
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
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
                        // Custom logo image
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .scaleEffect(logoScale)
                    } else {
                        // SF Symbol
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundColor(textColor)
                    }
                }
                
                Text(title)
                    .font(.rubikSubheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(color)
            .cornerRadius(4)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .disabled(isLoading || isDisabled)
        .scaleEffect(isLoading || isDisabled ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isLoading)
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    LoginView()
}
