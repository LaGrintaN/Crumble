import Foundation
import Supabase

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    private var client: SupabaseClient?
    
    @Published var isAuthenticated = false
    @Published var currentUser: Any?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {
        setupClient()
    }
    
    private func setupClient() {
        print("🔍 Debug: Setting up Supabase client...")
        print("🔍 Debug: URL: \(SupabaseConfig.supabaseURL)")
        print("🔍 Debug: Key length: \(SupabaseConfig.supabaseAnonKey.count)")
        
        guard SupabaseConfig.isValid else {
            print("❌ Supabase configuration is invalid!")
            print("🔍 Debug: isValid returned false")
            return
        }
        
        guard let url = URL(string: SupabaseConfig.supabaseURL) else {
            print("❌ Invalid Supabase URL!")
            return
        }
        
        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: SupabaseConfig.supabaseAnonKey
        )
        
        print("✅ Supabase client initialized successfully!")
    }
    
    // MARK: - Authentication Methods
    
    func signUp(email: String, password: String) async {
        guard let client = client else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await client.auth.signUp(
                email: email,
                password: password
            )
            
            await MainActor.run {
                self.currentUser = response.user
                self.isAuthenticated = true
                print("✅ User signed up successfully!")
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("❌ Sign up error: \(error.localizedDescription)")
            }
        }
    }
    
    func signIn(email: String, password: String) async {
        guard let client = client else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await client.auth.signIn(
                email: email,
                password: password
            )
            
            await MainActor.run {
                self.currentUser = response.user
                self.isAuthenticated = true
                print("✅ User signed in successfully!")
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("❌ Sign in error: \(error.localizedDescription)")
            }
        }
    }
    
    func signOut() async {
        guard let client = client else { return }
        
        do {
            try await client.auth.signOut()
            
            await MainActor.run {
                self.currentUser = nil
                self.isAuthenticated = false
                print("✅ User signed out successfully")
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                print("❌ Sign out error: \(error.localizedDescription)")
            }
        }
    }
    
    func checkCurrentUser() async {
        guard let client = client else { return }
        
        do {
            let session = try await client.auth.session
            await MainActor.run {
                self.currentUser = session.user
                self.isAuthenticated = true
                print("✅ Current user session found")
            }
        } catch {
            await MainActor.run {
                self.currentUser = nil
                self.isAuthenticated = false
                print("ℹ️ No active session")
            }
        }
    }
    
    // MARK: - Social Sign-In Methods
    @MainActor
    func signInWithApple() async throws {
        guard let client = client else { throw AuthError.network }
        try await client.auth.signInWithOAuth(
            provider: .apple,
            redirectTo: URL(string: "com.nicole.Crumble://auth-callback")
        )
    }
    
    @MainActor
    func signInWithGoogle() async throws {
        guard let client = client else { throw AuthError.network }
        try await client.auth.signInWithOAuth(
            provider: .google,
            redirectTo: URL(string: "com.nicole.Crumble://auth-callback"),
            scopes: "email profile"
        )
    }
    
    @MainActor
    func signInWithFacebook() async throws {
        guard let client = client else { throw AuthError.network }
        try await client.auth.signInWithOAuth(
            provider: .facebook,
            redirectTo: URL(string: "com.nicole.Crumble://auth-callback"),
            scopes: "email public_profile"
        )
    }
    
    // MARK: - URL Handling
    func handleURL(_ url: URL) {
        client?.handle(url)
    }
}

// MARK: - Auth Errors
enum AuthError: Error, LocalizedError {
    case network
    case userCancelled
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .network:
            return "Network error. Please check your connection."
        case .userCancelled:
            return "Sign-in was cancelled."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
