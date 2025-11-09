import SwiftUI

// ✅ FIXED: Register does NOT return access_token
struct RegisterResponse: Codable {
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
    let message: String  // Backend returns message, not token
}

struct SignUpView: View {
    var onSignIn: () -> Void = {}
    var onVerify: (_ email: String, _ phoneNumber: String?) -> Void = { _, _ in }

    // Backend-required
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // Optional
    @State private var role: UserRole = .parent
    @State private var avatarUrl: String? = nil
    
    // UI state
    @State private var showPassword = false
    @State private var showConfirm = false
    @State private var isLoading = false
    @State private var alertText: String?
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            // Background image
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Logo at top
                    Image("Gemini_Generated_Image_qr0yhoqr0yhoqr0y-removebg-preview")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.top, 50)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 18) {
                        // Header
                        Text("Sign Up")
                            .font(.system(size: 42, weight: .bold, design: .serif))
                            .foregroundStyle(.black.opacity(0.9))
                        
                        HStack(spacing: 6) {
                            Text("Already Have An Account")
                                .font(.system(size: 16))
                                .foregroundStyle(.black.opacity(0.75))
                            Button(action: onSignIn) {
                                Text("Sign In")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                            }
                        }
                        .padding(.bottom, 8)
                        
                        // Input fields - condensed
                        VStack(spacing: 12) {
                            // Name fields side by side
                            HStack(spacing: 12) {
                                CompactField(placeholder: "First Name", text: $firstName)
                                CompactField(placeholder: "Last Name", text: $lastName)
                            }
                            
                            CompactField(placeholder: "Email", text: $email, keyboard: .emailAddress, autocap: .never)
                            CompactField(placeholder: "Phone Number", text: $phoneNumber, keyboard: .phonePad, autocap: .never)
                            
                            CompactPasswordField(placeholder: "Password", text: $password, show: $showPassword)
                            CompactPasswordField(placeholder: "Confirm Password", text: $confirmPassword, show: $showConfirm)
                        }
                        
                        // Sign Up button
                        Button(action: submit) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.9)
                                }
                                Text(isLoading ? "Signing Up..." : "Sign Up")
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
                        .padding(.top, 10)
                        
                        // Social icons
                        HStack(spacing: 50) {
                            Spacer()
                            SocialIcon(name: "paperplane.fill")
                            SocialIcon(name: "globe")
                            SocialIcon(name: "camera.fill")
                            Spacer()
                        }
                        .padding(.top, 25)
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 28)
                }
            }
        }
        .alert("Sign Up", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertText ?? "")
        }
    }
    
    // MARK: - Actions
    
    // ✅ FIXED: Don't save token here, just navigate to verify
    private func submit() {
        if let message = validate() {
            alertText = message
            showAlert = true
            return
        }
        
        isLoading = true
        let payload = RegisterRequest(
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
            email: email.lowercased().trimmingCharacters(in: .whitespaces),
            phoneNumber: phoneNumber.trimmingCharacters(in: .whitespaces),
            password: password,
            role: role,
            avatarUrl: avatarUrl
        )
        
        NetworkService.shared.postRequest(to: .register, body: payload) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                        
                        // ✅ NO TOKEN STORAGE - just navigate to verify screen
                        print("✅ Registration successful: \(response.message)")
                        onVerify(email, phoneNumber)
                        
                    } catch {
                        // Show both error and raw response for debugging
                        let raw = String(data: data, encoding: .utf8) ?? "Unknown response"
                        self.alertText = "Failed to parse response: \(error.localizedDescription)\n\nRaw response: \(raw)"
                        self.showAlert = true
                    }
                case .failure(let error):
                    self.alertText = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
    
    private func validate() -> String? {
        if firstName.isEmpty { return "First name is required." }
        if lastName.isEmpty { return "Last name is required." }
        if email.isEmpty { return "Email is required." }
        if !email.contains("@") { return "Enter a valid email." }
        if phoneNumber.isEmpty { return "Phone number is required." }
        if password.count < 6 { return "Password must be at least 6 characters." }
        if password != confirmPassword { return "Passwords do not match." }
        return nil
    }
}

// MARK: - Compact field components

private struct CompactField: View {
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var autocap: TextInputAutocapitalization = .words
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white.opacity(0.85))
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder)
                        .foregroundStyle(.black.opacity(0.4))
                        .font(.system(size: 15))
                }
                .keyboardType(keyboard)
                .textInputAutocapitalization(autocap)
                .autocorrectionDisabled()
                .font(.system(size: 15))
                .foregroundStyle(.black.opacity(0.85))
                .padding(.horizontal, 18)
        }
        .frame(height: 50)
    }
}

private struct CompactPasswordField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var show: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white.opacity(0.85))
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            
            HStack(spacing: 0) {
                if show {
                    TextField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder)
                                .foregroundStyle(.black.opacity(0.4))
                                .font(.system(size: 15))
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.system(size: 15))
                        .foregroundStyle(.black.opacity(0.85))
                } else {
                    SecureField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder)
                                .foregroundStyle(.black.opacity(0.4))
                                .font(.system(size: 15))
                        }
                        .font(.system(size: 15))
                        .foregroundStyle(.black.opacity(0.85))
                }
                
                Button(action: { show.toggle() }) {
                    Image(systemName: show ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(.black.opacity(0.5))
                        .font(.system(size: 16))
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.leading, 18)
            .padding(.trailing, 4)
        }
        .frame(height: 50)
    }
}

private struct SocialIcon: View {
    let name: String
    
    var body: some View {
        Circle()
            .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
            .frame(width: 50, height: 50)
            .overlay(
                Image(systemName: name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
            )
            .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Placeholder extension

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    SignUpView()
}
