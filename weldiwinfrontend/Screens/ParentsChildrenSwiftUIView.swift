//
//  ParentsChildrenSwiftUIView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 9/11/2025.
//

import SwiftUI

// MARK: - Child Model for Parent's Children List
struct ParentChild: Codable, Identifiable {
    let _id: String
    let firstName: String
    let lastName: String
    let parent: ParentUser  // ✅ Object, not string
    let linkedParents: [ParentUser]?  // ✅ Array of objects
    let avatarUrl: String?
    let location: ChildLocation?
    let deviceId: String?
    let deviceType: String?
    let isOnline: Bool
    let status: String
    let qrCode: String?
    let createdAt: String?
    let updatedAt: String?
    
    var id: String { _id }
    
    // ✅ Parent user object structure
    struct ParentUser: Codable {
        let _id: String
        let firstName: String
        let lastName: String
        let email: String
        let role: String?
        let avatarUrl: String?
    }
    
    struct ChildLocation: Codable {
        let lat: Double
        let lng: Double
        let updatedAt: String?
    }
}

struct ParentsChildrenSwiftUIView: View {
    @State private var children: [ParentChild] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showAddChild = false
    @State private var selectedChild: ParentChild?
    @State private var showChildDetail = false
    
    var body: some View {
        ZStack {
            // Background matching app theme
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // HEADER
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Children")
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                .foregroundColor(.black.opacity(0.85))
                            
                            Text("\(children.count) child\(children.count != 1 ? "ren" : "")")
                                .font(.system(size: 16))
                                .foregroundColor(.black.opacity(0.55))
                        }
                        
                        Spacer()
                        
                        // Add child button
                        Button(action: {
                            showAddChild = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                                .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 60)
                    .padding(.bottom, 24)
                }
                
                // CONTENT
                if isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Color(red: 0.95, green: 0.55, blue: 0.35))
                    Spacer()
                } else if let error = errorMessage {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.6))
                        
                        Text("Oops!")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(.black.opacity(0.85))
                        
                        Text(error)
                            .font(.system(size: 16))
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: loadChildren) {
                            Text("Try Again")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 180, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
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
                                        .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4), radius: 8, x: 0, y: 4)
                                )
                        }
                        .padding(.top, 10)
                    }
                    Spacer()
                } else if children.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4))
                        
                        Text("No Children Yet")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(.black.opacity(0.85))
                        
                        Text("Add your first child to get started")
                            .font(.system(size: 16))
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            showAddChild = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20))
                                Text("Add Child")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(width: 180, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
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
                                    .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 40)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(children) { child in
                                ParentChildCard(child: child)
                                    .onTapGesture {
                                        selectedChild = child
                                        showChildDetail = true
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadChildren()
        }
        .sheet(isPresented: $showAddChild) {
            AddChildFormView(onChildAdded: {
                loadChildren()
            })
        }
        .sheet(item: $selectedChild) { child in
            ParentChildDetailView(child: child)
        }
    }
    
    // MARK: - Load Children
    private func loadChildren() {
        isLoading = true
        errorMessage = nil
        
        guard let token = KeychainHelper.shared.get(forKey: "access_token") else {
            errorMessage = "Please sign in"
            isLoading = false
            return
        }
        
        NetworkService.shared.getRequest(to: .children, token: token) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    // ✅ Debug: Print response
                    print("📥 Response: \(String(data: data, encoding: .utf8) ?? "nil")")
                    
                    do {
                        let fetchedChildren = try JSONDecoder().decode([ParentChild].self, from: data)
                        self.children = fetchedChildren
                        print("✅ Loaded \(fetchedChildren.count) children")
                    } catch {
                        print("❌ Decode error: \(error)")
                        self.errorMessage = "Failed to load children"
                    }
                case .failure(let error):
                    print("❌ Network error: \(error)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - Parent Child Card Component

private struct ParentChildCard: View {
    let child: ParentChild
    
    var body: some View {
        HStack(spacing: 16) {
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
                    .frame(width: 70, height: 70)
                
                Text("\(child.firstName.prefix(1))\(child.lastName.prefix(1))")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                // Online indicator
                if child.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2.5)
                        )
                        .offset(x: 25, y: 25)
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text("\(child.firstName) \(child.lastName)")
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundColor(.black.opacity(0.85))
                
                HStack(spacing: 12) {
                    // Status
                    HStack(spacing: 4) {
                        Circle()
                            .fill(child.isOnline ? Color.green : Color.gray)
                            .frame(width: 8, height: 8)
                        Text(child.isOnline ? "Online" : "Offline")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.55))
                    }
                    
                    // Device type
                    if let deviceType = child.deviceType {
                        HStack(spacing: 4) {
                            Image(systemName: deviceType == "WATCH" ? "applewatch" : "iphone")
                                .font(.system(size: 12))
                                .foregroundColor(.black.opacity(0.55))
                            Text(deviceType.capitalized)
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.55))
                        }
                    }
                }
                
                // Location
                if let location = child.location {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                        Text("Last seen location")
                            .font(.system(size: 13))
                            .foregroundColor(.black.opacity(0.5))
                    }
                }
            }
            
            Spacer()
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.6))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.85))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Parent Child Detail View

