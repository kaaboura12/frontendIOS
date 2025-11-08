//
//  RegisterRequest.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 3/11/2025.
//

import Foundation

enum UserRole: String, Codable {
    case parent = "PARENT"
    case child = "CHILD"
    // Add other roles if your backend supports them
}

struct RegisterRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let password: String
    let role: UserRole?
    let avatarUrl: String?
}
