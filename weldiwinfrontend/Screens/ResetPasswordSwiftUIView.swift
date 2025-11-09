//
//  ResetPasswordView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 4/11/2025.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    let email: String
    var onBackToSignIn: (() -> Void)? = nil
    var onFinished: (() -> Void)? = nil
    
    @State private var code: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    @State private var isLoading = false
    @State private var alertText: String?
    @State private var showAlert = false
    @State private var canResend = false
    @State private var countdown = 60
    @State private var passwordResetSuccess = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                    
                    // Key icon
                    Circle()
                        .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "key.fill")
                                .font(.system(size: 45))
                                .foregroundStyle(.white)
                        )
                        .padding(.top, 30)
                        .padding(.bottom, 25)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // Header
                        Text("Reset Password")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundStyle(.black.opacity(0.9))
                            .padding(.bottom, 8)
                        
                        Text("Enter the code sent to")
                            .font(.system(size: 15))
                            .foregroundStyle(.black.opacity(0.7))
                        Text(email)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.85))
                            .padding(.bottom, 30)
                        
                        // 6-digit code input
                        HStack(spacing: 10) {
                            ForEach(0..<6, id: \.self) { index in
                                CodeDigitField(
                                    text: $code[index],
                                    isFocused: focusedField == index
                                )
                                .focused($focusedField, equals: index)
                                .onChange(of: code[index]) { oldValue, newValue in
                                    handleCodeChange(index: index, oldValue: oldValue, newValue: newValue)
                                }
                                .onTapGesture {
                                    focusedField = index
                                }
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // Resend code
                        HStack(spacing: 6) {
                            Text("Didn't receive the code?")
                                .font(.system(size: 14))
                                .foregroundStyle(.black.opacity(0.7))
                            
                            if canResend {
                                Button("Resend") {
                                    resendCode()
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                            } else {
                                Text("(\(countdown)s)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(.bottom, 30)
                        
                        // New Password Field
                        VStack(alignment: .leading, spacing: 10) {
                            Text("New Password :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(.white.opacity(0.85))
                                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                                    .frame(height: 52)
                                
                                HStack {
                                    if showNewPassword {
                                        TextField("Enter new password", text: $newPassword)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.black.opacity(0.85))
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled()
                                    } else {
                                        SecureField("Enter new password", text: $newPassword)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.black.opacity(0.85))
                                    }
                                    
                                    Button(action: { showNewPassword.toggle() }) {
                                        Image(systemName: showNewPassword ? "eye.slash.fill" : "eye.fill")
                                            .font(.system(size: 18))
                                            .foregroundStyle(.black.opacity(0.5))
                                            .frame(width: 40, height: 40)
                                    }
                                }
                                .padding(.leading, 18)
                                .padding(.trailing, 8)
                            }
                        }
                        .padding(.bottom, 16)
                        
                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Confirm Password :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(.white.opacity(0.85))
                                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                                    .frame(height: 52)
                                
                                HStack {
                                    if showConfirmPassword {
                                        TextField("Confirm new password", text: $confirmPassword)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.black.opacity(0.85))
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled()
                                    } else {
                                        SecureField("Confirm new password", text: $confirmPassword)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.black.opacity(0.85))
                                    }
                                    
                                    Button(action: { showConfirmPassword.toggle() }) {
                                        Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                            .font(.system(size: 18))
                                            .foregroundStyle(.black.opacity(0.5))
                                            .frame(width: 40, height: 40)
                                    }
                                }
                                .padding(.leading, 18)
                                .padding(.trailing, 8)
                            }
                        }
                        .padding(.bottom, 35)
                        
                        // Reset Password Button
                        Button(action: resetPassword) {
                            HStack(spacing: 8) {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.85)
                                }
                                Text(isLoading ? "Resetting..." : "Reset Password")
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
                        .disabled(isLoading || !isFormComplete)
                        .opacity(isFormComplete ? 1.0 : 0.6)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 28)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            focusedField = 0
            startCountdown()
        }
        .onReceive(timer) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                canResend = true
            }
        }
        .alert("Reset Password", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                if passwordResetSuccess {
                    onFinished?()
                    dismiss()
                }
            }
        } message: {
            Text(alertText ?? "")
        }
    }
    
    // MARK: - Computed Properties
    
    var isCodeComplete: Bool {
        code.allSatisfy { !$0.isEmpty }
    }
    
    var codeString: String {
        code.joined()
    }
    
    var isFormComplete: Bool {
        isCodeComplete && !newPassword.isEmpty && !confirmPassword.isEmpty
    }
    
    // MARK: - Actions
    
    private func handleCodeChange(index: Int, oldValue: String, newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        
        if filtered.count > 1 {
            let digits = Array(filtered.prefix(6))
            for (i, digit) in digits.enumerated() where i < 6 {
                code[i] = String(digit)
            }
            focusedField = min(digits.count, 5)
        } else if filtered.count == 1 {
            code[index] = filtered
            if index < 5 {
                focusedField = index + 1
            } else {
                focusedField = nil
            }
        } else if newValue.isEmpty {
            code[index] = ""
            if index > 0 {
                focusedField = index - 1
            }
        }
    }
    
    private func startCountdown() {
        countdown = 60
        canResend = false
    }
    
    private func resetPassword() {
        // Validate
        if newPassword.count < 6 {
            alertText = "Password must be at least 6 characters"
            showAlert = true
            return
        }
        
        if newPassword != confirmPassword {
            alertText = "Passwords do not match"
            showAlert = true
            return
        }
        
        isLoading = true
        
        let request = ResetPasswordRequest(
            email: email,
            phoneNumber: nil,
            code: codeString,
            newPassword: newPassword
        )
        
        NetworkService.shared.postRequest(to: .resetPassword, body: request) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(ResetPasswordResponse.self, from: data)
                        print("✅ Password reset: \(response.message)")
                        
                        self.passwordResetSuccess = true
                        self.alertText = "Password reset successfully! Please sign in with your new password."
                        self.showAlert = true
                        
                    } catch {
                        let raw = String(data: data, encoding: .utf8) ?? "Unknown"
                        self.passwordResetSuccess = true
                        self.alertText = "Password reset successfully! Please sign in."
                        self.showAlert = true
                    }
                    
                case .failure(let error):
                    self.alertText = error.localizedDescription
                    self.showAlert = true
                    // Clear code on error
                    self.code = Array(repeating: "", count: 6)
                    self.focusedField = 0
                }
            }
        }
    }
    
    private func resendCode() {
        let request = ForgotPasswordRequest(
            email: email,
            phoneNumber: nil,
            channel: "email"
        )
        
        NetworkService.shared.postRequest(to: .forgotPassword, body: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.alertText = "Code resent successfully!"
                    self.showAlert = true
                    self.startCountdown()
                case .failure(let error):
                    self.alertText = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}

// MARK: - Code Digit Field

private struct CodeDigitField: View {
    @Binding var text: String
    let isFocused: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(isFocused ? Color(red: 0.95, green: 0.55, blue: 0.35) : Color.black.opacity(0.2), lineWidth: isFocused ? 2.5 : 1.5)
                .fill(Color.white.opacity(0.85))
                .frame(width: 48, height: 56)
                .shadow(color: isFocused ? Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.2) : .clear, radius: 8, x: 0, y: 4)
            
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.black.opacity(0.9))
                .frame(width: 48, height: 56)
                .background(Color.clear)
        }
    }
}

// MARK: - Request Models

struct ResetPasswordRequest: Codable {
    let email: String?
    let phoneNumber: String?
    let code: String
    let newPassword: String
}

struct ResetPasswordResponse: Codable {
    let message: String
}

#Preview {
    NavigationView {
        ResetPasswordView(email: "test@example.com")
    }
}