// MARK: - Parent Child Detail View (Enhanced)

private struct ParentChildDetailView: View {
    let child: ParentChild
    @Environment(\.dismiss) var dismiss
    @State private var showQRCode = false
    
    var body: some View {
        ZStack {
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header with close button
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    // Avatar with online status
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
                            .frame(width: 130, height: 130)
                            .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4), radius: 15, x: 0, y: 8)
                        
                        Text("\(child.firstName.prefix(1))\(child.lastName.prefix(1))")
                            .font(.system(size: 52, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Online indicator
                        if child.isOnline {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                )
                                .offset(x: 45, y: 45)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Name
                    Text("\(child.firstName) \(child.lastName)")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(.black.opacity(0.85))
                        .padding(.bottom, 8)
                    
                    // Status
                    HStack(spacing: 6) {
                        Circle()
                            .fill(child.isOnline ? Color.green : Color.gray)
                            .frame(width: 10, height: 10)
                        Text(child.isOnline ? "Online" : "Offline")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 16) {
                        // Info Cards Section
                        VStack(spacing: 12) {
                            // Parent Info
                            InfoCard(
                                icon: "person.fill",
                                title: "Parent",
                                value: "\(child.parent.firstName) \(child.parent.lastName)",
                                color: Color(red: 0.95, green: 0.55, blue: 0.35)
                            )
                            
                            // Device Type
                            if let deviceType = child.deviceType {
                                InfoCard(
                                    icon: deviceType == "WATCH" ? "applewatch" : "iphone",
                                    title: "Device",
                                    value: deviceType.capitalized,
                                    color: Color.blue
                                )
                            }
                            
                            // Status
                            InfoCard(
                                icon: "checkmark.shield.fill",
                                title: "Account Status",
                                value: child.status.capitalized,
                                color: Color.green
                            )
                            
                            // Location
                            if let location = child.location {
                                InfoCard(
                                    icon: "location.fill",
                                    title: "Last Location",
                                    value: "Lat: \(String(format: "%.4f", location.lat)), Lng: \(String(format: "%.4f", location.lng))",
                                    color: Color.orange
                                )
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 20)
                        
                        // QR Code Section
                        if let qrCode = child.qrCode {
                            VStack(spacing: 16) {
                                Text("Login QR Code")
                                    .font(.system(size: 20, weight: .bold, design: .serif))
                                    .foregroundColor(.black.opacity(0.85))
                                
                                Button(action: {
                                    showQRCode = true
                                }) {
                                    VStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .fill(Color.white.opacity(0.9))
                                                .frame(width: 200, height: 200)
                                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                            
                                            Image(systemName: "qrcode")
                                                .font(.system(size: 100))
                                                .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                                        }
                                        
                                        HStack(spacing: 8) {
                                            Image(systemName: "hand.tap.fill")
                                                .font(.system(size: 14))
                                            Text("Tap to view full QR code")
                                                .font(.system(size: 15, weight: .medium))
                                        }
                                        .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                                    }
                                }
                            }
                            .padding(.horizontal, 28)
                            .padding(.bottom, 30)
                        }
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            // View QR Code Button
                            if child.qrCode != nil {
                                Button(action: {
                                    showQRCode = true
                                }) {
                                    HStack(spacing: 10) {
                                        Image(systemName: "qrcode.viewfinder")
                                            .font(.system(size: 20))
                                        Text("View QR Code")
                                            .font(.system(size: 18, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
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
                            }
                            
                            // Edit Child Button
                            Button(action: {
                                // TODO: Navigate to edit child
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 20))
                                    Text("Edit Details")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                                        .stroke(Color(red: 0.95, green: 0.55, blue: 0.35), lineWidth: 2)
                                        .fill(Color.white.opacity(0.7))
                                )
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showQRCode) {
            if let qrCode = child.qrCode {
                DisplayQRCodeView(
                    qrCode: qrCode,
                    childName: "\(child.firstName) \(child.lastName)"
                )
            }
        }
    }
}

// MARK: - Info Card Component

private struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black.opacity(0.55))
                
                Text(value)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black.opacity(0.85))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.85))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
        )
    }
}

private struct AddChildFormView: View {
    @Environment(\.dismiss) var dismiss
    let onChildAdded: () -> Void
    
    var body: some View {
        AddChildView(onChildAdded: onChildAdded)
    }
}

#Preview {
    ParentsChildrenSwiftUIView()
}
