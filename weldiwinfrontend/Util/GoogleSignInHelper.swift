import Foundation
import GoogleSignIn
import SwiftUI

/// Helper class to manage Google Sign-In
class GoogleSignInHelper: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String?
    
    /// Google Sign-In with iOS SDK
    func signIn(completion: @escaping (Result<String, Error>) -> Void) {
        // Get the root view controller
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            completion(.failure(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller found"])))
            return
        }
        
        // Configure Google Sign-In
        guard let clientID = Bundle.main.infoDictionary?["GIDClientID"] as? String else {
            completion(.failure(NSError(domain: "GoogleSignIn", code: -2, userInfo: [NSLocalizedDescriptionKey: "Google Client ID not found in Info.plist"])))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start sign-in flow
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            if let error = error {
                print("❌ Google Sign-In error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let signInResult = signInResult else {
                completion(.failure(NSError(domain: "GoogleSignIn", code: -3, userInfo: [NSLocalizedDescriptionKey: "No sign-in result"])))
                return
            }
            
            // Get the ID token
            guard let idToken = signInResult.user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "GoogleSignIn", code: -4, userInfo: [NSLocalizedDescriptionKey: "No ID token received"])))
                return
            }
            
            print("✅ Google Sign-In successful, got ID token")
            self?.isSignedIn = true
            completion(.success(idToken))
        }
    }
    
    /// Sign out from Google
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        isSignedIn = false
    }
    
    /// Authenticate with backend using Google ID token
    func authenticateWithBackend(idToken: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let googleAuthRequest = GoogleAuthRequest(idToken: idToken)
        
        print("🔄 Sending ID token to backend...")
        
        NetworkService.shared.postRequest(to: .googleLogin, body: googleAuthRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    print("✅ Backend authentication successful!")
                    completion(.success(response))
                } catch {
                    print("❌ Failed to decode response: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ Backend authentication failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

/// Request body for Google authentication
struct GoogleAuthRequest: Codable {
    let idToken: String
}
