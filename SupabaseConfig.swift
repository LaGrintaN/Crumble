//
//  SupabaseConfig.swift
//  Crumble
//
//  Created by Nicole Rosolin on 24/08/25.
//

import Foundation

struct SupabaseConfig {
    // MARK: - Supabase Configuration
    static let supabaseURL = "https://mxacpbnwtxuwfvexuvjb.supabase.co"
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14YWNwYm53dHh1d2Z2ZXh1dmpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYwMjg3ODYsImV4cCI6MjA3MTYwNDc4Nn0.5hrgVmccSx8h5784-pXDHpaJiueL1gz7ZGH6DxRec_M"
    static let supabaseServiceRole = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14YWNwYm53dHh1d2Z2ZXh1dmpiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NjAyODc4NiwiZXhwIjoyMDcxNjA0Nzg2fQ.YuNsCDvgTIGVO6uCu3dCfvh0NFI3wdoLB0qnv_dUpvU"
    
    // MARK: - Validation
    static var isValid: Bool {
        return !supabaseURL.contains("https://mxacpbnwtxuwfvexuvjb.supabase.co") &&
               !supabaseAnonKey.contains("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14YWNwYm53dHh1d2Z2ZXh1dmpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYwMjg3ODYsImV4cCI6MjA3MTYwNDc4Nn0.5hrgVmccSx8h5784-pXDHpaJiueL1gz7ZGH6DxRec_M")
    }
    
    // MARK: - Security Note
    // The anon key is safe to use in client apps
    // The service role key should ONLY be used in secure backend services
}
