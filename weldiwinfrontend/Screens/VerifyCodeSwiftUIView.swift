//
//  VerifyCodeSwiftUIView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 4/11/2025.
//

import SwiftUI

// ✅ ADD THIS: Response model for verify endpoint
struct VerifyResponse: Codable {
    struct UserData: Codable {
        let _id: String?
        let firstName: String
        let lastName: String
        let email: String
        let phoneNumber: String
        let role: String
        let isVerified: Bool
    }
    let user: UserData
    let message: String
    let access_token: String  // ✅ Verify returns token for auto-login
}

struct VerifyCodeView: View {
    @Environment(\.dismiss) var dismiss
    
    let email: String
    let phoneNumber: String?
    var onVerified: () -> Void = {}
    
    @State private var code: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    @State private var isLoading = false
    @State private var alertText: String?
    @State private var showAlert = false
    @State private var canResend = false
    @State private var countdown = 60
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Same background
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
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 45))
                                .foregroundStyle(.white)
                        )
                        .padding(.top, 40)
                        .padding(.bottom, 30)
                    
                    VStack(spacing: 0) {
                        // Title
                        Text("Verification Code")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundStyle(.black.opacity(0.9))
                            .padding(.bottom, 12)
                        
                        // Subtitle
                        Text("We've sent a 6-digit code to")
                            .font(.system(size: 16))
                            .foregroundStyle(.black.opacity(0.7))
                        Text(email)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.85))
                            .padding(.bottom, 40)
                        
                        // 6-digit code input
                        HStack(spacing: 12) {
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
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        
                        // Resend code
                        HStack(spacing: 6) {
                            Text("Didn't receive the code?")
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.7))
                            
                            if canResend {
                                Button("Resend") {
                                    resendCode()
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                            } else {
                                Text("(\(countdown)s)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(.bottom, 50)
                        
                        // Verify button
                        Button(action: verifyCode) {
                            HStack(spacing: 8) {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.85)
                                }
                                Text(isLoading ? "Verifying..." : "Verify")
                                    .font(.system(size: 18, weight: .bold))
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
                        .disabled(isLoading || !isCodeComplete)
                        .opacity(isCodeComplete ? 1.0 : 0.6)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 40)
                        
                    }
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
        .alert("Verification", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
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
    
    // MARK: - Actions
    
    private func handleCodeChange(index: Int, oldValue: String, newValue: String) {
        // Only allow digits
        let filtered = newValue.filter { $0.isNumber }
        
        if filtered.count > 1 {
            // Pasted code
            let digits = Array(filtered.prefix(6))
            for (i, digit) in digits.enumerated() where i < 6 {
                code[i] = String(digit)
            }
            focusedField = min(digits.count, 5)
        } else if filtered.count == 1 {
            code[index] = filtered
            // Move to next field
            if index < 5 {
                focusedField = index + 1
            } else {
                focusedField = nil // Dismiss keyboard
            }
        } else if newValue.isEmpty {
            code[index] = ""
            // Move to previous field on delete
            if index > 0 {
                focusedField = index - 1
            }
        }
    }
    
    private func startCountdown() {
        countdown = 60
        canResend = false
    }
    
    // ✅ FIXED: Decode response and save token
    private func verifyCode() {
        guard isCodeComplete else { return }
        
        isLoading = true
        
        let verifyRequest = VerifyAccountRequest(
            email: email,
            phoneNumber: phoneNumber,
            code: codeString
        )
        
        NetworkService.shared.postRequest(to: .verify, body: verifyRequest) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        // ✅ DECODE the verify response to get the token
                        let response = try JSONDecoder().decode(VerifyResponse.self, from: data)
                        
                        // ✅ SAVE the access token to keychain
                        let saved = KeychainHelper.shared.save(token: response.access_token, forKey: "access_token")
                        
                        if saved {
                            print("✅ Token saved successfully")
                            print("✅ User verified: \(response.user.firstName) \(response.user.lastName)")
                            onVerified()
                        } else {
                            self.alertText = "Verification succeeded but failed to save token. Please try logging in."
                            self.showAlert = true
                        }
                        
                    } catch {
                        // Show both error and raw response for debugging
                        let raw = String(data: data, encoding: .utf8) ?? "Unknown response"
                        self.alertText = "Failed to parse response: \(error.localizedDescription)\n\nRaw response: \(raw)"
                        self.showAlert = true
                        // Clear code on error
                        self.code = Array(repeating: "", count: 6)
                        self.focusedField = 0
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
        let resendRequest = ResendCodeRequest(
            email: email,
            phoneNumber: phoneNumber,
            channel: "email"
        )
        
        NetworkService.shared.postRequest(to: .resendCode, body: resendRequest) { result in
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
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isFocused ? Color(red: 0.95, green: 0.55, blue: 0.35) : Color.black.opacity(0.2), lineWidth: isFocused ? 2.5 : 1.5)
                .fill(Color.white.opacity(0.85))
                .frame(width: 50, height: 60)
                .shadow(color: isFocused ? Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.2) : .clear, radius: 8, x: 0, y: 4)
            
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.black.opacity(0.9))
                .frame(width: 50, height: 60)
                .background(Color.clear)
        }
    }
}

// MARK: - Request Models

struct VerifyAccountRequest: Codable {
    let email: String?
    let phoneNumber: String?
    let code: String
}

struct ResendCodeRequest: Codable {
    let email: String?
    let phoneNumber: String?
    let channel: String
}

#Preview {
    VerifyCodeView(email: "test@example.com", phoneNumber: nil)
}
