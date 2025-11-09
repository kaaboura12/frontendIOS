//
//  ForgotPasswordView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 4/11/2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    var onBackToSignIn: (() -> Void)? = nil
    var onReset: (_ email: String) -> Void = { _ in }
    
    @State private var email = ""
    @State private var isLoading = false
    @State private var alertText: String?
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            // Background
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Back button
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
                    
                    // Lock icon
                    Circle()
                        .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                        .frame(width: 110, height: 110)
                        .overlay(
                            Image(systemName: "lock.rotation")
                                .font(.system(size: 50))
                                .foregroundStyle(.white)
                        )
                        .padding(.top, 50)
                        .padding(.bottom, 30)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // Header
                        Text("Forgot Password")
                            .font(.system(size: 36, weight: .bold, design: .serif))
                            .foregroundStyle(.black.opacity(0.9))
                            .padding(.bottom, 8)
                        
                        Text("Enter your email address and we'll send you a code to reset your password")
                            .font(.system(size: 16))
                            .foregroundStyle(.black.opacity(0.7))
                            .lineSpacing(4)
                            .padding(.bottom, 40)
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email Address :")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(.white.opacity(0.85))
                                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                                    .frame(height: 56)
                                
                                TextField("Enter your email", text: $email)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.black.opacity(0.85))
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .padding(.horizontal, 18)
                            }
                        }
                        .padding(.bottom, 40)
                        
                        // Send Code Button
                        Button(action: sendResetCode) {
                            HStack(spacing: 8) {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.85)
                                }
                                Text(isLoading ? "Sending..." : "Send Reset Code")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.98, green: 0.65, blue: 0.45),
                                                Color(red: 0.95, green: 0.55, blue: 0.35)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4), radius: 12, x: 0, y: 6)
                            )
                        }
                        .disabled(isLoading)
                        .padding(.bottom, 30)
                        
                        // Back to Sign In
                        HStack {
                            Spacer()
                            Text("Remember your password?")
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.7))
                            Button(action: {
                                if let onBackToSignIn {
                                    onBackToSignIn()
                                } else {
                                    dismiss()
                                }
                            }) {
                                Text("Sign In")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                            }
                            Spacer()
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 28)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Forgot Password", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertText ?? "")
        }
    }
    
    // MARK: - Actions
    
    private func sendResetCode() {
        if email.isEmpty {
            alertText = "Please enter your email address"
            showAlert = true
            return
        }
        
        if !email.contains("@") {
            alertText = "Please enter a valid email address"
            showAlert = true
            return
        }
        
        isLoading = true
        
        let request = ForgotPasswordRequest(
            email: email,
            phoneNumber: nil,
            channel: "email"
        )
        
        NetworkService.shared.postRequest(to: .forgotPassword, body: request) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(ForgotPasswordResponse.self, from: data)
                        print("✅ Reset code sent: \(response.message)")
                        
                        onReset(email)
                        
                    } catch {
                        let raw = String(data: data, encoding: .utf8) ?? "Unknown"
                        self.alertText = "Success! Check your email for the reset code."
                        self.showAlert = true
                        
                        // Still navigate even if parsing fails
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            onReset(email)
                        }
                    }
                    
                case .failure(let error):
                    self.alertText = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}

// MARK: - Request Models

struct ForgotPasswordRequest: Codable {
    let email: String?
    let phoneNumber: String?
    let channel: String
}

struct ForgotPasswordResponse: Codable {
    let message: String
}

#Preview {
    NavigationView {
        ForgotPasswordView()
    }
}
