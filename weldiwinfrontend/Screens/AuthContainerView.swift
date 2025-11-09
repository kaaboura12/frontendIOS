import SwiftUI

enum AuthRoute: Hashable {
    case signUp
    case forgotPassword
    case verify(email: String, phoneNumber: String?)
    case resetPassword(email: String)
    case childLogin
    case childProfile
    case mainApp
}

private enum StoredAuthRole: String {
    case parent
    case child
}

@MainActor
struct AuthContainerView: View {
    @State private var path: [AuthRoute] = []
    @State private var isCheckingToken = true
    @AppStorage("authRole") private var storedRoleRaw: String?
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if isCheckingToken {
                    ProgressView()
                        .tint(Color(red: 0.95, green: 0.55, blue: 0.35))
                } else {
                    SignInView(
                        onSignUp: { path.append(.signUp) },
                        onForgotPassword: { path.append(.forgotPassword) },
                        onChildLogin: { path.append(.childLogin) },
                        onAuthenticated: { transitionToAuthenticated(role: .parent) }
                    )
                }
            }
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .signUp:
                    SignUpView(
                        onSignIn: { path = [] },
                        onVerify: { email, phone in
                            path.append(.verify(email: email, phoneNumber: phone))
                        }
                    )
                    
                case .forgotPassword:
                    ForgotPasswordView(
                        onBackToSignIn: { path = [] },
                        onReset: { email in
                            path.append(.resetPassword(email: email))
                        }
                    )
                    
                case let .verify(email, phoneNumber):
                    VerifyCodeView(
                        email: email,
                        phoneNumber: phoneNumber,
                        onVerified: { transitionToAuthenticated(role: .parent) }
                    )
                    
                case let .resetPassword(email):
                    ResetPasswordView(
                        email: email,
                        onFinished: { path = [] }
                    )
                    
                case .childLogin:
                    ScanQRCodeView(
                        onAuthenticated: { transitionToAuthenticated(role: .child) }
                    )
                    
                case .childProfile:
                    ChildProfileSwiftUIView()
                        .navigationBarBackButtonHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                    
                case .mainApp:
                    CustomTabBarView()
                        .navigationBarBackButtonHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
        }
        .task {
            await checkAuthenticationState()
        }
        .onChange(of: storedRoleRaw) { _ in
            Task { await handleRoleChange() }
        }
    }
    
    private func checkAuthenticationState() async {
        defer { isCheckingToken = false }
        
        guard KeychainHelper.shared.get(forKey: "access_token") != nil else {
            print("🔓 No token found, clearing auth role")
            storedRoleRaw = nil
            path = []
            return
        }
        
        print("🔐 Token exists, storedRoleRaw = \(storedRoleRaw ?? "nil")")
        
        if let roleRaw = storedRoleRaw, let role = StoredAuthRole(rawValue: roleRaw) {
            switch role {
            case .child:
                print("✅ Restoring child session")
                path = [.childProfile]
            case .parent:
                print("✅ Restoring parent session")
                path = [.mainApp]
            }
        } else {
            // No role stored but token exists - clear the orphaned token
            print("⚠️ Token exists but no role - clearing session")
            KeychainHelper.shared.delete(forKey: "access_token")
            storedRoleRaw = nil
            path = []
        }
    }
    
    private func handleRoleChange() async {
        if storedRoleRaw == nil {
            withAnimation(.easeInOut) {
                path.removeAll()
            }
            return
        }
        
        if let role = storedRoleRaw.flatMap(StoredAuthRole.init(rawValue:)) {
            withAnimation(.easeInOut) {
                path.removeAll()
                switch role {
                case .parent:
                    path.append(.mainApp)
                case .child:
                    path.append(.childProfile)
                }
            }
        }
    }
    
    private func transitionToAuthenticated(role: StoredAuthRole) {
        print("🎯 Transitioning to authenticated as: \(role.rawValue)")
        storedRoleRaw = role.rawValue
    }
}

#Preview {
    AuthContainerView()
}

