//
//  EditProfileSwiftUIView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 4/11/2025.
//

import SwiftUI

struct UpdateUserRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var isLoading = false
    @State private var alertText: String?
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            // Same background
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Top bar with back button
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))
                                .frame(width: 44, height: 44)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Profile circle with camera icon
                    ZStack(alignment: .bottom) {
                        Circle()
                            .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                            .frame(width: 110, height: 110)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.white)
                            )
                        
                        // Camera button
                        Button(action: {
                            // Handle photo upload
                        }) {
                            Circle()
                                .fill(.white)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color(red: 0.95, green: 0.55, blue: 0.35), lineWidth: 2)
                                )
                        }
                        .offset(y: 5)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your details")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))
                            Text("share a little bit about yourself")
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.6))
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 24)
                        
                        // Full Name
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Full Name :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))
                            
                            HStack(spacing: 12) {
                                TextField("First name", text: $firstName)
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 18)
                                    .frame(height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                                            .fill(.white.opacity(0.85))
                                            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                                    )
                                
                                TextField("Last name", text: $lastName)
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 18)
                                    .frame(height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                                            .fill(.white.opacity(0.85))
                                            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                                    )
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 20)
                        
                        // Email
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))
                            
                            TextField("", text: $email)
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.85))
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(.horizontal, 18)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .fill(.white.opacity(0.85))
                                        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                                )
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 20)
                        
                        // Mobile number
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Mobile number :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))
                            
                            TextField("mobile number", text: $phoneNumber)
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.85))
                                .keyboardType(.phonePad)
                                .padding(.horizontal, 18)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .fill(.white.opacity(0.85))
                                        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                                )
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 40)
                        
                        // Update button
                        Button(action: updateProfile) {
                            HStack(spacing: 8) {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.85)
                                }
                                Text(isLoading ? "Updating..." : "update")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                                    .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                        }
                        .disabled(isLoading)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadCurrentProfile()
        }
        .alert("Update Profile", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                if alertText?.contains("successfully") == true {
                    dismiss()
                }
            }
        } message: {
            Text(alertText ?? "")
        }
    }
    
    // MARK: - Load Current Profile
    
    private func loadCurrentProfile() {
        guard let token = KeychainHelper.shared.get(forKey: "access_token") else {
            return
        }
        
        NetworkService.shared.getRequest(to: .profile, token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                        self.firstName = profile.firstName
                        self.lastName = profile.lastName
                        self.email = profile.email
                        self.phoneNumber = profile.phoneNumber!
                    } catch {
                        print("Failed to load profile: \(error)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    // MARK: - Update Profile
    
    private func updateProfile() {
        // Validate
        if firstName.isEmpty || lastName.isEmpty {
            alertText = "Please enter your full name"
            showAlert = true
            return
        }
        
        if email.isEmpty || !email.contains("@") {
            alertText = "Please enter a valid email"
            showAlert = true
            return
        }
        
        if phoneNumber.isEmpty {
            alertText = "Please enter your phone number"
            showAlert = true
            return
        }
        
        isLoading = true
        
        guard let token = KeychainHelper.shared.get(forKey: "access_token") else {
            alertText = "Please sign in"
            showAlert = true
            isLoading = false
            return
        }
        
        // Get user ID from profile first
        NetworkService.shared.getRequest(to: .profile, token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                        let userId = profile._id
                        
                        // Now update with the user ID using NetworkService
                        self.performUpdate(userId: userId, token: token)
                    } catch {
                        self.isLoading = false
                        self.alertText = "Failed to get user info"
                        self.showAlert = true
                    }
                case .failure(let error):
                    self.isLoading = false
                    self.alertText = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
    
    private func performUpdate(userId: String, token: String) {
        let updateData = UpdateUserRequest(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber
        )
        
        NetworkService.shared.patchRequest(to: .updateUser(userId: userId), body: updateData, token: token) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    self.alertText = "Profile updated successfully! ✅"
                    self.showAlert = true
                case .failure(let error):
                    self.alertText = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}

#Preview {
    EditProfileView()
}
