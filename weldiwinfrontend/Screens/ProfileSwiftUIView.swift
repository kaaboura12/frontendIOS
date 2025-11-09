import SwiftUI

struct UserProfile: Codable {
    let _id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String?  
    let role: String
    let avatarUrl: String?
    let status: String
    let isVerified: Bool
}

struct ProfileView: View {
    @State private var profile: UserProfile?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showLogoutAlert = false
    
    // ✅ Navigation states
    @State private var navigateToSignIn = false
    @State private var navigateToEditProfile = false
    
    var body: some View {
        ZStack {
            // Same background
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let profile = profile {
                ScrollView {
                    VStack(spacing: 0) {
                        // Top section with logo, circle, and settings
                        ZStack {
                            // Large orange circle with user icon - CENTERED
                            Circle()
                                .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                                .frame(width: 150, height: 150)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 65))
                                        .foregroundStyle(.white)
                                )
                            
                            // Logo and settings icon - OVERLAY on top right
                            VStack {
                                HStack {
                                    Spacer()
                                    VStack(spacing: 12) {
                                        Image("Gemini_Generated_Image_qr0yhoqr0yhoqr0y-removebg-preview")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 55, height: 55)
                                        
                                        Button(action: {
                                            // Navigate to settings
                                        }) {
                                            Image(systemName: "gearshape.fill")
                                                .font(.system(size: 26))
                                                .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                                        }
                                    }
                                    .padding(.trailing, 24)
                                }
                                Spacer()
                            }
                        }
                        .frame(height: 200)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        
                        VStack(spacing: 0) {
                            // Name
                            ProfileField(
                                label: "your name :",
                                value: "\(profile.firstName) \(profile.lastName)"
                            )
                            
                            // Email
                            ProfileField(
                                label: "Your Email :",
                                value: profile.email
                            )
                            
                            // Phone - ✅ UPDATED: Show placeholder if null
                            ProfileField(
                                label: "Your Mobile number :",
                                value: profile.phoneNumber ?? "Not provided"
                            )
                            
                            // Password (masked) - ✅ UPDATED: Hide for Google users
                            if profile.phoneNumber != nil {
                                ProfileField(
                                    label: "your Password :",
                                    value: "••••••••••••••••••••",
                                    isPassword: true
                                )
                            }
                            
                            // ✅ Edit Profile Button
                            Button(action: {
                                print("🔵 Edit profile button tapped")
                                navigateToEditProfile = true
                            }) {
                                Text("edit profile")
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .foregroundStyle(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                                            .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3), radius: 10, x: 0, y: 5)
                                    )
                            }
                            .padding(.horizontal, 28)
                            .padding(.top, 30)
                            .padding(.bottom, 20)
                            
                            // Logout Button
                            Button(action: {
                                showLogoutAlert = true
                            }) {
                                Text("logout")
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .foregroundStyle(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                                            .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3), radius: 10, x: 0, y: 5)
                                    )
                            }
                            .padding(.horizontal, 28)
                            .padding(.bottom, 40)
                        }
                    }
                }
                
            } else if let error = errorMessage {
                VStack(spacing: 20) {
                    Text("Error loading profile")
                        .font(.title2.bold())
                    Text(error)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Retry") {
                        loadProfile()
                    }
                    .padding()
                    .background(Color(red: 0.95, green: 0.55, blue: 0.35))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            
            // ✅ MOVED HERE - NavigationLinks at ZStack level (always present)
            NavigationLink(destination: EditProfileView(), isActive: $navigateToEditProfile) {
                EmptyView()
            }
            .hidden()
            
            NavigationLink(destination: AuthContainerView(), isActive: $navigateToSignIn) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarHidden(true)
        .onAppear {
            loadProfile()
        }
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
    
    // MARK: - Load Profile
    
    private func loadProfile() {
        isLoading = true
        
        guard let token = KeychainHelper.shared.get(forKey: "access_token") else {
            errorMessage = "Please sign in"
            isLoading = false
            return
        }
        
        NetworkService.shared.getRequest(to: .profile, token: token) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    // ✅ ADD DEBUG LOGGING
                    print("📥 Profile data: \(String(data: data, encoding: .utf8) ?? "nil")")
                    
                    do {
                        let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                        self.profile = profile
                        print("✅ Profile loaded successfully!")
                    } catch {
                        print("❌ Decoding error: \(error)")
                        self.errorMessage = "Failed to parse profile: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    print("❌ Network error: \(error)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Logout
    
    private func logout() {
        // Delete token from keychain
        let deleted = KeychainHelper.shared.delete(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "authRole")
        
        if deleted {
            print("✅ Token deleted successfully")
        } else {
            print("⚠️ Failed to delete token")
        }
        
        // Clear profile data
        self.profile = nil
        
        // Navigate back to sign in
        self.navigateToSignIn = true
    }
}

// MARK: - Profile Field Component

private struct ProfileField: View {
    let label: String
    let value: String
    var isPassword: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 17))
                .foregroundStyle(.black.opacity(0.7))
            
            Text(value)
                .font(.system(size: 20, weight: isPassword ? .regular : .semibold))
                .foregroundStyle(.black.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            Rectangle()
                .fill(Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.5))
                .frame(height: 1.5)
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 16)
    }
}

#Preview {
    ProfileView()
}
