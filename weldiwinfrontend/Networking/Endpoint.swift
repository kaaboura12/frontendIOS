//
//  Endpoint.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 3/11/2025.
//

import Foundation

enum Endpoint {
    case register
    case login
    case googleLogin         // ✅ ADD THIS
    case profile
    case updateUser(userId: String)
    case verify
    case resendCode
    case forgotPassword
    case resetPassword
    case children
    case createChild
    case qrLogin
    case childProfile
    
    var url: URL? {
        switch self {
        case .register:
            return URL(string: API.baseURL + "auth/register")
        case .login:
            return URL(string: API.baseURL + "auth/login")
        case .googleLogin:       // ✅ ADD THIS
            return URL(string: API.baseURL + "auth/login/google")
        case .profile:
            return URL(string: API.baseURL + "users/profile")
        case .updateUser(let userId):
            return URL(string: API.baseURL + "users/\(userId)")
        case .verify:
            return URL(string: API.baseURL + "auth/verify")
        case .resendCode:
            return URL(string: API.baseURL + "auth/resend-code")
        case .forgotPassword:
            return URL(string: API.baseURL + "auth/forgot-password")
        case .resetPassword:
            return URL(string: API.baseURL + "auth/reset-password")
        case .children:
            return URL(string: API.baseURL + "children")
        case .createChild:
            return URL(string: API.baseURL + "children")
        case .qrLogin:
            return URL(string: API.baseURL + "auth/login/qr")
        case .childProfile:
            return URL(string: API.baseURL + "children/profile")
        }
    }
}
