//
//  ChildProfileSwiftUIView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 6/11/2025.
//

import SwiftUI

// MARK: - Child Profile Response Model

struct ChildProfileResponse: Codable {
    let _id: String?
    let firstName: String
    let lastName: String
    let parent: ParentInfo
    let linkedParents: [ParentInfo]?
    let avatarUrl: String?
    let location: LocationData?
    let deviceId: String?
    let deviceType: String?
    let isOnline: Bool?
    let status: String
    let createdAt: String?
    let updatedAt: String?
}

struct ParentInfo: Codable {
    let _id: String?
    let firstName: String
    let lastName: String
    let email: String?
    let phoneNumber: String?
    let avatarUrl: String?
}

struct LocationData: Codable {
    let lat: Double?
    let lng: Double?
    let updatedAt: String?
}

struct ChildProfileSwiftUIView: View {
    @State private var profile: ChildProfileResponse?
    @State private var isLoading = true
    @State private var alertText: String?
    @State private var showAlert = false
    @State private var navigateToSignIn = false
    
    var body: some View {
        ZStack {
            // Background
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            if isLoading {
                // Loading state
                VStack(spacing: 20) {
                    ProgressView()
                        .tint(Color(red: 0.95, green: 0.55, blue: 0.35))
                        .scaleEffect(1.5)
                    Text("Loading profile...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                }
            } else if let profile = profile {
                // Profile content
                ScrollView {
                    VStack(spacing: 0) {
                        // Header with avatar
                        VStack(spacing: 16) {
                            // Avatar
                            ZStack {
                                Circle()
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
                                    .frame(width: 120, height: 120)
                                    .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4), radius: 15, x: 0, y: 8)
                                
                                if let avatarUrl = profile.avatarUrl, !avatarUrl.isEmpty {
                                    AsyncImage(url: URL(string: avatarUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 50))
                                            .foregroundStyle(.white)
                                    }
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 50))
                                        .foregroundStyle(.white)
                                }
                                
                                // Online status indicator
                                if profile.isOnline == true {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Circle()
                                                .stroke(.white, lineWidth: 3)
                                        )
                                        .offset(x: 45, y: 45)
                                }
                            }
                            .padding(.top, 20)
                            
                            // Name
                            Text("\(profile.firstName) \(profile.lastName)")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                                .foregroundStyle(.white)
                            
                            // Status badge
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(profile.status == "ACTIVE" ? .green : .gray)
                                    .frame(width: 8, height: 8)
                                Text(profile.status)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.9))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(.white.opacity(0.2))
                            )
                        }
                        .padding(.bottom, 30)
                        
                        // Info Cards
                        VStack(spacing: 16) {
                            // Device Info Card
                            InfoCard(
                                icon: profile.deviceType == "WATCH" ? "applewatch" : "iphone",
                                title: "Device",
                                value: profile.deviceType ?? "PHONE",
                                subtitle: profile.deviceId ?? "Not set"
                            )
                            
                            // Location Card
                            if let location = profile.location {
                                InfoCard(
                                    icon: "location.fill",
                                    title: "Location",
                                    value: String(format: "%.4f, %.4f", location.lat ?? 0, location.lng ?? 0),
                                    subtitle: location.updatedAt != nil ? "Updated recently" : "No update time"
                                )
                            } else {
                                InfoCard(
                                    icon: "location.slash.fill",
                                    title: "Location",
                                    value: "Not available",
                                    subtitle: "No location data"
                                )
                            }
                            
                            // Parent Card
                            ParentCard(
                                title: "Main Parent",
                                parent: profile.parent
                            )
                            
                            // Linked Parents Card
                            if let linkedParents = profile.linkedParents, !linkedParents.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "person.2.fill")
                                            .font(.system(size: 18))
                                            .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                                        Text("Linked Parents")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(.white)
                                        Spacer()
                                    }
                                    
                                    ForEach(linkedParents, id: \._id) { parent in
                                        ParentRow(parent: parent)
                                    }
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(.white.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .stroke(.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 30)
                        
                        // Logout Button
                        Button(action: logout) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.right.square")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Logout")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .fill(.red.opacity(0.7))
                                    .shadow(color: .red.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 40)
                    }
                }
            } else {
                // Error state
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white.opacity(0.7))
                    Text("Failed to load profile")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                    Button("Retry") {
                        loadProfile()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                    )
                    .foregroundStyle(.white)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadProfile()
        }
        .alert("Profile", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertText ?? "")
        }
        .background(
            NavigationLink(destination: AuthContainerView(), isActive: $navigateToSignIn) {
                EmptyView()
            }
            .hidden()
        )
    }
    
    // MARK: - Actions
    
    private func loadProfile() {
        guard let token = KeychainHelper.shared.get(forKey: "access_token") else {
            alertText = "Please sign in"
            showAlert = true
            navigateToSignIn = true
            return
        }
        
        isLoading = true
        
        NetworkService.shared.getRequest(to: .childProfile, token: token) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        self.profile = try JSONDecoder().decode(ChildProfileResponse.self, from: data)
                    } catch {
                        let raw = String(data: data, encoding: .utf8) ?? "Unknown"
                        self.alertText = "Failed to parse profile: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                case .failure(let error):
                    self.alertText = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
    
    private func logout() {
        _ = KeychainHelper.shared.delete(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "authRole")
        navigateToSignIn = true
    }
}

// MARK: - Info Card Component

private struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
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
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            
            Spacer()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Parent Card Component

private struct ParentCard: View {
    let title: String
    let parent: ParentInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            ParentRow(parent: parent)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Parent Row Component

private struct ParentRow: View {
    let parent: ParentInfo
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
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
                    .frame(width: 44, height: 44)
                
                if let avatarUrl = parent.avatarUrl, !avatarUrl.isEmpty {
                    AsyncImage(url: URL(string: avatarUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 2) {
                Text("\(parent.firstName) \(parent.lastName)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                
                if let email = parent.email {
                    Text(email)
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ChildProfileSwiftUIView()
}
