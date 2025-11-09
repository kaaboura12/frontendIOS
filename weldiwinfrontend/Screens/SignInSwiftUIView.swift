import SwiftUI
import GoogleSignIn  // ✅ ADD THIS IMPORT

struct LoginResponse: Codable {
    struct User: Codable {
        let _id: String?
        let firstName: String
        let lastName: String
        let email: String
        let role: String
    }
    let user: User
    let access_token: String
}

struct SignInView: View {
    var onSignUp: () -> Void = {}
    var onForgotPassword: () -> Void = {}
    var onChildLogin: () -> Void = {}
    var onAuthenticated: () -> Void = {}

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var alertText: String?
    @State private var showAlert = false
    @StateObject private var googleSignInHelper = GoogleSignInHelper()  // ✅ ADD THIS
    var body: some View {
        ZStack {
            // Background
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 60)

                    // Logo
                    Image("Gemini_Generated_Image_qr0yhoqr0yhoqr0y-removebg-preview")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 20)

                    VStack(alignment: .leading, spacing: 0) {
                        // Sign In Header
                        Text("Sign In")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundStyle(.black.opacity(0.85))
                            .padding(.bottom, 8)

                        // Sign Up Link
                        HStack(spacing: 6) {
                            Text("Don't have an account ?")
                                .font(.system(size: 16))
                                .foregroundStyle(.black.opacity(0.75))
                            Button(action: onSignUp) {
                                Text("Sign Up")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                            }
                        }
                        .padding(.bottom, 24)

                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email :")
                                .font(.system(size: 20, weight: .semibold, design: .serif))
                                .foregroundStyle(.black.opacity(0.85))

                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .stroke(.black.opacity(0.25), lineWidth: 1.5)
                                    .fill(Color.white.opacity(0.75))
                                    .frame(height: 56)

                                TextField("", text: $email)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.black.opacity(0.85))
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                                    .padding(.horizontal, 18)
                            }
                        }
                        .padding(.bottom, 20)

                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password :")
                                .font(.system(size: 20, weight: .semibold, design: .serif))
                                .foregroundStyle(.black.opacity(0.85))

                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .stroke(.black.opacity(0.25), lineWidth: 1.5)
                                    .fill(Color.white.opacity(0.75))
                                    .frame(height: 56)

                                HStack {
                                    if showPassword {
                                        TextField("", text: $password)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.black.opacity(0.85))
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled()
                                    } else {
                                        SecureField("", text: $password)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.black.opacity(0.85))
                                    }

                                    Button(action: { showPassword.toggle() }) {
                                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.black.opacity(0.65))
                                            .frame(width: 40, height: 40)
                                    }
                                }
                                .padding(.leading, 18)
                                .padding(.trailing, 8)
                            }
                        }
                        .padding(.bottom, 16)

                        // Forgot Password
                        Button(action: onForgotPassword) {
                            Text("Forgot Password ?")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                        }
                        .padding(.bottom, 50)

                        // Sign In Button
                        Button(action: submit) {
                            HStack(spacing: 8) {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.85)
                                }
                                Text(isLoading ? "Signing In..." : "Sign In")
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
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4), radius: 12, x: 0, y: 6)
                            )
                        }
                        .disabled(isLoading)
                        .padding(.bottom, 20)

                        // Sign in as child button
                        Button(action: onChildLogin) {
                            Text("Sign in as child")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .stroke(Color(red: 0.95, green: 0.55, blue: 0.35), lineWidth: 2)
                                        .fill(.white.opacity(0.5))
                                )
                        }
                        .padding(.bottom, 40)

                        // Social Icons - ✅ UPDATED THIS SECTION
                        HStack(spacing: 40) {
                            Spacer()
                            SocialIconButton(icon: "paperplane.fill")

                            // Google Sign-In Button
                            Button(action: handleGoogleSignIn) {
                                Circle()
                                    .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: "globe")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(.white)
                                    )
                                    .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3), radius: 8, x: 0, y: 4)
                            }

                            SocialIconButton(icon: "camera.fill")
                            Spacer()
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 28)
                }
            }
        }
        .alert("Sign In", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertText ?? "")
        }
    }

    // MARK: - Actions
    private func submit() {
        if let message = validate() {
            alertText = message
            showAlert = true
            return
        }

        isLoading = true

        let loginRequest = LoginRequest(
            email: email.lowercased().trimmingCharacters(in: .whitespaces),
            password: password
        )

        NetworkService.shared.postRequest(to: .login, body: loginRequest) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                        let saved = KeychainHelper.shared.save(token: response.access_token, forKey: "access_token")

                        if saved {
                            print("✅ Token stored securely in Keychain")
                            onAuthenticated()
                        } else {
                            print("❌ Failed to store token in Keychain")
                            self.alertText = "Failed to save session. Please try again."
                            self.showAlert = true
                        }
                    } catch {
                        self.alertText = String(data: data, encoding: .utf8) ?? "Login succeeded, but parsing failed."
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
        if email.isEmpty { return "Email is required." }
        if !email.contains("@") { return "Enter a valid email." }
        if password.isEmpty { return "Password is required." }
        if password.count < 6 { return "Password must be at least 6 characters." }
        return nil
    }
    
    // ✅ ADD THIS NEW FUNCTION
    // MARK: - Google Sign-In
    private func handleGoogleSignIn() {
        isLoading = true
        
        googleSignInHelper.signIn { result in
            switch result {
            case .success(let idToken):
                // Authenticate with backend
                googleSignInHelper.authenticateWithBackend(idToken: idToken) { backendResult in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        
                        switch backendResult {
                        case .success(let response):
                            // Save token and navigate
                            let saved = KeychainHelper.shared.save(token: response.access_token, forKey: "access_token")
                            if saved {
                                print("✅ Google Sign-In successful!")
                                onAuthenticated()
                            } else {
                                self.alertText = "Failed to save session"
                                self.showAlert = true
                            }
                        case .failure(let error):
                            self.alertText = "Google Sign-In failed: \(error.localizedDescription)"
                            self.showAlert = true
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.alertText = "Google Sign-In error: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
}

// MARK: - Social Icon Button

private struct SocialIconButton: View {
    let icon: String
    var body: some View {
        Button(action: {}) {
            Circle()
                .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                )
                .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - Login Request Model

struct LoginRequest: Codable {
    let email: String
    let password: String
}

#Preview {
    SignInView()
}
