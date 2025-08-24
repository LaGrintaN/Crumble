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
        guard SupabaseConfig.isValid else {
            print("❌ Supabase configuration is invalid!")
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
                if response.user != nil {
                    self.currentUser = response.user
                    self.isAuthenticated = true
                    print("✅ User signed up successfully!")
                }
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
                if response.user != nil {
                    self.currentUser = response.user
                    self.isAuthenticated = true
                    print("✅ User signed in successfully!")
                }
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
}
