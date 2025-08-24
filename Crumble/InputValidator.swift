import Foundation

// MARK: - Input Validator
struct InputValidator {
    
    // Lightweight email validation - basic format check
    static func isPlausibleEmail(_ email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@") && 
               trimmed.contains(".") && 
               trimmed.count >= 5 &&
               !trimmed.hasPrefix("@") &&
               !trimmed.hasSuffix("@") &&
               !trimmed.hasPrefix(".") &&
               !trimmed.hasSuffix(".")
    }
}

// MARK: - Auth Error Kind
enum AuthErrorKind: Error {
    case invalidEmailFormat
    case wrongEmailOrPassword
    case userNotFound
    case weakPassword
    case emailAlreadyUsed
    case network
    case timeout
    case unknown
    
    static func from(_ error: Error) -> AuthErrorKind {
        // Map Supabase errors to our error kinds
        let errorString = error.localizedDescription.lowercased()
        
        if errorString.contains("invalid") && errorString.contains("email") {
            return .invalidEmailFormat
        } else if errorString.contains("wrong") || errorString.contains("password") {
            return .wrongEmailOrPassword
        } else if errorString.contains("user") && errorString.contains("found") {
            return .userNotFound
        } else if errorString.contains("weak") && errorString.contains("password") {
            return .weakPassword
        } else if errorString.contains("already") && errorString.contains("use") {
            return .emailAlreadyUsed
        } else if errorString.contains("network") || errorString.contains("offline") {
            return .network
        } else if errorString.contains("timeout") || errorString.contains("long") {
            return .timeout
        } else {
            return .unknown
        }
    }
}
